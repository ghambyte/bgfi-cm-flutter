import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';

class TransfertCompteBanqueState extends BlocState{}


class TransfertCompteBanqueUninitialized extends TransfertCompteBanqueState {
  @override
  String toString() => 'TransfertCompteBanqueUninitialized';
}

class TransfertCompteBanqueInitialized extends TransfertCompteBanqueState {

  final confirm;

  TransfertCompteBanqueInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class TransfertCompteBanqueError extends TransfertCompteBanqueState {

  final String error;

  TransfertCompteBanqueError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class TransfertCompteBanqueLoaded extends TransfertCompteBanqueState {

  final NFConfirmResponse nfConfirmResponse;


  TransfertCompteBanqueLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class TransfertCompteBanqueConfirm extends TransfertCompteBanqueState {

  final NFConfirmResponse nfConfirmResponse;


  TransfertCompteBanqueConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class TransfertCompteBanquePreference extends TransfertCompteBanqueState {

  final Reponse reponse;

  TransfertCompteBanquePreference({
    this.reponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${reponse.statutcode}}';
}

class TransfertCompteBanqueGetPreference extends TransfertCompteBanqueState {

  final List<NfPrefItem> nfPrefItems;

  TransfertCompteBanqueGetPreference({this.nfPrefItems});

  @override
  String toString() =>
      'InfoLoaded { getPref: ${nfPrefItems.length}}';
}