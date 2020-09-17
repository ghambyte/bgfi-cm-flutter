
import 'package:gui/blocs/bloc_event_state.dart';

abstract class TauxChangeEvent extends BlocEvent {}

class Fetch extends TauxChangeEvent {

  final String type;
  final bool init;

  Fetch({this.type, this.init: false});
  @override
  String toString() => 'Fetch';
}