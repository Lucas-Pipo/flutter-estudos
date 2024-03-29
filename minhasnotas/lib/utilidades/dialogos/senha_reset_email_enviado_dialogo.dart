import 'package:flutter/material.dart';
import 'package:minhasnotas/extensoes/construtordecontexto/loc.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_generico.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: context.loc.password_reset,
    content: context.loc.password_reset_dialog_prompt,
    optionsBuilder: () => {
      context.loc.ok: null,
    },
  );
}
