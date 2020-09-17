import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class FenixState extends BlocState{}


class FenixUninitialized extends FenixState {
  @override
  String toString() => 'FenixUninitialized';
}

class FenixInitialized extends FenixState {

  final confirm;

  FenixInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class FenixError extends FenixState {

  final String error;

  FenixError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class FenixLoaded extends FenixState {

  final NFConfirmResponse nfConfirmResponse;

  FenixLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class FenixConfirm extends FenixState {

  final NFConfirmResponse nfConfirmResponse;

  FenixConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}