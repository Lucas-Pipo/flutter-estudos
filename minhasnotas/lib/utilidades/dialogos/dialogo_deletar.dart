import 'package:flutter/material.dart';
import 'package:minhasnotas/utilidades/dialogos/dialogo_generico.dart';

Future<bool> mostrarDialogoDelete(BuildContext contexto) {
  return mostrarDialogoGenerico<bool>(
    contexto: contexto,
    titulo: 'Deletar',
    conteudo: 'Tem certeza que gostaria de deletar esse item?',
    optionsBuilder: () => {
      'Cancelar': false,
      'Sim': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
