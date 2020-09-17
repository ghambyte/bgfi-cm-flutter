
import 'package:gui/blocs/bloc_event_state.dart';

abstract class TransfertGabEvent extends BlocEvent {}

class Post extends TransfertGabEvent {

  final String secret;

  final double montant;

  final String isgimac;

  final String numdest;

  Post({this.secret, this.montant, this.isgimac, this.numdest});

  @override
  String toString() => 'POST';
}

class Confirm extends TransfertGabEvent {

  final String id;

  final int action;

  final String token;

  final String isgimac;

  final String numdest;

  Confirm({this.id, this.action, this.token, this.isgimac, this.numdest});

  @override
  String toString() => 'CONFIRM';
}