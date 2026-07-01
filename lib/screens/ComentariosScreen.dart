import 'package:flutter/material.dart';
import 'package:proyecto_moviles3/main.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';

class ComentariosScreen extends StatefulWidget {
  final dynamic pelicula;

  const ComentariosScreen({super.key, required this.pelicula});

  @override
  State<ComentariosScreen> createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  List<Map<String, dynamic>> comentarios = [];
  bool isLoading = true;
  final TextEditingController comentarioController = TextEditingController();
  bool isEnviando = false;

  @override
  void initState() {
    super.initState();
    cargarComentarios();
  }

  //funcion cargar comentarios con join a usuarios
  Future<void> cargarComentarios() async {
    try {
      final peliculaId = widget.pelicula['id'].toString();
      
      final response = await supabase
          .from('comentarios')
          .select('''
            *,
            usuarios!inner (
              username,
              nombre_completo
            )
          ''')
          .eq('pelicula_id', peliculaId)
          .order('fecha', ascending: false);
      
      setState(() {
        comentarios = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('error al cargar comentarios: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  //funcion obtener id del usuario logueado
  Future<int?> obtenerUsuarioId() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('usuarios')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      return response?['id'];
    } catch (e) {
      print('error al obtener usuario id: $e');
      return null;
    }
  }

  //funcion enviar comentario
  Future<void> enviarComentario() async {
    final texto = comentarioController.text.trim();
    if (texto.isEmpty) return;

    final user = supabase.auth.currentUser;
    if (user == null) {
      mostrarMensaje('Debes iniciar sesion para comentar');
      return;
    }

    final usuarioId = await obtenerUsuarioId();
    if (usuarioId == null) {
      mostrarMensaje('Error al obtener tus datos');
      return;
    }

    setState(() {
      isEnviando = true;
    });

    try {
      final nuevoComentario = {
        'pelicula_id': widget.pelicula['id'].toString(),
        'usuario_id': usuarioId,
        'comentario': texto,
      };

      final response = await supabase
          .from('comentarios')
          .insert(nuevoComentario)
          .select('''
            *,
            usuarios!inner (
              username,
              nombre_completo
            )
          ''')
          .single();

      setState(() {
        comentarios.insert(0, Map<String, dynamic>.from(response));
        comentarioController.clear();
        isEnviando = false;
      });

      mostrarMensaje('Comentario agregado');
    } catch (e) {
      print('error al enviar comentario: $e');
      setState(() {
        isEnviando = false;
      });
      mostrarMensaje('Error al enviar comentario');
    }
  }

  //funcion dar like
  Future<void> darLike(int index) async {
    final comentario = comentarios[index];
    final id = comentario['id'];
    final likesActuales = comentario['likes'] ?? 0;

    try {
      await supabase
          .from('comentarios')
          .update({'likes': likesActuales + 1})
          .eq('id', id);

      setState(() {
        comentarios[index]['likes'] = likesActuales + 1;
      });
    } catch (e) {
      print('error al dar like: $e');
    }
  }

  //funcion eliminar comentario
  Future<void> eliminarComentario(int index) async {
    final comentario = comentarios[index];
    final usuarioId = await obtenerUsuarioId();
    
    if (comentario['usuario_id'] != usuarioId) {
      mostrarMensaje('Solo puedes eliminar tus propios comentarios');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Eliminar Comentario',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            '¿Estas seguro de que quieres eliminar este comentario?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await supabase
                      .from('comentarios')
                      .delete()
                      .eq('id', comentario['id']);
                  
                  setState(() {
                    comentarios.removeAt(index);
                  });
                  Navigator.pop(context);
                  mostrarMensaje('Comentario eliminado');
                } catch (e) {
                  print('error al eliminar: $e');
                  mostrarMensaje('Error al eliminar comentario');
                }
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  //funcion mostrar mensaje
  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Comentarios - ${widget.pelicula['name'] ?? ''}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: cargarComentarios,
          ),
        ],
      ),
      body: Column(
        children: [
          //campo para escribir comentario
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                //avatar usuario
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[800],
                  child: FutureBuilder<String?>(
                    future: obtenerInicialUsuario(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: comentarioController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe un comentario...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: isEnviando ? null : enviarComentario,
                    icon: isEnviando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
          //lista de comentarios
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                : comentarios.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              color: Colors.grey[600],
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay comentarios',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Se el primero en comentar',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: comentarios.length,
                        itemBuilder: (context, index) {
                          final comentario = comentarios[index];
                          final usuarioId = obtenerUsuarioId();
                          
                          return FutureBuilder<int?>(
                            future: usuarioId,
                            builder: (context, snapshot) {
                              final esAutor = snapshot.data == comentario['usuario_id'];
                              return construirTarjetaComentario(
                                comentario: comentario,
                                index: index,
                                esAutor: esAutor,
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  //funcion obtener inicial del usuario
  Future<String?> obtenerInicialUsuario() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return '?';

      final response = await supabase
          .from('usuarios')
          .select('username')
          .eq('user_id', user.id)
          .maybeSingle();

      final username = response?['username'] ?? user.email?.split('@').first ?? '?';
      return username.substring(0, 1).toUpperCase();
    } catch (e) {
      return '?';
    }
  }

  //widget tarjeta comentario
  Widget construirTarjetaComentario({
    required Map<String, dynamic> comentario,
    required int index,
    required bool esAutor,
  }) {
    final fecha = comentario['fecha'] != null
        ? DateTime.parse(comentario['fecha']).toString().split(' ').first
        : 'fecha desconocida';

    final usuarioData = comentario['usuarios'] as Map<String, dynamic>?;
    final username = usuarioData?['username'] ?? 'usuario';
    final nombreCompleto = usuarioData?['nombre_completo'] ?? username;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: esAutor ? Colors.red.withOpacity(0.3) : Colors.grey[800]!,
          width: esAutor ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[800],
            child: Text(
              username.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          //contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      nombreCompleto,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fecha,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                    if (esAutor) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'tu',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comentario['comentario'] ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                //botones accion
                Row(
                  children: [
                    //boton like
                    GestureDetector(
                      onTap: () => darLike(index),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.grey[400],
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comentario['likes'] ?? 0}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    //boton eliminar (solo autor)
                    if (esAutor)
                      GestureDetector(
                        onTap: () => eliminarComentario(index),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Eliminar',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}