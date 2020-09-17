
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/paiement_marchant/paiement_marchant_state.dart';
import 'package:gui/blocs/paiement_marchant/paiment_marchant_event.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/paiement_marchant_repository.dart';
import 'package:gui/tools/config.dart';

class PaiementMarchantBloc extends BlocEventStateBase<PaiementMarchantEvent, PaiementMarchantState> {

  PaiementMarchantRepository _paiementMarchantRepository = new InjectorApp().paiementMarchantRepository;

  PaiementMarchantBloc() :super(initialState: PaiementMarchantUninitialized());

  @override
  Stream<PaiementMarchantState> eventHandler(PaiementMarchantEvent event, PaiementMarchantState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield PaiementMarchantInitialized(confirm: false);

      Reponse response = await _paiementMarchantRepository
          .payer(event.secret, event.montant, event.code)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield PaiementMarchantLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield PaiementMarchantError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield PaiementMarchantUninitialized();
    }

    if(event is Confirm) {
      yield PaiementMarchantInitialized(confirm: true);
      Reponse response = await _paiementMarchantRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield PaiementMarchantConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield PaiementMarchantError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield PaiementMarchantUninitialized();
    }

  }

}