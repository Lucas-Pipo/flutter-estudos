import 'package:minhasnotas/serviços/autenticação/provedor_aut.dart';
import 'package:minhasnotas/serviços/autenticação/usuario_aut.dart';

class ServicoAut implements ProvedorAut {
  final ProvedorAut provedor;
  ServicoAut(this.provedor);

  @override
  Future<UsuarioAut> criarUsuario({
    required String email,
    required String senha,
  }) =>
      provedor.criarUsuario(
        email: email,
        senha: senha,
      );

  @override
  UsuarioAut? get currentUser => provedor.currentUser;

  @override
  Future<UsuarioAut> logIn({
    required String email,
    required String senha,
  }) =>
      provedor.logIn(
        email: email,
        senha: senha,
      );

  @override
  Future<void> logOut() => provedor.logOut();

  @override
  Future<void> sendEmailVerification() => provedor.sendEmailVerification();
}
