
import 'package:gui/blocs/bloc_event_state.dart';

abstract class BgfiExpressEvent extends BlocEvent {}

class Post extends BgfiExpressEvent {

  final String secret;
  final double montant;
  final String mobile;
  final String pays;
  final String nom;
  final String prenom;
  final String question;
  final String reponse;

  Post({this.secret, this.montant, this.mobile, this.pays, this.nom, this.prenom, this.question, this.reponse});

  @override
  String toString() => 'POST';
}

class Confirm extends BgfiExpressEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}