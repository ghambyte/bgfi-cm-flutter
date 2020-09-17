
import 'package:gui/blocs/bloc_event_state.dart';

abstract class PaiementMarchantEvent extends BlocEvent {}

class Post extends PaiementMarchantEvent {

  final String secret;

  final String code;

  final double montant;

  Post({this.secret, this.code, this.montant});

  @override
  String toString() => 'POST';
}

class Confirm extends PaiementMarchantEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}