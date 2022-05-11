import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class UsuarioAut {
  final String? email;
  final bool emailEstaVerificado;
  const UsuarioAut({
    required this.email,
    required this.emailEstaVerificado,
  });

  factory UsuarioAut.fromFirebase(User user) => UsuarioAut(
        email: user.email,
        emailEstaVerificado: user.emailVerified,
      );
}
