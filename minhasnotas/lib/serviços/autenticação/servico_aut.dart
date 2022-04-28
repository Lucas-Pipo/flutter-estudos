import 'package:minhasnotas/servi%C3%A7os/autentica%C3%A7%C3%A3o/firebase_aut_provedor.dart';
import 'package:minhasnotas/serviços/autenticação/provedor_aut.dart';
import 'package:minhasnotas/serviços/autenticação/usuario_aut.dart';

class ServicoAut implements ProvedorAut {
  final ProvedorAut provedor;
  const ServicoAut(this.provedor);

  factory ServicoAut.firebase() => ServicoAut(FirebaseAuthProvider());

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

  @override
  Future<void> initialize() => provedor.initialize();
}
