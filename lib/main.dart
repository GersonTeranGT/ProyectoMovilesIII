import 'package:flutter/material.dart';
import 'package:proyecto_moviles3/screens/HomeScreen.dart';
import 'package:proyecto_moviles3/screens/PaginaFormulario.dart';
import 'package:proyecto_moviles3/screens/PaginaInicio.dart';
import 'package:proyecto_moviles3/screens/PaginaLogin.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context)=> PaginaInicio(),
        '/paginaFormulario': (context)=> PaginaFormulario(),
        '/paginaLogin': (context)=> PaginaLogin(),
        '/HomeScreen':(context) => HomeScreen()
        //'/': (context)=> ,
      },
    );
  }
}
