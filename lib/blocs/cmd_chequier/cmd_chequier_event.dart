
import 'package:gui/blocs/bloc_event_state.dart';

abstract class CmdChequierEvent extends BlocEvent {}

class Post extends CmdChequierEvent {

  final String compte;

  final String agence;

  final String typeChequier;

  final String volumeChequier;

  Post({this.typeChequier, this.volumeChequier, this.compte, this.agence});

  @override
  String toString() => 'POST';
}
