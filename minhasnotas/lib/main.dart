import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minhasnotas/telas/tela_login.dart';
import 'package:minhasnotas/telas/tela_registro.dart';
import 'firebase_options.dart';

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
        '/login/': (context) => const TelaLogin(),
        '/registro/': (context) => const TelaRegistro(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // final user = FirebaseAuth.instance.currentUser;
              // if (user?.emailVerified ?? false) {
              //   return const Text('Finalizado');
              // } else {
              //   return const TelaDeVerificacao();
              // }
              return const TelaLogin();
            default:
              return const Text('Carregando...');
          }
        },
      ),
    );
  }
}

class TelaDeVerificacao extends StatefulWidget {
  const TelaDeVerificacao({Key? key}) : super(key: key);

  @override
  State<TelaDeVerificacao> createState() => _TelaDeVerificacaoState();
}

class _TelaDeVerificacaoState extends State<TelaDeVerificacao> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Por favor verifique seu e-mail'),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text('Me envie a confirmação de e-mail'),
        )
      ],
    );
  }
}
