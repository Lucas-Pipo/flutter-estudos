import 'package:flutter_test/flutter_test.dart';
import 'package:minhasnotas/servi%C3%A7os/autentica%C3%A7%C3%A3o/excecao_aut.dart';
import 'package:minhasnotas/servi%C3%A7os/autentica%C3%A7%C3%A3o/provedor_aut.dart';
import 'package:minhasnotas/servi%C3%A7os/autentica%C3%A7%C3%A3o/usuario_aut.dart';

void main() {
  group('Autenticação Mock', () {
    final provedor = MockProvedorAut();
    test('Não deve ser inicializado para iniciar', () {
      expect(provedor.estaInicializado, false);
    });

    test('Não pode deslogar se não inicializado', () {
      expect(
        provedor.logOut(),
        throwsA(const TypeMatcher<NaoInicializadoExcecao>()),
      );
    });

    test('Deveria ser capaz de inicializar', () async {
      await provedor.initialize();
      expect(provedor.estaInicializado, true);
    });

    test('Usuário deve estar nulo depois da inicialização', () {
      expect(provedor.currentUser, null);
    });

    test(
      'Deve ser capaz de inicializar em menos de 2 segundos',
      () async {
        await provedor.initialize();
        expect(provedor.estaInicializado, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Criar usuário deveria delegar a função logIn', () async {
      final emailRuimUsuario = provedor.criarUsuario(
        email: 'lucasvieira91@qualquercoisa.com',
        senha: 'teste321',
      );

      expect(emailRuimUsuario,
          throwsA(const TypeMatcher<UsuarioNaoEncontradoExcecao>()));

      final usuarioRuimSenha = provedor.criarUsuario(
        email: 'foo@bar.com',
        senha: 'foobar',
      );
      expect(usuarioRuimSenha,
          throwsA(const TypeMatcher<SenhaIncorretaExcecao>()));

      final usuario = await provedor.criarUsuario(
        email: 'banana',
        senha: 'batata',
      );
      expect(provedor.currentUser, usuario);
      expect(usuario.emailEstaVerificado, false);
    });
    test('Usuário logado deve ser capaz de ser verificado', () {
      provedor.sendEmailVerification();
      final usuario = provedor.currentUser;
      expect(usuario, isNotNull);
      expect(usuario!.emailEstaVerificado, true);
    });

    test('Deve ser capaz de logar e deslogar de novo', () async {
      await provedor.logOut();
      await provedor.logIn(
        email: 'email',
        senha: 'senha',
      );
      final usuario = provedor.currentUser;
      expect(usuario, isNotNull);
    });
  });
}

class NaoInicializadoExcecao implements Exception {}

class MockProvedorAut implements ProvedorAut {
  UsuarioAut? _usuario;
  var _estaInicializado = false;
  bool get estaInicializado => _estaInicializado;

  @override
  Future<UsuarioAut> criarUsuario({
    required String email,
    required String senha,
  }) async {
    if (!estaInicializado) throw NaoInicializadoExcecao();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      senha: senha,
    );
  }

  @override
  UsuarioAut? get currentUser => _usuario;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _estaInicializado = true;
  }

  @override
  Future<UsuarioAut> logIn({
    required String email,
    required String senha,
  }) {
    if (!estaInicializado) throw NaoInicializadoExcecao();
    if (email == 'foo@bar.com') throw UsuarioNaoEncontradoExcecao();
    if (senha == 'foobar') throw SenhaIncorretaExcecao();
    const usuario = UsuarioAut(emailEstaVerificado: false);
    _usuario = usuario;
    return Future.value(usuario);
  }

  @override
  Future<void> logOut() async {
    if (!estaInicializado) throw NaoInicializadoExcecao();
    if (_usuario == null) throw UsuarioNaoEncontradoExcecao();
    await Future.delayed(const Duration(seconds: 1));
    _usuario = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!estaInicializado) throw NaoInicializadoExcecao();
    final usuario = _usuario;
    if (usuario == null) throw UsuarioNaoEncontradoExcecao();
    const novoUsuario = UsuarioAut(emailEstaVerificado: true);
    _usuario = novoUsuario;
  }
}
