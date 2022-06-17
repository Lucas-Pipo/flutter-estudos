import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/servicos/autenticacao/excecao_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_deletar.dart';

import '../servicos/autenticacao/bloc/bloc_aut.dart';
import '../servicos/autenticacao/bloc/estado_aut.dart';
import '../servicos/autenticacao/bloc/event_aut.dart';
import '../utilidades/dialogos/dialogo_erro.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is SenhaFracaExcecao) {
            await mostrarErroDialogo(context, 'Senha fraca');
          } else if (state.exception is EmailEmUsoExececao) {
            await mostrarErroDialogo(context, 'Email já em uso');
          } else if (state.exception is EmailInvalidoExcecao) {
            await mostrarErroDialogo(context, 'Email inválido');
          } else if (state.exception is GenericaExcecao) {
            await mostrarErroDialogo(context, 'Falha ao registrar');
          }
        }
      },
      child: Scaffold(
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
                context.read<AuthBloc>().add(
                      AuthEventRegister(
                        email,
                        password,
                      ),
                    );
              },
              child: const Text('Registrar'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('Já está registrado? Faça o Login aqui!'),
            )
          ],
        ),
      ),
    );
  }
}
