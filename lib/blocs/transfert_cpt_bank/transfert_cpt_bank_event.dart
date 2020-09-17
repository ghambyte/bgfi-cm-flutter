
import 'package:gui/blocs/bloc_event_state.dart';

abstract class TransfertCompteBanqueEvent extends BlocEvent {}

class Post extends TransfertCompteBanqueEvent {

  final String secret;
  final double montant;
  final String banque;
  final String pays;
  final String titnom;
  final String titprenom;
  final String compte;

  Post({this.secret, this.pays, this.montant, this.banque, this.titnom, this.titprenom, this.compte});

  @override
  String toString() => 'POST';
}

class Confirm extends TransfertCompteBanqueEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}

class Preference extends TransfertCompteBanqueEvent {

  final String libelle;
  final String banque;
  final String codeBanque;
  final String codeAgence;
  final String pays;
  final String codePays;
  final String nom;
  final String prenom;
  final String compte;

  Preference({this.libelle, this.banque, this.codeBanque, this.codeAgence, this.pays, this.codePays, this.nom, this.prenom, this.compte});

  @override
  String toString() => 'Preference';
}

class GetPreference extends TransfertCompteBanqueEvent {
  @override
  String toString() => 'Preference';
}