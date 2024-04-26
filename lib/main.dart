//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Registro());
}

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicación de Registro de Usuarios',
      home: Registrar(),
    );
  }
}

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final _formKey = GlobalKey<FormState>();
  final _controladorEmail = TextEditingController();
  final _controladorClave = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        // aqui centrado y color de la barra
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _controladorEmail,
                decoration:
                    const InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa un correo eléctronico';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _controladorClave,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 32.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registrarUsuario(
                        _controladorEmail.text, _controladorClave.text);
                  }
                  print('pase por aqui');
                  _controladorClave.clear();
                  _controladorEmail.clear();
                },
                child: const Text('Registrarse'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _registrarUsuario(String correo, String clave) async {
  try {
    final UserCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: correo,
      password: clave,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-passworde') {
      print('la contraseña es muy débil');
    } else if (e.code == 'email-already-in-use') {
      print('el correo eléctronico ya está en uso');
    } else {
      print('error al registrar el correo');
    }
  }
}
