import 'package:flutter/material.dart';
import 'package:proyecto_moviles3/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  TextEditingController nombre = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController edad = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contrasenia = TextEditingController();

  return Column(
    children: [
      TextField(
        controller: nombre,
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
        controller: username,
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
        controller: edad,
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
        controller: correo,
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
        controller: contrasenia,
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
        onPressed: () =>
            registro(context, nombre, username, edad, correo, contrasenia),
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

Future<void> registro(
    context, nombre, username, edad, correo, contrasenia) async {
  final AuthResponse res = await supabase.auth.signUp(
    email: correo.text,
    password: contrasenia.text,
  );
  final Session? session = res.session;
  final User? user = res.user;

  if (user != null) {
    await supabase.from('usuarios').insert({
      'user_id': user.id,
      'nombre_completo': nombre.text,
      'username': username.text,
      'edad': int.parse(edad.text),
      'correo': correo.text,
    });
  }

  Navigator.pushNamed(context, "/paginaLogin");
}
