import 'package:flutter/material.dart';
import 'package:proyecto_moviles3/main.dart';
import 'package:proyecto_moviles3/screens/PaginaLogin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

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
          };
        } else {
          userData = {
            'email': user.email ?? 'no disponible',
            'id': user.id,
            'created_at': user.createdAt?.toString() ?? 'no disponible',
            'nombre_completo': user.userMetadata?['nombre_completo'] ?? 'no disponible',
            'username': user.userMetadata?['username'] ?? user.email?.split('@').first ?? 'usuario',
            'edad': user.userMetadata?['edad']?.toString() ?? 'no disponible',
            'correo': user.email ?? 'no disponible',
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
                //limpiar toda la pila y navegar al login
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const PaginaLogin()),
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
                //avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red,
                      width: 3,
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/default_avatar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                //id usuario
                construirInfoCard(
                  icon: Icons.fingerprint,
                  label: 'ID de Usuario',
                  value: userData?['id'] ?? 'no disponible',
                  isCopyable: true,
                ),
                const SizedBox(height: 24),
                //botones accion
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          mostrarMensaje(context, 'Editar perfil');
                        },
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
                        icon: const Icon(Icons.exit_to_app, color: Colors.white),
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