import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';

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
          const Text(
              'Nós enviamos um e-mail de verificação. Por favor, abra o e-mail para verificar sua conta.'),
          const Text(
              'Caso você não tenha recebido seu e-mail ainda, por favor pressione o botão abaixo'),
          TextButton(
            onPressed: () async {
              await ServicoAut.firebase().sendEmailVerification();
            },
            child: const Text('Me envie a confirmação de e-mail'),
          ),
          TextButton(
            onPressed: () async {
              await ServicoAut.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registroRota, (route) => false);
            },
            child: const Text('Reiniciar'),
          )
        ],
      ),
    );
  }
}
