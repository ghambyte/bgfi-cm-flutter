import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class TransfertGabState extends BlocState{}


class TransfertGabUninitialized extends TransfertGabState {
  @override
  String toString() => 'TransfertGabUninitialized';
}

class TransfertGabInitialized extends TransfertGabState {

  final confirm;

  TransfertGabInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class TransfertGabError extends TransfertGabState {

  final String error;

  TransfertGabError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class TransfertGabLoaded extends TransfertGabState {

  final NFConfirmResponse nfConfirmResponse;


  TransfertGabLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class TransfertGabConfirm extends TransfertGabState {

  final NFConfirmResponse nfConfirmResponse;


  TransfertGabConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}