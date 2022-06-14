import 'package:bloc/bloc.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/estado_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/bloc/event_aut.dart';
import 'package:minhasnotas/servicos/autenticacao/provedor_aut.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(ProvedorAut provider) : super(const AuthStateLoading()) {
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.emailEstaVerificado) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    //log in
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });
    //log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}
