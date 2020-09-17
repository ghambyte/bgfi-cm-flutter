import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';

class CanalSolState extends BlocState{}


class CanalSolUninitialized extends CanalSolState {
  @override
  String toString() => 'CanalSolUninitialized';
}

class CanalSolInitialized extends CanalSolState {

  final confirm;

  CanalSolInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class CanalSolError extends CanalSolState {

  final String error;

  CanalSolError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class CanalSolLoaded extends CanalSolState {

  final NFConfirmResponse nfConfirmResponse;


  CanalSolLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class CanalSolConfirm extends CanalSolState {

  final NFConfirmResponse nfConfirmResponse;


  CanalSolConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class CanalSolPreference extends CanalSolState {

  final Reponse reponse;

  CanalSolPreference({
    this.reponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${reponse.statutcode}}';
}

class CanalSolGetPreference extends CanalSolState {

  final List<NfPrefItem> nfPrefItems;

  CanalSolGetPreference({this.nfPrefItems});

  @override
  String toString() =>
      'InfoLoaded { getPref: ${nfPrefItems.length}}';
}