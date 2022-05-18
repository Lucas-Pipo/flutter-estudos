import 'package:flutter/material.dart';
import 'dialogo_generico.dart';

Future<void> mostrarNaoPodeCompartilharNotaVazia(BuildContext context) {
  return mostrarDialogoGenerico(
    contexto: context,
    titulo: 'Compartilhando',
    conteudo: 'Você não pode compartilhar uma nota vazia!',
    optionsBuilder: () =>{
      'OK' : null,
    },
  );
}
