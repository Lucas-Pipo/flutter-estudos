import 'package:firebase_core/firebase_core.dart';
import 'package:minhasnotas/firebase_options.dart';
import 'package:minhasnotas/serviços/autenticação/usuario_aut.dart';
import 'package:minhasnotas/serviços/autenticação/excecao_aut.dart';
import 'package:minhasnotas/serviços/autenticação/provedor_aut.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements ProvedorAut {
  @override
  Future<void> initialize() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<UsuarioAut> criarUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      final usuario = currentUser;
      if (usuario != null) {
        return usuario;
      } else {
        throw UsuarioNaoEncontradoExcecao();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw SenhaFracaExcecao();
      } else if (e.code == 'email-already-in-use') {
        throw EmailEmUsoExececao();
      } else if (e.code == 'invalid-email') {
        throw EmailInvalidoExcecao();
      } else {
        throw GenericaExcecao();
      }
    } catch (_) {
      throw GenericaExcecao();
    }
  }

  @override
  UsuarioAut? get currentUser {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      return UsuarioAut.fromFirebase(usuario);
    } else {
      return null;
    }
  }

  @override
  Future<UsuarioAut> logIn({
    required String email,
    required String senha,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      final usuario = currentUser;
      if (usuario != null) {
        return usuario;
      } else {
        throw UsuarioNaoEncontradoExcecao();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UsuarioNaoEncontradoExcecao();
      } else if (e.code == 'wrong-password') {
        throw SenhaIncorretaExcecao();
      } else {
        throw GenericaExcecao();
      }
    } catch (_) {
      throw GenericaExcecao();
    }
  }

  @override
  Future<void> logOut() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UsuarioNaoLogadoExcecao();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      await usuario.sendEmailVerification();
    } else {
      throw UsuarioNaoLogadoExcecao();
    }
  }
}
