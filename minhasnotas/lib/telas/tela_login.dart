import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/servicos/autenticacao/excecao_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import '../utilidades/dialogos/dialogo_erro.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Escreva sua senha aqui!'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                ServicoAut.firebase().logIn(
                  email: email,
                  password: password,
                );
                final usuario = ServicoAut.firebase().currentUser;
                if (usuario?.emailEstaVerificado ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notasRota,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      verificarRotaEmail, (route) => false);
                }
              } on UsuarioNaoEncontradoExcecao {
                await mostrarErroDialogo(
                  context,
                  'Usuário não encontrado',
                );
              } on SenhaIncorretaExcecao {
                await mostrarErroDialogo(
                  context,
                  'Senha incorreta',
                );
              } on GenericaExcecao {
                await mostrarErroDialogo(
                  context,
                  'Erro de Autenticação',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registroRota, (route) => false);
              },
              child: const Text('Ainda não é registrado? Registre aqui!'))
        ],
      ),
    );
  }
}
