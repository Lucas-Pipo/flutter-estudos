import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class UsuarioAut {
  final bool emailEstaVerificado;
  const UsuarioAut(this.emailEstaVerificado);

  factory UsuarioAut.fromFirebase(User usuario) =>
      UsuarioAut(usuario.emailVerified);
}
