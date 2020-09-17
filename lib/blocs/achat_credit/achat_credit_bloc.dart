
import 'package:gui/blocs/achat_credit/achat_credit_event.dart';
import 'package:gui/blocs/achat_credit/achat_credit_state.dart';
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/achat_credit_repository.dart';
import 'package:gui/tools/config.dart';

class AchatCreditBloc extends BlocEventStateBase<AchatCreditEvent, AchatCreditState> {

  AchatCreditRepository _achatCreditRepository = new InjectorApp().achatCreditRepository;

  AchatCreditBloc() :super(initialState: AchatCreditUninitialized());

  @override
  Stream<AchatCreditState> eventHandler(AchatCreditEvent event, AchatCreditState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield AchatCreditInitialized(confirm: false);

      Reponse response = await _achatCreditRepository
          .payer(event.secret, event.montant, event.mobile, event.carrier)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield AchatCreditLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield AchatCreditError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield AchatCreditUninitialized();
    }

    if(event is Confirm) {
      yield AchatCreditInitialized(confirm: true);
      Reponse response = await _achatCreditRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield AchatCreditConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield AchatCreditError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield AchatCreditUninitialized();
    }

  }

}