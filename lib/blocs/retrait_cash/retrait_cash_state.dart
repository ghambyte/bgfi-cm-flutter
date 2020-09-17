import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class RetraitCashState extends BlocState{}


class RetraitCashUninitialized extends RetraitCashState {
  @override
  String toString() => 'RetraitCashUninitialized';
}

class RetraitCashInitialized extends RetraitCashState {

  final confirm;

  RetraitCashInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class RetraitCashError extends RetraitCashState {

  final String error;

  RetraitCashError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class RetraitCashLoaded extends RetraitCashState {

  final NFConfirmResponse nfConfirmResponse;


  RetraitCashLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class RetraitCashConfirm extends RetraitCashState {

  final NFConfirmResponse nfConfirmResponse;


  RetraitCashConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}