import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaRegistro extends StatefulWidget {
  const TelaRegistro({Key? key}) : super(key: key);

  @override
  State<TelaRegistro> createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  late final TextEditingController _email;
  late final TextEditingController _senha;

  @override
  void initState() {
    _email = TextEditingController();
    _senha = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Escreva seu e-mail aqui!'),
          ),
          TextField(
            controller: _senha,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Escreva sua senha aqui!'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final senha = _senha.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: senha);
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('Senha fraca');
                } else if (e.code == 'email-already-in-use') {
                  print('E-mail já está em uso');
                } else if (e.code == 'invalid-email') {
                  print('Email inválido');
                }
              }
            },
            child: const Text('Registrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: const Text('Já está registrado? Faça o Login aqui!'),
          )
        ],
      ),
    );
  }
}
