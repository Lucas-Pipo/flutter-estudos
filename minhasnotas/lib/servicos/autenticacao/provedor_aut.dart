import 'package:minhasnotas/servicos/autenticacao/usuario_aut.dart';

abstract class ProvedorAut {
  Future<void> initialize();
  UsuarioAut? get currentUser;
  Future<UsuarioAut> logIn({
    required String email,
    required String password,
  });
  Future<UsuarioAut> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({required String toEmail});
}
