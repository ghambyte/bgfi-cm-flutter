
import 'package:gui/blocs/bloc_event_state.dart';

abstract class CanalPlusEvent extends BlocEvent {}

class Post extends CanalPlusEvent {

  final String secret;

  final String carte;

  final String formule;

  final String duree;

  final String charme;

  final String ssport;

  final String ecran;

  Post({this.secret, this.carte, this.formule, this.duree, this.charme, this.ssport, this.ecran});

  @override
  String toString() => 'POST';
}

class Confirm extends CanalPlusEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}

class Preference extends CanalPlusEvent {

  final String libelle;
  final String valeur;

  Preference({this.libelle, this.valeur});

  @override
  String toString() => 'Preference';
}

class GetPreference extends CanalPlusEvent {
  @override
  String toString() => 'Preference';
}