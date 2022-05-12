import 'package:flutter/material.dart';

import '../../servicos/crud/servico_notas.dart';
import '../../utilidades/dialogos/dialogo_deletar.dart';

typedef DeletaNotaCallback = void Function(DatabaseNota nota);

class NotasListaTela extends StatelessWidget {
  final List<DatabaseNota> notas;
  final DeletaNotaCallback onDeletaNota;

  const NotasListaTela({
    Key? key,
    required this.notas,
    required this.onDeletaNota,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notas.length,
      itemBuilder: (context, index) {
        final nota = notas[index];
        return ListTile(
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
                onDeletaNota(nota);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
