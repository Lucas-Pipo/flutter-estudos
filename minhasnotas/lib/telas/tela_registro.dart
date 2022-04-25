import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as ferramentasdev show log;

import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/utilidades/mostrar_dialogo_erro.dart';

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
    _senha.dispose();
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: senha,
                );
                final usuario = FirebaseAuth.instance.currentUser;
                await usuario?.sendEmailVerification();
                Navigator.of(context).pushNamed(verificarRotaEmail);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await mostrarErroDialogo(
                    context,
                    'Senha fraca',
                  );
                } else if (e.code == 'email-already-in-use') {
                  await mostrarErroDialogo(
                    context,
                    'Este e-mail já está em uso',
                  );
                } else if (e.code == 'invalid-email') {
                  await mostrarErroDialogo(
                    context,
                    'E-mail inválido',
                  );
                } else {
                  await mostrarErroDialogo(
                    context,
                    'Erro: {e.code}',
                  );
                }
              } catch (e) {
                await mostrarErroDialogo(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Registrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRota, (route) => false);
            },
            child: const Text('Já está registrado? Faça o Login aqui!'),
          )
        ],
      ),
    );
  }
}
