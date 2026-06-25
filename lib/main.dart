import 'package:flutter/material.dart';
import 'package:proyecto_moviles3/screens/HomeScreen.dart';
import 'package:proyecto_moviles3/screens/PaginaFormulario.dart';
import 'package:proyecto_moviles3/screens/PaginaInicio.dart';
import 'package:proyecto_moviles3/screens/PaginaLogin.dart';

//FIREBASE
//import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'firebase_options.dart';

Future<void> main() async {

  await Supabase.initialize(
    url: 'https://mqcfjkbwxugibempjbju.supabase.co',
    publishableKey: 'sb_publishable_6fjLsw-BOVNMAjN8fFILQQ_0PoeCrHu',
  );
  runApp(const MainApp());
}

//supabase
final supabase = Supabase.instance.client;
//////////////////////

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => PaginaInicio(),
        '/paginaFormulario': (context) => PaginaFormulario(),
        '/paginaLogin': (context) => PaginaLogin(),
        '/HomeScreen': (context) => HomeScreen(),
        //'/': (context)=> ,
      },
    );
  }
}