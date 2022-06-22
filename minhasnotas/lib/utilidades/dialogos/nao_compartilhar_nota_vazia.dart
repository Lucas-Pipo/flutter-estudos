import 'package:flutter/material.dart';
import 'package:minhasnotas/extensoes/construtordecontexto/loc.dart';
import 'dialogo_generico.dart';

Future<void> mostrarNaoPodeCompartilharNotaVazia(BuildContext context) {
  return mostrarDialogoGenerico(
    contexto: context,
    titulo: context.loc.sharing,
    conteudo: context.loc.cannot_share_empty_note_prompt,
    optionsBuilder: () =>{
      context.loc.ok : null,
    },
  );
}
