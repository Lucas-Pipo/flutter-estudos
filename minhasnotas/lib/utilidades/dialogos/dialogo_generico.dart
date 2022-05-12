import 'package:flutter/material.dart';

typedef DialogoOpcionalBuilder<T> = Map<String, T?> Function();

Future<T?> mostrarDialogoGenerico<T>({
  required BuildContext contexto,
  required String titulo,
  required String conteudo,
  required DialogoOpcionalBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: contexto,
    builder: (context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(conteudo),
        actions: options.keys.map((optionTitle) {
          final valor = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (valor != null) {
                Navigator.of(context).pop(valor);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
