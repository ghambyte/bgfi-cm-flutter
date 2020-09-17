import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class MilesTravelState extends BlocState{}


class MilesTravelUninitialized extends MilesTravelState {
  @override
  String toString() => 'MilesTravelUninitialized';
}

class MilesTravelInitialized extends MilesTravelState {

  final confirm;

  MilesTravelInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class MilesTravelError extends MilesTravelState {

  final String error;

  MilesTravelError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class MilesTravelLoaded extends MilesTravelState {

  final NFConfirmResponse nfConfirmResponse;


  MilesTravelLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class MilesTravelConfirm extends MilesTravelState {

  final NFConfirmResponse nfConfirmResponse;


  MilesTravelConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}