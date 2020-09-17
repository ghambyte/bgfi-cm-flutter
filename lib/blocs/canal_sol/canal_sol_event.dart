
import 'package:gui/blocs/bloc_event_state.dart';

abstract class CanalSolEvent extends BlocEvent {}

class Post extends CanalSolEvent {

  final String secret;
  final String carte;
  final String formule;
  final String duree;
  final String charme;
  final String agence;

  Post({this.secret, this.carte, this.formule, this.duree, this.charme, this.agence});

  @override
  String toString() => 'POST';
}

class Confirm extends CanalSolEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}

class Preference extends CanalSolEvent {

  final String libelle;
  final String valeur;

  Preference({this.libelle, this.valeur});

  @override
  String toString() => 'Preference';
}

class GetPreference extends CanalSolEvent {
  @override
  String toString() => 'Preference';
}