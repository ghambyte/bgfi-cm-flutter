import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_confirm_response.dart';

class PaiementMarchantState extends BlocState{}


class PaiementMarchantUninitialized extends PaiementMarchantState {
  @override
  String toString() => 'PaiementMarchantUninitialized';
}

class PaiementMarchantInitialized extends PaiementMarchantState {

  final confirm;

  PaiementMarchantInitialized({this.confirm: false});

  @override
  String toString() => 'DetailsInfoInitialized';
}

class PaiementMarchantError extends PaiementMarchantState {

  final String error;

  PaiementMarchantError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class PaiementMarchantLoaded extends PaiementMarchantState {

  final NFConfirmResponse nfConfirmResponse;


  PaiementMarchantLoaded({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}

class PaiementMarchantConfirm extends PaiementMarchantState {

  final NFConfirmResponse nfConfirmResponse;


  PaiementMarchantConfirm({
    this.nfConfirmResponse
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfConfirmResponse.idtransaction}}';
}