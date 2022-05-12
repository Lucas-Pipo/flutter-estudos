import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/enums/menu_acao.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import 'package:minhasnotas/servicos/crud/servico_notas.dart';

class TelaDeNotas extends StatefulWidget {
  const TelaDeNotas({Key? key}) : super(key: key);

  @override
  State<TelaDeNotas> createState() => _TelaDeNotasState();
}

class _TelaDeNotasState extends State<TelaDeNotas> {
  late final ServicoNotas _servicoNotas;
  String get usuarioEmail => ServicoAut.firebase().currentUser!.email!;

  @override
  void initState() {
    _servicoNotas = ServicoNotas();
    super.initState();
  }

  @override
  void dispose() {
    _servicoNotas.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suas Notas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(novaRotaNotas);
            },
            icon: const Icon(Icons.add),
          ),
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
      body: FutureBuilder(
        future: _servicoNotas.pegaOuCriaUsuario(email: usuarioEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _servicoNotas.todasAsNotas,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Esperando por todas as notas...');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
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
