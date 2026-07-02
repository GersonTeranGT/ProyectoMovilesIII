import 'package:flutter/material.dart';
import 'package:proyecto_moviles3/main.dart';
import 'package:proyecto_moviles3/screens/PaginaInicio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  XFile? nuevaFoto;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  //funcion cargar datos usuario
  Future<void> cargarDatosUsuario() async {
    try {
      final user = supabase.auth.currentUser;

      if (user != null) {
        final response = await supabase
            .from('usuarios')
            .select()
            .eq('user_id', user.id)
            .maybeSingle();

        if (response != null) {
          userData = {
            'email': user.email ?? 'no disponible',
            'id': user.id,
            'created_at': user.createdAt?.toString() ?? 'no disponible',
            'nombre_completo': response['nombre_completo'] ?? 'no disponible',
            'username': response['username'] ?? 'no disponible',
            'edad': response['edad']?.toString() ?? 'no disponible',
            'correo': response['correo'] ?? user.email ?? 'no disponible',
            'foto': response['foto'] ?? '',
          };
        } else {
          userData = {
            'email': user.email ?? 'no disponible',
            'id': user.id,
            'created_at': user.createdAt?.toString() ?? 'no disponible',
            'nombre_completo':
                user.userMetadata?['nombre_completo'] ?? 'no disponible',
            'username': user.userMetadata?['username'] ??
                user.email?.split('@').first ??
                'usuario',
            'edad': user.userMetadata?['edad']?.toString() ?? 'no disponible',
            'correo': user.email ?? 'no disponible',
            'foto': '',
          };
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('error al cargar datos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  //funcion cerrar sesion - con limpieza de pila
  void cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Cerrar Sesion',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            '¿Estas seguro de que quieres cerrar sesion?',
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
                await supabase.auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const PaginaInicio()),
                  (route) => false,
                );
              },
              child: const Text(
                'Cerrar Sesion',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  //funcion editar perfil
  void editarPerfil(BuildContext context) {
    TextEditingController nombreController =
        TextEditingController(text: userData?['nombre_completo'] ?? '');
    TextEditingController usernameController =
        TextEditingController(text: userData?['username'] ?? '');
    TextEditingController edadController =
        TextEditingController(text: userData?['edad'] ?? '');
    TextEditingController emailController =
        TextEditingController(text: userData?['correo'] ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Editar Perfil',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: edadController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Edad',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electronico',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
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
              onPressed: () {
                Navigator.pop(context);
                mostrarConfirmacion(
                  context,
                  nombreController.text,
                  usernameController.text,
                  edadController.text,
                  emailController.text,
                );
              },
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  //funcion mostrar confirmacion
  void mostrarConfirmacion(BuildContext context, String nombre, String username,
      String edad, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Confirmar Cambios',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            '¿Estas seguro de realizar estos cambios?',
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
                Navigator.pop(context);
                await actualizarDatos(context, nombre, username, edad, email);
              },
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  //funcion actualizar datos
  Future<void> actualizarDatos(BuildContext context, String nombre,
      String username, String edad, String email) async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase.from('usuarios').update({
          'nombre_completo': nombre,
          'username': username,
          'edad': int.tryParse(edad) ?? 0,
          'correo': email,
        }).eq('user_id', user.id);

        setState(() {
          userData?['nombre_completo'] = nombre;
          userData?['username'] = username;
          userData?['edad'] = edad;
          userData?['correo'] = email;
        });

        mostrarMensajeExito(context, 'Se actualizaron los datos correctamente');
      }
    } catch (e) {
      mostrarMensajeError(context, 'Lo sentimos, hubo un problema');
    }
  }

  //funcion actualizar avatar
  Future<void> actualizarAvatar(BuildContext context, XFile? nuevaFoto) async {
    if (nuevaFoto == null) return;

    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final avatarFile = File(nuevaFoto.path);
        final nombreImagen = "avatares/${user.id}.png";

        await supabase.storage.from('Avatares').upload(
              nombreImagen,
              avatarFile,
              fileOptions: const FileOptions(
                upsert: true,
              ),
            );

        final urlImagen =
            supabase.storage.from('Avatares').getPublicUrl(nombreImagen);

        await supabase.from('usuarios').update({
          'foto': urlImagen,
        }).eq('user_id', user.id);

        setState(() {
          userData?['foto'] = urlImagen;
        });

        mostrarMensajeExito(
            context, 'Foto de perfil actualizada correctamente');
      }
    } catch (e) {
      mostrarMensajeError(
          context, 'Lo sentimos, hubo un problema al actualizar la foto');
    }
  }

  //funcion abrir galeria
  Future<void> abrirGaleria() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (imagen != null) {
      await actualizarAvatar(context, imagen);
    }
  }

  //funcion abrir camara
  Future<void> abrirCamara() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (imagen != null) {
      await actualizarAvatar(context, imagen);
    }
  }

//funcion mostrar opciones de imagen
  void mostrarOpcionesImagen() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Foto de perfil",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo,
                  color: Colors.red,
                ),
                title: const Text(
                  "Abrir Galería",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  abrirGaleria();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.red,
                ),
                title: const Text(
                  "Abrir Cámara",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  abrirCamara();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  //funcion mostrar mensaje exito
  void mostrarMensajeExito(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Exito',
            style: TextStyle(color: Colors.green),
          ),
          content: Text(
            mensaje,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  //funcion mostrar mensaje error
  void mostrarMensajeError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            mensaje,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              //configuracion adicional
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          : userData == null
              ? construirErrorWidget()
              : construirPerfilContent(),
    );
  }

  //widget error
  Widget construirErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 10),
          Text(
            'No se pudo cargar el perfil',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: cargarDatosUsuario,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Reintentar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  //widget contenido perfil
  Widget construirPerfilContent() {
    final nombre = userData?['nombre_completo'] ?? 'Usuario';
    final username = userData?['username'] ?? 'usuario';
    final email = userData?['correo'] ?? userData?['email'] ?? 'no disponible';
    final edad = userData?['edad'] ?? 'no disponible';
    final fechaRegistro = userData?['created_at']?.split(' ').first ?? '2024';
    final fotoUrl = userData?['foto'] ?? '';

    return SingleChildScrollView(
      child: Column(
        children: [
          //avatar y nombre
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.red.withOpacity(0.3),
                  Colors.black,
                ],
              ),
            ),
            child: Column(
              children: [
                //avatar - Ahora es clickeable para cambiar la foto
                GestureDetector(
                  onTap: mostrarOpcionesImagen,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red,
                        width: 3,
                      ),
                      image: fotoUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(fotoUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: fotoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 60,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Presiona el avatar para cambiar tu foto',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                //nombre completo
                Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$username',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                //miembro desde
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'miembro desde $fechaRegistro',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //informacion usuario
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'INFORMACION DE CUENTA',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                //nombre completo
                construirInfoCard(
                  icon: Icons.person,
                  label: 'Nombre Completo',
                  value: nombre,
                ),
                //username
                construirInfoCard(
                  icon: Icons.account_circle,
                  label: 'Usuario',
                  value: '@$username',
                ),
                //correo
                construirInfoCard(
                  icon: Icons.email,
                  label: 'Correo Electronico',
                  value: email,
                ),
                //edad
                construirInfoCard(
                  icon: Icons.cake,
                  label: 'Edad',
                  value: '$edad años',
                ),
                const SizedBox(height: 24),
                //botones accion
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => editarPerfil(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Editar Perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => cerrarSesion(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon:
                            const Icon(Icons.exit_to_app, color: Colors.white),
                        label: const Text(
                          'Cerrar Sesion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
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

  //widget tarjeta informacion
  Widget construirInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool isCopyable = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isCopyable)
            IconButton(
              icon: const Icon(
                Icons.copy,
                color: Colors.grey,
                size: 18,
              ),
              onPressed: () {
                mostrarMensaje(context, 'ID copiado al portapapeles');
              },
            ),
        ],
      ),
    );
  }

  //funcion mostrar mensaje
  void mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
