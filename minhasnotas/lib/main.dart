import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/bloc_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/estado_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/event_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/firebase_aut_provedor.dart';
import 'package:minhasnotas/telas/notas/criar_atualizar_nota_tela.dart';
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        loginRota: (context) => const TelaLogin(),
        registroRota: (context) => const TelaRegistro(),
        notasRota: (context) => const TelaDeNotas(),
        verificarRotaEmail: (context) => const TelaDeVerificacao(),
        criarOuAtualizarNotaRota: (context) => const CriarAtualizarNotaTela(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(builder: (
      context,
      state,
    ) {
      if (state is AuthStateLoggedIn) {
        return const TelaDeNotas();
      } else if (state is AuthStateNeedsVerification) {
        return const TelaDeVerificacao();
      } else if (state is AuthStateLoggedOut) {
        return const TelaLogin();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
