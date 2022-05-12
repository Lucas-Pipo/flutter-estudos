import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import 'package:minhasnotas/telas/notas/nova_tela_notas.dart';
import 'package:minhasnotas/telas/tela_login.dart';
import 'package:minhasnotas/telas/notas/tela_notas.dart';
import 'package:minhasnotas/telas/tela_registro.dart';
import 'package:minhasnotas/telas/tela_verificacao_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRota: (context) => const TelaLogin(),
        registroRota: (context) => const TelaRegistro(),
        notasRota: (context) => const TelaDeNotas(),
        verificarRotaEmail : (context) => const TelaDeVerificacao(),
        novaRotaNotas : (context) => const NovaNotaTela(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ServicoAut.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = ServicoAut.firebase().currentUser;
            if (user != null) {
              if (user.emailEstaVerificado) {
                return const TelaDeNotas();
              } else {
                return const TelaDeVerificacao();
              }
            } else {
              return const TelaLogin();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}