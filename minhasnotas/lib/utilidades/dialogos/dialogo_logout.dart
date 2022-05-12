import 'package:flutter/material.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_generico.dart';

Future<bool> dialogoLogOut(BuildContext contexto) {
  return mostrarDialogoGenerico<bool>(
    contexto: contexto,
    titulo: 'Deslogar',
    conteudo: 'Tem certeza que gostaria de deslogar?',
    optionsBuilder: () => {
      'Cancelar': false,
      'Deslogar': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
