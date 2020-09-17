
import 'package:gui/blocs/bloc_event_state.dart';

abstract class RetraitCashEvent extends BlocEvent {}

class Post extends RetraitCashEvent {

  final String secret;

  final double montant;

  Post({this.secret, this.montant});

  @override
  String toString() => 'POST';
}

class Confirm extends RetraitCashEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}