
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/beneficiaire.dart';
import 'package:gui/models/virementbankitem.dart';

abstract class VirementsBanqueEvent extends BlocEvent {}

class Fetch extends VirementsBanqueEvent {

  final String type;
  final bool init;

  Fetch({this.type, this.init: false});
  @override
  String toString() => 'Fetch';
}

class Post extends VirementsBanqueEvent {

  final String secret;

  List<VirementBankItem> beneficiaires;

  Post({this.secret, this.beneficiaires});

  @override
  String toString() => 'POST';
}

class Preference extends VirementsBanqueEvent {

  final String numCpt;
  final String nomTitulaire;
  final String codeBanque;
  final String codeGuichet;
  final String nomBanque;
  final String typeCompte;

  Preference({this.numCpt, this.nomTitulaire, this.codeBanque, this.codeGuichet, this.nomBanque, this.typeCompte});

  @override
  String toString() => 'Preference';
}

class GetPreference extends VirementsBanqueEvent {
  @override
  String toString() => 'Preference';
}

class DeletePreference extends VirementsBanqueEvent {

  final String id;

  DeletePreference({this.id});

  @override
  String toString() => 'DeletePreference';
}