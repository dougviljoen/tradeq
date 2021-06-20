import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

import 'package:trademe_repository/trademe_repository.dart';

part '_auth_event.dart';
part '_auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required TrademeAuthRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _clientSubscription = _authenticationRepository.client.listen(
      (client) => add(AuthenticationClientChanged(client)),
    );
  }

  final TrademeAuthRepository _authenticationRepository;
  StreamSubscription<TrademeClient> _clientSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationClientChanged) {
      yield _mapAuthenticationClientChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _clientSubscription?.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationClientChangedToState(
    AuthenticationClientChanged event,
  ) {
    return event.client != TrademeClient.empty
        ? AuthenticationState.authenticated(event.client)
        : const AuthenticationState.unauthenticated();
  }
}
