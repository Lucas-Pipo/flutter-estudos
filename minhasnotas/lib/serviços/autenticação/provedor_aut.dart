import 'package:minhasnotas/serviços/autenticação/usuario_aut.dart';

abstract class ProvedorAut {
  Future<void> initialize();
  UsuarioAut? get currentUser;
  Future<UsuarioAut> logIn({
    required String email,
    required String senha,
  });
  Future<UsuarioAut> criarUsuario({
    required String email,
    required String senha,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
