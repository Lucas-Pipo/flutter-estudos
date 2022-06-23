import 'package:flutter/material.dart';
import 'package:minhasnotas/extensoes/construtordecontexto/loc.dart';
import 'dialogo_generico.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: context.loc.sharing,
    content: context.loc.cannot_share_empty_note_prompt,
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
