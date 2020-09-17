import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class BgfiExpressState extends BlocState{}


class BgfiExpressUninitialized extends BgfiExpressState {
  @override
  String toString() => 'BgfiExpressUninitialized';
}

class BgfiExpressInitialized extends BgfiExpressState {

  final confirm;

  BgfiExpressInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class BgfiExpressError extends BgfiExpressState {

  final String error;

  BgfiExpressError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class BgfiExpressLoaded extends BgfiExpressState {

  final NFConfirmResponse nfConfirmResponse;


  BgfiExpressLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class BgfiExpressConfirm extends BgfiExpressState {

  final NFConfirmResponse nfConfirmResponse;


  BgfiExpressConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}