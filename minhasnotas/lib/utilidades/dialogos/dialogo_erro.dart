import 'package:flutter/cupertino.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_generico.dart';

Future<void> mostrarErroDialogo(
  BuildContext contexto,
  String texto,
) {
  return mostrarDialogoGenerico<void>(
    contexto: contexto,
    titulo: 'Um erro ocorreu',
    conteudo: texto,
    optionsBuilder: () => {
      'OK' : null,
    },
  );
}
