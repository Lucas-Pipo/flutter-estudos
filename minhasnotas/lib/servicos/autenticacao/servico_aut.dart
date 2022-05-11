import 'package:minhasnotas/servicos/autenticacao/firebase_aut_provedor.dart';
import 'package:minhasnotas/servicos/autenticacao/provedor_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/usuario_aut.dart';

class ServicoAut implements ProvedorAut {
  final ProvedorAut provedor;
  const ServicoAut(this.provedor);

  factory ServicoAut.firebase() => ServicoAut(FirebaseAuthProvider());

  @override
  Future<UsuarioAut> createUser({
    required String email,
    required String password,
  }) =>
      provedor.createUser(
        email: email,
        password: password,
      );

  @override
  UsuarioAut? get currentUser => provedor.currentUser;

  @override
  Future<UsuarioAut> logIn({
    required String email,
    required String password,
  }) =>
      provedor.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provedor.logOut();

  @override
  Future<void> sendEmailVerification() => provedor.sendEmailVerification();

  @override
  Future<void> initialize() => provedor.initialize();
}
