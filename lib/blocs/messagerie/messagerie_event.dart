
import 'package:gui/blocs/bloc_event_state.dart';

abstract class MessagerieEvent extends BlocEvent {}

class Fetch extends MessagerieEvent {

  final String type;
  final bool init;

  Fetch({this.type, this.init: false});
  @override
  String toString() => 'Fetch';
}

class Post extends MessagerieEvent {

  final String objet;

  final String compte;

  final String agence;

  final String message;

  Post({this.objet, this.compte, this.agence, this.message});

  @override
  String toString() => 'POST';
}