import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class AchatCreditState extends BlocState{}


class AchatCreditUninitialized extends AchatCreditState {
  @override
  String toString() => 'AchatCreditUninitialized';
}

class AchatCreditInitialized extends AchatCreditState {

  final confirm;

  AchatCreditInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class AchatCreditError extends AchatCreditState {

  final String error;

  AchatCreditError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class AchatCreditLoaded extends AchatCreditState {

  final NFConfirmResponse nfConfirmResponse;


  AchatCreditLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class AchatCreditConfirm extends AchatCreditState {

  final NFConfirmResponse nfConfirmResponse;


  AchatCreditConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}