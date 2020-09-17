
import 'package:gui/blocs/bloc_event_state.dart';

abstract class CanalMassandoEvent extends BlocEvent {}

class Post extends CanalMassandoEvent {

  final String secret;
  final String carte;
  final String formule;
  final String duree;
  final String adulte;
  final String agence;

  Post({this.secret, this.carte, this.formule, this.duree, this.adulte, this.agence});

  @override
  String toString() => 'POST';
}

class Confirm extends CanalMassandoEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}

class Preference extends CanalMassandoEvent {

  final String libelle;
  final String valeur;

  Preference({this.libelle, this.valeur});

  @override
  String toString() => 'Preference';
}

class GetPreference extends CanalMassandoEvent {
  @override
  String toString() => 'Preference';
}