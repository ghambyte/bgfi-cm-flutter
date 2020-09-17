import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class PaiementLineState extends BlocState{}


class PaiementLineUninitialized extends PaiementLineState {
  @override
  String toString() => 'PaiementLineUninitialized';
}

class PaiementLineInitialized extends PaiementLineState {

  final confirm;

  PaiementLineInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class PaiementLineError extends PaiementLineState {

  final String error;

  PaiementLineError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class PaiementLineLoaded extends PaiementLineState {

  final NFConfirmResponse nfConfirmResponse;


  PaiementLineLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class PaiementLineConfirm extends PaiementLineState {

  final NFConfirmResponse nfConfirmResponse;


  PaiementLineConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}