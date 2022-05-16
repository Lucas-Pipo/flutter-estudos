import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhasnotas/servicos/nuvem/constantes_nuvem_armazenamento.dart';
import 'package:flutter/foundation.dart';

@immutable
class NotaNuvem {
  final String documentoId;
  final String donoUsuarioId;
  final String texto;
  const NotaNuvem({
    required this.documentoId,
    required this.donoUsuarioId,
    required this.texto,
  });

  NotaNuvem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentoId = snapshot.id,
        donoUsuarioId = snapshot.data()[donoUsuarioIdCampoNome],
        texto = snapshot.data()[campoTextoNome] as String;
}
