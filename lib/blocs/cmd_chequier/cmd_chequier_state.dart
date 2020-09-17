import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class CmdChequierState extends BlocState{}


class CmdChequierUninitialized extends CmdChequierState {
  @override
  String toString() => 'CmdChequierUninitialized';
}

class CmdChequierInitialized extends CmdChequierState {

  CmdChequierInitialized();

  @override
  String toString() => 'CmdChequierInitialized';
}

class CmdChequierError extends CmdChequierState {

  final String error;

  CmdChequierError({this.error});

  @override
  String toString() => 'CmdChequierError';
}

class CmdChequierSuccess extends CmdChequierState {

  final String success;

  CmdChequierSuccess({this.success});

  @override
  String toString() => 'CmdChequierSuccess';
}

class CmdChequierLoaded extends CmdChequierState {

  final NFConfirmResponse nfConfirmResponse;


  CmdChequierLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'CmdChequierLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class CmdChequierConfirm extends CmdChequierState {

  final NFConfirmResponse nfConfirmResponse;


  CmdChequierConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'CmdChequierLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}