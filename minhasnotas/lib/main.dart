import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
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
        loginRota: (context) => const TelaLogin(),
        registroRota: (context) => const TelaRegistro(),
        notasRota: (context) => const TelaDeNotas(),
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

enum MenuAcao { logout }

class TelaDeNotas extends StatefulWidget {
  const TelaDeNotas({Key? key}) : super(key: key);

  @override
  State<TelaDeNotas> createState() => _TelaDeNotasState();
}

class _TelaDeNotasState extends State<TelaDeNotas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Principal'),
        actions: [
          PopupMenuButton<MenuAcao>(
            onSelected: (value) async {
              switch (value) {
                case MenuAcao.logout:
                  final deveDeslogar = await dialogoLogOut(context);
                  if (deveDeslogar) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRota,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAcao>(
                  value: MenuAcao.logout,
                  child: Text('Desconectar'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text('Ola Mundo!'),
    );
  }
}

Future<bool> dialogoLogOut(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Desconectar'),
        content: const Text('Tem certeza que você quer se desconectar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Desconectar'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
