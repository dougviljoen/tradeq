part of '_auth_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationClientChanged extends AuthenticationEvent {
  const AuthenticationClientChanged(this.client);

  final TrademeClient client;

  @override
  List<Object> get props => [client];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
