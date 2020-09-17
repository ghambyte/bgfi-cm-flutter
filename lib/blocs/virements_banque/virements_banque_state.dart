import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/beneficiaire.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/virement_banque.dart';

class VirementsBanqueState extends BlocState{}

class VirementsBanqueInitialized extends VirementsBanqueState {

  final confirm;
  final preference;
  final delete;

  VirementsBanqueInitialized({this.confirm: false, this.preference: false, this.delete: false});

  @override
  String toString() => 'VirementsBanqueInitialized';
}

class VirementsBanqueUninitialized extends VirementsBanqueState {
  @override
  String toString() => 'VirementsBanqueUninitialized';
}

class VirementsBanqueError extends VirementsBanqueState {

  final String error;

  VirementsBanqueError({this.error});

  @override
  String toString() => 'VirementsBanqueError';
}

class VirementsBanqueSuccess extends VirementsBanqueState {

  final String success;

  VirementsBanqueSuccess({this.success});

  @override
  String toString() => 'VirementsBanqueSuccess';
}

class VirementsBanquePreference extends VirementsBanqueState {

  final Reponse reponse;

  VirementsBanquePreference({
    this.reponse
  });

  @override
  String toString() =>
      'VirementsBanqueLoaded { posts: ${reponse.statutcode}}';
}

class VirementsBanqueGetPreference extends VirementsBanqueState {

  final List<Beneficiaire> beneficiaires;

  VirementsBanqueGetPreference({this.beneficiaires});

  @override
  String toString() =>
      'VirementsBanqueLoaded { getPref: ${beneficiaires.length}}';
}

class VirementsBanqueLoaded extends VirementsBanqueState {
  final List<VirementBanque> virements;
  final bool hasReachedMax;
  final int page;
  final String error;


  VirementsBanqueLoaded({
    this.virements,
    this.hasReachedMax,
    this.page: 0,
    this.error
  });

  VirementsBanqueLoaded copyWith({
    List<VirementBanque> virementsBanque,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return VirementsBanqueLoaded(
      virements: virements ?? this.virements,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'VirementsBanqueError { posts: ${virements.length}, hasReachedMax: $hasReachedMax }';
}