import 'package:flutter/material.dart';
import 'package:proyecto_moviles3/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaginaLogin extends StatelessWidget {
  const PaginaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Bienvenido a FLIXTREAM",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(""),
            Text(
              "Iniciar sesion",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            formulario(context)
          ],
        ),
      ),
    );
  }
}

Widget formulario(context) {
  TextEditingController correo = TextEditingController();
  TextEditingController contrasenia = TextEditingController();

  return Column(
    children: [
      TextField(
        controller: correo,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8)),
          labelText: "Correo Electronico",
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),

      Text(""),

      TextField(
        controller: contrasenia,
        obscureText: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8)),
          labelText: "Contraseña",
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),

      Text(""),

      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        onPressed: () => login(context, correo, contrasenia),
        child: Text("Login", style: TextStyle(color: Colors.white)),
      ),

      Text(""),

      Text(
        "No tienes una cuenta ¿?",
        style: TextStyle(color: Colors.white70),
      ),

      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () => Navigator.pushNamed(context, "/paginaFormulario"),
        child: Text("Registrate", style: TextStyle(color: Colors.white)),
      ),
    ],
  );
}

Future<void> login(BuildContext context, TextEditingController correo, TextEditingController contrasenia) async {
  try {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: correo.text,
      password: contrasenia.text,
    );
    
    final Session? session = res.session;
    final User? user = res.user;

    if (session != null && user != null) {
      Navigator.pushReplacementNamed(context, "/HomeScreen");
    } else {
      mostrarError(context, "Credenciales incorrectas o no existentes");
    }
  } catch (e) {
    mostrarError(context, "Credenciales incorrectas o no existentes");
  }
}

void mostrarError(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Error de autenticación"),
      content: Text(mensaje),
      backgroundColor: Colors.grey[900],
      titleTextStyle: TextStyle(color: Colors.red, fontSize: 20),
      contentTextStyle: TextStyle(color: Colors.white),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cerrar", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}