part of '_auth_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.client = TrademeClient.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(TrademeClient client)
      : this._(status: AuthenticationStatus.authenticated, client: client);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final TrademeClient client;

  @override
  List<Object> get props => [status, client];
}
