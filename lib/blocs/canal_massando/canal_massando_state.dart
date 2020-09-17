import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';

class CanalMassandoState extends BlocState{}


class CanalMassandoUninitialized extends CanalMassandoState {
  @override
  String toString() => 'CanalMassandoUninitialized';
}

class CanalMassandoInitialized extends CanalMassandoState {

  final confirm;

  CanalMassandoInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class CanalMassandoError extends CanalMassandoState {

  final String error;

  CanalMassandoError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class CanalMassandoLoaded extends CanalMassandoState {

  final NFConfirmResponse nfConfirmResponse;


  CanalMassandoLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class CanalMassandoConfirm extends CanalMassandoState {

  final NFConfirmResponse nfConfirmResponse;


  CanalMassandoConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class CanalMassandoPreference extends CanalMassandoState {

  final Reponse reponse;

  CanalMassandoPreference({
    this.reponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${reponse.statutcode}}';
}

class CanalMassandoGetPreference extends CanalMassandoState {

  final List<NfPrefItem> nfPrefItems;

  CanalMassandoGetPreference({this.nfPrefItems});

  @override
  String toString() =>
      'InfoLoaded { getPref: ${nfPrefItems.length}}';
}