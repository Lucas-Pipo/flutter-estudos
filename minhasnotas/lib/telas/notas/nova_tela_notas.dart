import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import 'package:minhasnotas/servicos/crud/servico_notas.dart';

class NovaNotaTela extends StatefulWidget {
  const NovaNotaTela({Key? key}) : super(key: key);

  @override
  State<NovaNotaTela> createState() => _NovaNotaTelaState();
}

class _NovaNotaTelaState extends State<NovaNotaTela> {
  DatabaseNota? _nota;
  late final ServicoNotas _servicoNotas;
  late final TextEditingController _textController;

  @override
  void initState() {
    _servicoNotas = ServicoNotas();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final nota = _nota;
    if (nota == null) {
      return;
    }
    final text = _textController.text;
    await _servicoNotas.updateNota(
      nota: nota,
      texto: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNota> criarNovaNota() async {
    final notaExistente = _nota;
    if (notaExistente != null) {
      return notaExistente;
    }
    final currentUser = ServicoAut.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _servicoNotas.pegaUsuario(email: email);
    return await _servicoNotas.criarNota(owner: owner);
  }

  void _deletaNotaSeTextoVazio() {
    final nota = _nota;
    if (_textController.text.isEmpty && nota != null) {
      _servicoNotas.deletaNota(id: nota.id);
    }
  }

  void _salvaNotaSeTextoVazio() async {
    final nota = _nota;
    final text = _textController.text;
    if (nota != null && text.isNotEmpty) {
      await _servicoNotas.updateNota(
        nota: nota,
        texto: text,
      );
    }
  }

  @override
  void dispose() {
    _deletaNotaSeTextoVazio();
    _salvaNotaSeTextoVazio();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nova Nota'),
        ),
        body: FutureBuilder(
          future: criarNovaNota(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _nota = snapshot.data as DatabaseNota;
                _setupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Comece a digitar a sua nota...',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
