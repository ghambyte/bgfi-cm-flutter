
import 'package:gui/blocs/bloc_event_state.dart';

abstract class PaiementLineEvent extends BlocEvent {}

class Post extends PaiementLineEvent {

  final String secret;

  final String reference;

  Post({this.secret, this.reference});

  @override
  String toString() => 'POST';
}

class Confirm extends PaiementLineEvent {

  final String id;

  final String token;

  Confirm({this.id, this.token});

  @override
  String toString() => 'CONFIRM';
}