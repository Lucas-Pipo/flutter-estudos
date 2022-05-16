import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/enums/menu_acao.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import 'package:minhasnotas/servicos/crud/servico_notas.dart';
import 'package:minhasnotas/telas/notas/notas_lista_tela.dart';

import '../../utilidades/dialogos/dialogo_logout.dart';

class TelaDeNotas extends StatefulWidget {
  const TelaDeNotas({Key? key}) : super(key: key);

  @override
  State<TelaDeNotas> createState() => _TelaDeNotasState();
}

class _TelaDeNotasState extends State<TelaDeNotas> {
  late final ServicoNotas _servicoNotas;
  String get usuarioEmail => ServicoAut.firebase().currentUser!.email;

  @override
  void initState() {
    _servicoNotas = ServicoNotas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suas Notas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(criarOuAtualizarNotaRota);
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
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final todasNotas = snapshot.data as List<DatabaseNota>;
                        return NotasListaTela(
                          notas: todasNotas,
                          aoDeletaNota: (nota) async {
                            await _servicoNotas.deletaNota(id: nota.id);
                          },
                          aoClicar: (nota) {
                            Navigator.of(context).pushNamed(
                              criarOuAtualizarNotaRota,
                              arguments: nota,
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
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
