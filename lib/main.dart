import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await _registrarUsuario(
                          _controladorEmail.text, _controladorClave.text);
                      // si hay registro exitoso manejar aqui algo que lo indique
                    } on FirebaseAuthException catch (e) {
                      // manejar error de autenticación
                    } catch (e) {
                      // manejar otros errores
                    } finally {
                      // código que ejecuta con error o sin error
                      _controladorClave.clear();
                      _controladorEmail.clear();
                    }
                  }
                  print('pasé por aqui');
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

_registrarUsuario(String correo, String clave) async {
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: correo,
      password: clave,
    );
    // registro exitoso (manejar el exito aqui)
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('la contraseña es muy débil');
    } else if (e.code == 'email-already-in-use') {
      print('el correo eléctronico ya está en uso');
    } else {
      print('error al registrar el correo');
    }
  }
}
