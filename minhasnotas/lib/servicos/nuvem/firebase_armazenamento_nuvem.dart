import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhasnotas/servicos/nuvem/constantes_nuvem_armazenamento.dart';
import 'package:minhasnotas/servicos/nuvem/excecoes_nuvem_armazenamento.dart';
import 'package:minhasnotas/servicos/nuvem/nota_nuvem.dart';

class FirebaseArmazenamentoNuvem {
  final notas = FirebaseFirestore.instance.collection('notas');

  Future<void> deletaNota({required String documentoId}) async {
    try {
      await notas.doc(documentoId).delete();
    } catch (e) {
      throw NaoConseguiuDeletarExececao();
    }
  }

  Future<void> atualizarNota({
    required String documentoId,
    required String texto,
  }) async {
    try {
      await notas.doc(documentoId).update({campoTextoNome: texto});
    } catch (e) {
      throw NaoConseguiuAtualizarNotasExcecao();
    }
  }

  Stream<Iterable<NotaNuvem>> todasNotas({required String donoUsuarioId}) {
    final todasNotas = notas
        .where(donoUsuarioIdCampoNome, isEqualTo: donoUsuarioId)
        .snapshots()
        .map((event) => event.docs.map((doc) => NotaNuvem.fromSnapshot(doc)));
    return todasNotas;
  }

  Future<NotaNuvem> criarNovaNota({required String donoUsuarioId}) async {
    final documento = await notas.add({
      donoUsuarioIdCampoNome: donoUsuarioId,
      campoTextoNome: '',
    });
    final notaFechada = await documento.get();
    return NotaNuvem(
      documentoId: notaFechada.id,
      donoUsuarioId: donoUsuarioId,
      texto: '',
    );
  }

  static final FirebaseArmazenamentoNuvem _shared =
      FirebaseArmazenamentoNuvem._sharedInstance();
  FirebaseArmazenamentoNuvem._sharedInstance();
  factory FirebaseArmazenamentoNuvem() => _shared;
}
