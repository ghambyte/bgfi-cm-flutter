
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/transfert_cpt_virtuel/transfert_cpt_virtuel_event.dart';
import 'package:gui/blocs/transfert_cpt_virtuel/transfert_cpt_virtuel_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/transfert_cpt_virtuel_repository.dart';
import 'package:gui/tools/config.dart';

class TransfertCompteVirtuelBloc extends BlocEventStateBase<TransfertCompteVirtuelEvent, TransfertCompteVirtuelState> {

  TransfertCompteVirtuelRepository _transfertCompteVirtuelRepository = new InjectorApp().transfertCompteVirtuelRepository;

  TransfertCompteVirtuelBloc() :super(initialState: TransfertCompteVirtuelUninitialized());

  @override
  Stream<TransfertCompteVirtuelState> eventHandler(TransfertCompteVirtuelEvent event, TransfertCompteVirtuelState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {
      yield TransfertCompteVirtuelInitialized(confirm: false);

      Reponse response = await _transfertCompteVirtuelRepository
          .payer(event.secret, event.montant, event.compteBeneficiaire, event.iden)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield TransfertCompteVirtuelLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield TransfertCompteVirtuelError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield TransfertCompteVirtuelUninitialized();
    }

    if(event is Confirm) {
      yield TransfertCompteVirtuelInitialized(confirm: true);
      Reponse response = await _transfertCompteVirtuelRepository
          .confirmer(event.id, event.action, event.token, event.isgimac)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield TransfertCompteVirtuelConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield TransfertCompteVirtuelError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield TransfertCompteVirtuelUninitialized();
    }

  }

}