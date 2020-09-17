
import 'package:gui/blocs/bloc_event_state.dart';

abstract class CompteBanqueEvent extends BlocEvent {}

class Post extends CompteBanqueEvent {

  final String secret;

  final double montant;

  final String mobile;

  final String carrier;

  Post({this.secret, this.mobile, this.montant, this.carrier});

  @override
  String toString() => 'POST';
}

class Confirm extends CompteBanqueEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}

class Fetch extends CompteBanqueEvent {

  final String type;
  final bool init;

  Fetch({this.type, this.init: true});
  @override
  String toString() => 'Fetch';
}