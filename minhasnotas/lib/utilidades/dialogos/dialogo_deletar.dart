import 'package:flutter/material.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_generico.dart';
import 'package:minhasnotas/extensoes/construtordecontexto/loc.dart';

Future<bool> mostrarDialogoDelete(BuildContext contexto) {
  return mostrarDialogoGenerico<bool>(
    contexto: contexto,
    titulo: contexto.loc.delete,
    conteudo: contexto.loc.delete_note_prompt,
    optionsBuilder: () => {
      contexto.loc.cancel: false,
      contexto.loc.yes: true,
    },
  ).then(
    (value) => value ?? false,
  );
}
