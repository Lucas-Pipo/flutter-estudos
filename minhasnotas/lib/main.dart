import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minhasnotas/telas/tela_login.dart';
import 'package:minhasnotas/telas/tela_registro.dart';
import 'package:minhasnotas/telas/tela_verificacao_email.dart';
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
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print('Email verificado');
              } else {
                return const TelaDeVerificacao();
              }
            } else {
              return const TelaLogin();
            }
            return const Text('Feito');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
