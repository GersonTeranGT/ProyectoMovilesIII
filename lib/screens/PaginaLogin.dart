import 'package:flutter/material.dart';

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
  return Column(
    children: [
      TextField(
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
          backgroundColor: Colors.red, // Botón rojo Netflix
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        onPressed: () => Navigator.pushNamed(context, "/HomeScreen"),
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