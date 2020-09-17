
import 'package:gui/blocs/bloc_event_state.dart';

abstract class AchatCreditEvent extends BlocEvent {}

class Post extends AchatCreditEvent {

  final String secret;

  final double montant;

  final String mobile;

  final String carrier;

  Post({this.secret, this.mobile, this.montant, this.carrier});

  @override
  String toString() => 'POST';
}

class Confirm extends AchatCreditEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}