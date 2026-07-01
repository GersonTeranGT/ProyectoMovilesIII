import 'package:flutter/material.dart';
import 'package:proyecto_moviles3/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///////////////////////////////////////////////////////////
import 'dart:io';
import 'package:image_picker/image_picker.dart';
///////////////////////////////////////////////////////////

class PaginaFormulario extends StatelessWidget {
  const PaginaFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Center(
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
                Text(""),
                const Formulario()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
////////////////////////////////////////////////////////////
  TextEditingController nombre = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController edad = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contrasenia = TextEditingController();

  XFile? foto;
////////////////////////////////////////////////////////////

////////////////////ACTUALIZAR IMAGEN//////////////////////
  void actualizarImagen(XFile? nuevaImagen) {
    setState(() {
      foto = nuevaImagen;
    });
  }
//////////////////////////////////////////////////////////

/////////////////////ABRIR GALERIA///////////////////////////
  Future<void> abrirGaleria() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    actualizarImagen(imagen);
  }
////////////////////////////////////////////////////////////

/////////////////////ABRIR CAMARA///////////////////////////
  Future<void> abrirCamara() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    actualizarImagen(imagen);
  }
////////////////////////////////////////////////////////////

/////////////////////MOSTRAR OPCIONES////////////////////////
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
            "Seleccionar Imagen",
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
                  color: Colors.blue,
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
                  color: Colors.green,
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
        );
      },
    );
  }
////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
////////////////////////////////////////////////////////////
        GestureDetector(
          onTap: mostrarOpcionesImagen,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.red,
            backgroundImage: foto != null
                ? FileImage(
                    File(foto!.path),
                  )
                : null,
            child: foto == null
                ? const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 35,
                  )
                : null,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Seleccionar Foto",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
////////////////////////////////////////////////////////////

        Text(""),

        TextField(
          controller: nombre,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: "Nombre Completo",
            labelStyle: const TextStyle(color: Colors.grey),
          ),
        ),

        Text(""),

        TextField(
          controller: username,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: "Usuario / Username",
            labelStyle: const TextStyle(color: Colors.grey),
          ),
        ),

        Text(""),

        TextField(
          controller: edad,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: "Edad",
            labelStyle: const TextStyle(color: Colors.grey),
          ),
        ),

        Text(""),

        TextField(
          controller: correo,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: "Correo Electronico",
            labelStyle: const TextStyle(color: Colors.grey),
          ),
        ),

        Text(""),

        TextField(
          controller: contrasenia,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: "Contraseña",
            labelStyle: const TextStyle(color: Colors.grey),
          ),
        ),

        Text(""),

        TextField(
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: "Confirmar Contraseña",
            labelStyle: const TextStyle(color: Colors.grey),
          ),
        ),

        Text(""),

        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 15,
            ),
          ),
          onPressed: () => registro(
            context,
            nombre,
            username,
            edad,
            correo,
            contrasenia,
            foto,
          ),
          child: const Text(
            "Registrate",
            style: TextStyle(color: Colors.white),
          ),
        ),

        Text(""),

        const Text(
          "Ya tienes una cuenta ?",
          style: TextStyle(color: Colors.white70),
        ),

        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () => Navigator.pushNamed(context, "/paginaLogin"),
          child: const Text(
            "Iniciar sesion",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

Future<void> registro(
    context, nombre, username, edad, correo, contrasenia, XFile? foto) async {
  try {
    final AuthResponse res = await supabase.auth.signUp(
      email: correo.text,
      password: contrasenia.text,
    );
    final Session? session = res.session;
    final User? user = res.user;

////////////////////////////////////////////////////////////
    String? urlImagen;
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
    if (foto != null && user != null) {
      final avatarFile = File(foto.path);
      final nombreImagen = "avatares/${user.id}.png";
      await supabase.storage.from('Avatares').upload(
            nombreImagen,
            avatarFile,
            fileOptions: const FileOptions(
              upsert: true,
            ),
          );

      urlImagen = supabase.storage.from('Avatares').getPublicUrl(nombreImagen);
    }
////////////////////////////////////////////////////////////

    if (user != null) {
      await supabase.from('usuarios').insert({
        'user_id': user.id,
        'nombre_completo': nombre.text,
        'username': username.text,
        'edad': int.parse(edad.text),
        'correo': correo.text,
        'foto': urlImagen,
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text(
                "Bienvenido/a",
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          content: Text(
            "Registro exitoso",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/paginaLogin");
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                "Iniciar sesion",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text(
                "Error",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          content: Text(
            "El correo ya está registrado",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
