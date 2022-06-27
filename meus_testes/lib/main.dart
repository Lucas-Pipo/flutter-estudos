import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de Teste',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const PrimeiraTela(),
    );
  }
}

class PrimeiraTela extends StatefulWidget {
  const PrimeiraTela({
    Key? key,
  }) : super(key: key);

  @override
  State<PrimeiraTela> createState() => MinhaTelaInicial();
}

class MinhaTelaInicial extends State<PrimeiraTela> {
  int contador = 0;

  void _incrementarContador() {
    setState(() {
      contador--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Funciona?'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Você apertou o botão $contador vezes!'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementarContador,
        tooltip: 'Subtrair',
        child: const Icon(Icons.remove),
      ),
    );
  }
}
