import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaDeVerificacao extends StatefulWidget {
  const TelaDeVerificacao({Key? key}) : super(key: key);

  @override
  State<TelaDeVerificacao> createState() => _TelaDeVerificacaoState();
}

class _TelaDeVerificacaoState extends State<TelaDeVerificacao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificação de E-mail')),
      body: Column(
        children: [
          const Text('Por favor verifique seu e-mail'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Me envie a confirmação de e-mail'),
          )
        ],
      ),
    );
  }
}