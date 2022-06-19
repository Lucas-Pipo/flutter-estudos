import 'package:flutter_test/flutter_test.dart';
import 'package:minhasnotas/servicos/autenticacao/excecao_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/provedor_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/usuario_aut.dart';

void main() {
  group('Autenticação Mock', () {
    final provider = MockAuthProvider();
    test('Não deveria inicializar de começo', () {
      expect(provider.isInitialized, false);
    });

    test('Não consegue deslogar se não for inicializado', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Deve ser capaz de inicializar', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('Usuário deve ser nulo depois da inicialização', () {
      expect(provider.currentUser, null);
    });

    test(
      'Deve ser capaz de inicializar em menos de 2 segundos',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Criar usuário deve delegar função', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UsuarioNaoEncontradoExcecao>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(
          badPasswordUser, throwsA(const TypeMatcher<SenhaIncorretaExcecao>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.emailEstaVerificado, false);
    });

    test('Usuário logado deve ser capaz de ser verificado', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.emailEstaVerificado, true);
    });

    test('Deve ser capaz de logar e deslogar', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements ProvedorAut {
  UsuarioAut? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<UsuarioAut> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  UsuarioAut? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<UsuarioAut> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UsuarioNaoEncontradoExcecao();
    if (password == 'foobar') throw SenhaIncorretaExcecao();
    const user = UsuarioAut(
      id: 'my_id',
      emailEstaVerificado: false,
      email: 'foo@bar.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UsuarioNaoEncontradoExcecao();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UsuarioNaoEncontradoExcecao();
    const newUser = UsuarioAut(
      id: 'my_id',
      emailEstaVerificado: true,
      email: 'foo@bar.com',
    );
    _user = newUser;
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}