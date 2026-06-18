import 'package:flutter/material.dart';
import 'PaginaLogin.dart';
import 'PaginaFormulario.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Encabezado
            const Text(
              'FLIXTREAM',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Descripción
            const Text(
              'Puedes ver cualquier película',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 10),
            
            const Text(
              'a la hora que tu quieras',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 50),
            
            // Botón Iniciar Sesión
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaginaLogin()),
                );
              },
              child: const Text('Iniciar Sesión'),
            ),
            
            const SizedBox(height: 20),
            
            // Botón Registrarme
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaginaFormulario()),
                );
              },
              child: const Text('Registrarme'),
            ),
          ],
        ),
      ),
    );
  }
}