
import 'package:gui/blocs/bloc_event_state.dart';

abstract class TransfertCompteVirtuelEvent extends BlocEvent {}

class Post extends TransfertCompteVirtuelEvent {

  final String secret;

  final String compteBeneficiaire;

  final double montant;

  final String iden;

  Post({this.secret, this.compteBeneficiaire, this.montant, this.iden});

  @override
  String toString() => 'POST';
}

class Confirm extends TransfertCompteVirtuelEvent {

  final String id;

  final int action;

  final String token;

  final String isgimac;

  Confirm({this.id, this.action, this.token, this.isgimac});

  @override
  String toString() => 'CONFIRM';
}