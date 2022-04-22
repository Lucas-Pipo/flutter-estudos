import 'package:flutter/material.dart';

Future<void> mostrarErroDialogo(
  BuildContext context,
  String texto,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(texto),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}