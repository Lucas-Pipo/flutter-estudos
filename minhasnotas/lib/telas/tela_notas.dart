import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/enums/menu_acao.dart';
import 'package:minhasnotas/servi%C3%A7os/autentica%C3%A7%C3%A3o/servico_aut.dart';

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
                    await ServicoAut.firebase().logOut();
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
