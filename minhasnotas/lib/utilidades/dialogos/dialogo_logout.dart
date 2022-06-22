import 'package:flutter/material.dart';
import 'package:minhasnotas/extensoes/construtordecontexto/loc.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_generico.dart';

Future<bool> dialogoLogOut(BuildContext contexto) {
  return mostrarDialogoGenerico<bool>(
    contexto: contexto,
    titulo: contexto.loc.logout_button,
    conteudo: contexto.loc.logout_dialog_prompt,
    optionsBuilder: () => {
      contexto.loc.cancel: false,
      contexto.loc.logout_button: true,
    },
  ).then(
    (value) => value ?? false,
  );
}
