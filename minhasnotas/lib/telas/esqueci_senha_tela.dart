import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../servicos/autenticacao/bloc/bloc_aut.dart';
import '../servicos/autenticacao/bloc/estado_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/event_aut.dart';
import '../utilidades/dialogos/dialogo_erro.dart';
import '../utilidades/dialogos/senha_reset_email_enviado_dialogo.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await mostrarErroDialogo(
              context,
              'Não conseguimos processar o seu pedido. Tenha certeza que você está registrado. Caso contrário, retorne uma tela e faça seu registro corretamente.',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Esqueci minha senha'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Caso você tenha esquecido sua senha, digite seu email e nós iremos enviar um link para redefinir sua senha.',
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Seu endereço de email...',
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                child: const Text('Enviar link de redefinição de senha'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Voltar para a tela de login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
