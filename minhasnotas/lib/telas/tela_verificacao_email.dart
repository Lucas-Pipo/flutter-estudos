import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minhasnotas/extensoes/construtordecontexto/loc.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/bloc_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/event_aut.dart';

class TelaDeVerificacao extends StatefulWidget {
  const TelaDeVerificacao({Key? key}) : super(key: key);

  @override
  State<TelaDeVerificacao> createState() => _TelaDeVerificacaoState();
}

class _TelaDeVerificacaoState extends State<TelaDeVerificacao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.verify_email,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(context.loc.verify_email_view_prompt),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: Text(context.loc.verify_email_send_email_verification),
            ),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: Text(context.loc.restart),
            )
          ],
        ),
      ),
    );
  }
}
