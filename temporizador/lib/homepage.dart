import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _temporizador;
  int tempoFaltando = 10;

  void _comecarContagem() {
    _temporizador = Timer.periodic(const Duration(seconds: 1), (time) {
      if (tempoFaltando > 0) {
        setState(() {
          tempoFaltando--;
        });
      } else {
        time.cancel();
      }
    });
  }

  void _reiniciarContagem() {
    _temporizador.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Mais Uma Tentativa De Cronometro Regressivo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              tempoFaltando == 0 ? "Fim" : tempoFaltando.toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _comecarContagem();
                  },
                  child: const Text(
                    'I N I C I A R !',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _reiniciarContagem();
                  },
                  child: const Text(
                    'P A R A R',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
