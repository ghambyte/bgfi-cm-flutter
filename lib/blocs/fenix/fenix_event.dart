
import 'package:gui/blocs/bloc_event_state.dart';

abstract class FenixEvent extends BlocEvent {}

class Post extends FenixEvent {

  final String secret;

  final String reference;

  Post({this.secret, this.reference});

  @override
  String toString() => 'POST';
}

class Confirm extends FenixEvent {

  final String id;

  final int action;

  final String token;

  Confirm({this.id, this.token, this.action});

  @override
  String toString() => 'CONFIRM';
}