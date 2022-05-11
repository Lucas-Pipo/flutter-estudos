import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/servicos/autenticacao/excecao_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import 'package:minhasnotas/utilidades/mostrar_dialogo_erro.dart';

class TelaRegistro extends StatefulWidget {
  const TelaRegistro({Key? key}) : super(key: key);

  @override
  State<TelaRegistro> createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
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
                ServicoAut.firebase().createUser(
                  email: email,
                  password: password,
                );
                ServicoAut.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verificarRotaEmail);
              } on SenhaFracaExcecao {
                await mostrarErroDialogo(
                  context,
                  'Senha fraca',
                );
              } on EmailEmUsoExececao {
                await mostrarErroDialogo(
                  context,
                  'Este e-mail já está em uso',
                );
              } on EmailInvalidoExcecao {
                await mostrarErroDialogo(
                  context,
                  'E-mail inválido',
                );
              } on GenericaExcecao {
                await mostrarErroDialogo(
                  context,
                  'Falha ao Registrar',
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
