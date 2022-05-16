import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class UsuarioAut {
  final String id;
  final String email;
  final bool emailEstaVerificado;
  const UsuarioAut({
    required this.id,
    required this.email,
    required this.emailEstaVerificado,
  });

  factory UsuarioAut.fromFirebase(User user) => UsuarioAut(
        id: user.uid,
        email: user.email!,
        emailEstaVerificado: user.emailVerified,
      );
}
