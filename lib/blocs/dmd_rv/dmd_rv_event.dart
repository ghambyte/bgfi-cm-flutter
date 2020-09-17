
import 'package:gui/blocs/bloc_event_state.dart';

abstract class DmdRvEvent extends BlocEvent {}

class Post extends DmdRvEvent {

  //final String secret;

  final String compte;

  final String objet;

  final String date;

  final String agence;

  Post({/* this.secret, */this.compte, this.objet, this.date, this.agence});

  @override
  String toString() => 'POST';
}