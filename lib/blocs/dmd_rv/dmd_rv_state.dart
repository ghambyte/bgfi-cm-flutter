import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class DmdRvState extends BlocState{}


class DmdRvUninitialized extends DmdRvState {
  @override
  String toString() => 'DmdRvUninitialized';
}

class DmdRvInitialized extends DmdRvState {

  final confirm;

  DmdRvInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class DmdRvError extends DmdRvState {

  final String error;

  DmdRvError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class DmdRvSuccess extends DmdRvState {

  final String success;

  DmdRvSuccess({this.success});

  @override
  String toString() => 'DmdRvSuccess';
}

class DmdRvLoaded extends DmdRvState {

  final NFConfirmResponse nfConfirmResponse;


  DmdRvLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class DmdRvConfirm extends DmdRvState {

  final NFConfirmResponse nfConfirmResponse;


  DmdRvConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}