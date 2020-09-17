
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/paiement_ligne/paiement_ligne_event.dart';
import 'package:gui/blocs/paiement_ligne/paiement_ligne_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/paiement_line_repository.dart';
import 'package:gui/tools/config.dart';

class PaiementLineBloc extends BlocEventStateBase<PaiementLineEvent, PaiementLineState> {

  final PaiementLineRepository _paiementLineRepository = new InjectorApp().paiementLineRepository;

  PaiementLineBloc() :super(initialState: PaiementLineUninitialized());

  @override
  Stream<PaiementLineState> eventHandler(PaiementLineEvent event, PaiementLineState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield PaiementLineInitialized(confirm: false);

      Reponse response = await _paiementLineRepository
          .payer(event.secret, event.reference)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield PaiementLineLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield PaiementLineError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield PaiementLineUninitialized();
    }

    if(event is Confirm) {
      yield PaiementLineInitialized(confirm: true);
      Reponse response = await _paiementLineRepository
          .confirmer(event.id, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield PaiementLineConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield PaiementLineError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield PaiementLineUninitialized();
    }

  }

}