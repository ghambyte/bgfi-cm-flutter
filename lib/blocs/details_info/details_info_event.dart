
import 'package:gui/blocs/bloc_event_state.dart';

abstract class DetailsInfoEvent extends BlocEvent {}

class Post extends DetailsInfoEvent {

  final String secret;

  final String reference;

  final bool init;

  Post({this.secret, this.reference, this.init: true});

  @override
  String toString() => 'POST';
}