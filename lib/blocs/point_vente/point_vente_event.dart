
import 'package:gui/blocs/bloc_event_state.dart';

abstract class PointVenteEvent extends BlocEvent {}

class Fetch extends PointVenteEvent {

  final String type;
  final bool init;

  Fetch({this.type, this.init: false});
  @override
  String toString() => 'Fetch';
}