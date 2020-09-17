import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/nf_pref_canal_item.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';

class CanalPlusState extends BlocState{}


class CanalPlusUninitialized extends CanalPlusState {
  @override
  String toString() => 'CanalPlusUninitialized';
}

class CanalPlusInitialized extends CanalPlusState {

  final confirm;

  CanalPlusInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class CanalPlusError extends CanalPlusState {

  final String error;

  CanalPlusError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class CanalPlusLoaded extends CanalPlusState {

  final NFConfirmResponse nfConfirmResponse;


  CanalPlusLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class CanalPlusConfirm extends CanalPlusState {

  final NFConfirmResponse nfConfirmResponse;


  CanalPlusConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class CanalPlusPreference extends CanalPlusState {

  final Reponse reponse;

  CanalPlusPreference({
    this.reponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${reponse.statutcode}}';
}

class CanalPlusGetPreference extends CanalPlusState {

  final List<NfPrefCanalItem> nfPrefItems;

  CanalPlusGetPreference({this.nfPrefItems});

  @override
  String toString() =>
      'InfoLoaded { getPref: ${nfPrefItems.length}}';
}