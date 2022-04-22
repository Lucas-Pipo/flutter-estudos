import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as ferramentasdev show log;

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
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
      appBar: AppBar(title: const Text('Login')),
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
                    .signInWithEmailAndPassword(email: email, password: senha);
                ferramentasdev.log(userCredential.toString());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/notas/', (route) => false);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  ferramentasdev.log('Usuário não encontrado');
                } else if (e.code == 'wrong-password') {
                  ferramentasdev.log('Senha incorreta');
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/registro/', (route) => false);
              },
              child: const Text('Ainda não é registrado? Registre aqui!'))
        ],
      ),
    );
  }
}
