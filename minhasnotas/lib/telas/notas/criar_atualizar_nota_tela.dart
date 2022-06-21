import 'package:flutter/material.dart';
import 'package:minhasnotas/servicos/autenticacao/servico_aut.dart';
import 'package:minhasnotas/utilidades/dialogos/genericos/pega_argumentos.dart';
import 'package:minhasnotas/servicos/nuvem/firebase_armazenamento_nuvem.dart';
import 'package:minhasnotas/servicos/nuvem/nota_nuvem.dart';
import 'package:share_plus/share_plus.dart';

import '../../utilidades/dialogos/nao_compartilhar_nota_vazia.dart';

class CriarAtualizarNotaTela extends StatefulWidget {
  const CriarAtualizarNotaTela({Key? key}) : super(key: key);

  @override
  State<CriarAtualizarNotaTela> createState() => _CriarAtualizarNotaTelaState();
}

class _CriarAtualizarNotaTelaState extends State<CriarAtualizarNotaTela> {
  NotaNuvem? _nota;
  late final FirebaseArmazenamentoNuvem _servicoNotas;
  late final TextEditingController _textController;

  @override
  void initState() {
    _servicoNotas = FirebaseArmazenamentoNuvem();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final nota = _nota;
    if (nota == null) {
      return;
    }
    final text = _textController.text;
    await _servicoNotas.atualizarNota(
      documentoId: nota.documentoId,
      texto: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<NotaNuvem> criarOuPegarNotaExistente(BuildContext context) async {
    final notaWidget = context.pegaArgumento<NotaNuvem>();

    if (notaWidget != null) {
      _nota = notaWidget;
      _textController.text = notaWidget.texto;
      return notaWidget;
    }

    final notaExistente = _nota;
    if (notaExistente != null) {
      return notaExistente;
    }
    final currentUser = ServicoAut.firebase().currentUser!;
    final usuarioId = currentUser.id;
    final novaNota =
        await _servicoNotas.criarNovaNota(donoUsuarioId: usuarioId);
    _nota = novaNota;
    return novaNota;
  }

  void _deletaNotaSeTextoVazio() {
    final nota = _nota;
    if (_textController.text.isEmpty && nota != null) {
      _servicoNotas.deletaNota(documentoId: nota.documentoId);
    }
  }

  void _salvaNotaSeTextoVazio() async {
    final nota = _nota;
    final text = _textController.text;
    if (nota != null && text.isNotEmpty) {
      await _servicoNotas.atualizarNota(
        documentoId: nota.documentoId,
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
          actions: [
            IconButton(
              onPressed: () async{
                final texto = _textController.text;
                if (_nota == null || texto.isEmpty){
                  await mostrarNaoPodeCompartilharNotaVazia(context);
                } else {
                  Share.share(texto);
                }
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: FutureBuilder(
          future: criarOuPegarNotaExistente(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
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
