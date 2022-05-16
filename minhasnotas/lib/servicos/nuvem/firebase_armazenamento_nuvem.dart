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

  Stream<Iterable<NotaNuvem>> todasNotas({required String donoUsuarioId}) =>
      notas.snapshots().map((event) => event.docs
          .map((doc) => NotaNuvem.fromSnapshot(doc))
          .where((nota) => nota.donoUsuarioId == donoUsuarioId));

  Future<Iterable<NotaNuvem>> pegaNotas({required String donoUsuarioId}) async {
    try {
      return await notas
          .where(
            donoUsuarioIdCampoNome,
            isEqualTo: donoUsuarioId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return NotaNuvem(
                  documentoId: doc.id,
                  donoUsuarioId: doc.data()[donoUsuarioIdCampoNome] as String,
                  texto: doc.data()[campoTextoNome] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw NaoConseguiuPegarTodasAsNotasExcecao();
    }
  }

  void criarNovaNota({required String donoUsuarioId}) async {
    notas.add({
      donoUsuarioIdCampoNome: donoUsuarioId,
      campoTextoNome: '',
    });
  }

  static final FirebaseArmazenamentoNuvem _shared =
      FirebaseArmazenamentoNuvem._sharedInstance();
  FirebaseArmazenamentoNuvem._sharedInstance();
  factory FirebaseArmazenamentoNuvem() => _shared;
}
