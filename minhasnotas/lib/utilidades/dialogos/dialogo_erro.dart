import 'package:flutter/cupertino.dart';
import 'package:minhasnotas/extensoes/construtordecontexto/loc.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_generico.dart';

Future<void> mostrarErroDialogo(
  BuildContext contexto,
  String texto,
) {
  return mostrarDialogoGenerico<void>(
    contexto: contexto,
    titulo: contexto.loc.generic_error_prompt,
    conteudo: texto,
    optionsBuilder: () => {
      contexto.loc.ok : null,
    },
  );
}
