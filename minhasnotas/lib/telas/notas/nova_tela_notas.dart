import 'package:flutter/material.dart';

class NovaNotaTela extends StatefulWidget {
  const NovaNotaTela({Key? key}) : super(key: key);

  @override
  State<NovaNotaTela> createState() => _NovaNotaTelaState();
}

class _NovaNotaTelaState extends State<NovaNotaTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Nota'),
      ),
      body: const Text('Escreva sua nova nota aqui...'),
    );
  }
}
