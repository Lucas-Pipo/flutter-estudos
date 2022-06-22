import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/bloc_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/estado_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/event_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/firebase_aut_provedor.dart';
import 'package:minhasnotas/telas/esqueci_senha_tela.dart';
import 'package:minhasnotas/telas/notas/criar_atualizar_nota_tela.dart';
import 'package:minhasnotas/telas/tela_login.dart';
import 'package:minhasnotas/telas/notas/tela_notas.dart';
import 'package:minhasnotas/telas/tela_registro.dart';
import 'package:minhasnotas/telas/tela_verificacao_email.dart';
import 'ajudantes/carregamento/tela_carregamento.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
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
    return BlocConsumer<AuthBloc, AuthState>(listener: (
      context,
      state,
    ) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? 'Aguarde um momento',
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const TelaDeNotas();
      } else if (state is AuthStateNeedsVerification) {
        return const TelaDeVerificacao();
      } else if (state is AuthStateLoggedOut) {
        return const TelaLogin();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const TelaRegistro();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
