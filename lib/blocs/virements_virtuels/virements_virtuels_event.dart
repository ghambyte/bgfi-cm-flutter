
import 'package:gui/blocs/bloc_event_state.dart';

abstract class VirementsVirtuelsEvent extends BlocEvent {}

class Fetch extends VirementsVirtuelsEvent {

  final String type;
  final bool init;

  Fetch({this.type, this.init: false});
  @override
  String toString() => 'Fetch';
}

class Post extends VirementsVirtuelsEvent {

  final String source;

  final String agence;

  final String secret;

  final String motif;

  final String compteVirtuel;

  final String montant;


  Post({this.source, this.agence, this.secret, this.motif, this.compteVirtuel, this.montant});

  @override
  String toString() => 'POST';
}