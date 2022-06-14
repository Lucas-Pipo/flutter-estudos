import 'package:flutter/material.dart';
import 'package:minhasnotas/constantes/rotas.dart';
import 'package:minhasnotas/enums/menu_acao.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/event_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import 'package:minhasnotas/servicos/nuvem/firebase_armazenamento_nuvem.dart';
import 'package:minhasnotas/telas/notas/notas_lista_tela.dart';
import '../../servicos/autenticacao/bloc/bloc_aut.dart';
import '../../servicos/nuvem/nota_nuvem.dart';
import '../../utilidades/dialogos/dialogo_logout.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

class TelaDeNotas extends StatefulWidget {
  const TelaDeNotas({Key? key}) : super(key: key);

  @override
  State<TelaDeNotas> createState() => _TelaDeNotasState();
}

class _TelaDeNotasState extends State<TelaDeNotas> {
  late final FirebaseArmazenamentoNuvem _servicoNotas;
  String get usuarioId => ServicoAut.firebase().currentUser!.id;

  @override
  void initState() {
    _servicoNotas = FirebaseArmazenamentoNuvem();
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
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
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
      body: StreamBuilder(
        stream: _servicoNotas.todasNotas(donoUsuarioId: usuarioId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final todasNotas = snapshot.data as List<NotaNuvem>;
                return NotasListaTela(
                  notas: todasNotas,
                  aoDeletaNota: (nota) async {
                    await _servicoNotas.deletaNota(
                        documentoId: nota.documentoId);
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
      ),
    );
  }
}
