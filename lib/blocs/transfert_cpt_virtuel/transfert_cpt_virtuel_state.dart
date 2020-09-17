import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class TransfertCompteVirtuelState extends BlocState{}


class TransfertCompteVirtuelUninitialized extends TransfertCompteVirtuelState {
  @override
  String toString() => 'TransfertCompteVirtuelUninitialized';
}

class TransfertCompteVirtuelInitialized extends TransfertCompteVirtuelState {

  final confirm;

  TransfertCompteVirtuelInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class TransfertCompteVirtuelError extends TransfertCompteVirtuelState {

  final String error;

  TransfertCompteVirtuelError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class TransfertCompteVirtuelLoaded extends TransfertCompteVirtuelState {

  final NFConfirmResponse nfConfirmResponse;


  TransfertCompteVirtuelLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class TransfertCompteVirtuelConfirm extends TransfertCompteVirtuelState {

  final NFConfirmResponse nfConfirmResponse;


  TransfertCompteVirtuelConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}