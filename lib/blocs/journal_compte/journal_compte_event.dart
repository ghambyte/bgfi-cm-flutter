
import 'package:gui/blocs/bloc_event_state.dart';

abstract class JournalCompteEvent extends BlocEvent {}

class Fetch extends JournalCompteEvent {

  final String type;
  final bool init;

  Fetch({this.type, this.init: false});
  @override
  String toString() => 'Fetch';
}