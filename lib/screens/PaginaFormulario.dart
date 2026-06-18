import 'package:flutter/material.dart';

class PaginaFormulario extends StatelessWidget {
  const PaginaFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Formulario de Registro",
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(""),
            Text(
              "Llena el formulario para gozar de las mejores peliculas del momento",
              style: TextStyle(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: "Nombre Completo",
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),

      Text(""),

      TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: "Usuario / Username",
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),

      Text(""),

      TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: "Edad",
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),

      Text(""),

      TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: "Contraseña",
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: "Confirmar Contraseña",
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),

      Text(""),

      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        onPressed: () => Navigator.pushNamed(context, "/paginaLogin"),
        child: Text("Registrate", style: TextStyle(color: Colors.white)),
      ),

      Text(""),

      Text(
        "Ya tienes una cuenta ?",
        style: TextStyle(color: Colors.white70),
      ),

      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: () => Navigator.pushNamed(context, "/paginaLogin"),
        child: Text("Iniciar sesion", style: TextStyle(color: Colors.white)),
      ),
    ],
  );
}
