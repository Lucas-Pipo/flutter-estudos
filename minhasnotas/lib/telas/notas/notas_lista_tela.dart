import 'package:flutter/material.dart';
import 'package:minhasnotas/servicos/nuvem/nota_nuvem.dart';
import '../../utilidades/dialogos/dialogo_deletar.dart';

typedef NotaCallback = void Function(NotaNuvem nota);

class NotasListaTela extends StatelessWidget {
  final List<NotaNuvem> notas;
  final NotaCallback aoDeletaNota;
  final NotaCallback aoClicar;

  const NotasListaTela({
    Key? key,
    required this.notas,
    required this.aoDeletaNota,
    required this.aoClicar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notas.length,
      itemBuilder: (context, index) {
        final nota = notas.elementAt(index);
        return ListTile(
          onTap: () {
            aoClicar(nota);
          },
          title: Text(
            nota.texto,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final deveDeletar = await mostrarDialogoDelete(context);
              if (deveDeletar) {
                aoDeletaNota(nota);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
