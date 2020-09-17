
import 'package:gui/blocs/bloc_event_state.dart';

abstract class MilesTravelEvent extends BlocEvent {}

class Post extends MilesTravelEvent {

  final String secret;

  final double montant;

  Post({this.secret, this.montant});

  @override
  String toString() => 'POST';
}

class Confirm extends MilesTravelEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.action, this.token});

  @override
  String toString() => 'CONFIRM';
}