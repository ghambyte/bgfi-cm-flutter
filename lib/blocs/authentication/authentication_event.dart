import 'package:gui/blocs/bloc_event_state.dart';

abstract class AuthenticationEvent extends BlocEvent {
  final String name;

  AuthenticationEvent({
    this.name: '',
  });
}

class AuthenticationEventLogoutMM extends AuthenticationEvent {}

class AuthenticationEventLogoutMB extends AuthenticationEvent {}


class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedInToken extends AuthenticationEvent {

  final String name;

  LoggedInToken({ this.name}) : super(name: name);

  @override
  String toString() => 'LoggedIn { token: $name }';
}

class LoggedInMM extends AuthenticationEvent {

  final String name;

  LoggedInMM({ this.name}) : super(name: name);

  @override
  String toString() => 'LoggedIn { token: $name }';
}

class LoggedInMB extends AuthenticationEvent {

  final String name;

  LoggedInMB({ this.name}) : super(name: name);

  @override
  String toString() => 'LoggedIn { token: $name }';
}