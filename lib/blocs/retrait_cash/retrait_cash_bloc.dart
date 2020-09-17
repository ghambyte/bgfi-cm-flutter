
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/retrait_cash/retrait_cash_event.dart';
import 'package:gui/blocs/retrait_cash/retrait_cash_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/retrait_cash_repository.dart';
import 'package:gui/tools/config.dart';

class RetraitCashBloc extends BlocEventStateBase<RetraitCashEvent, RetraitCashState> {

  final RetraitCashRepository _retraitCashRepository = new InjectorApp().retraitCashRepository;

  RetraitCashBloc() :super(initialState: RetraitCashUninitialized());

  @override
  Stream<RetraitCashState> eventHandler(RetraitCashEvent event, RetraitCashState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield RetraitCashInitialized(confirm: false);

      Reponse response = await _retraitCashRepository
          .payer(event.secret, event.montant)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield RetraitCashLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield RetraitCashError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield RetraitCashUninitialized();
    }

    if(event is Confirm) {
      yield RetraitCashInitialized(confirm: true);
      Reponse response = await _retraitCashRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield RetraitCashConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield RetraitCashError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield RetraitCashUninitialized();
    }

  }

}