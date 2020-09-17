
import 'package:gui/blocs/bgfi_express/bgfi_express_event.dart';
import 'package:gui/blocs/bgfi_express/bgfi_express_state.dart';
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/bgfi_express_repository.dart';
import 'package:gui/tools/config.dart';

class BgfiExpressBloc extends BlocEventStateBase<BgfiExpressEvent, BgfiExpressState> {

  BgfiExpressRepository _bgfiExpressRepository = new InjectorApp().bgfiExpressRepository;

  BgfiExpressBloc() :super(initialState: BgfiExpressUninitialized());

  @override
  Stream<BgfiExpressState> eventHandler(BgfiExpressEvent event, BgfiExpressState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield BgfiExpressInitialized(confirm: false);

      Reponse response = await _bgfiExpressRepository
          .payer(event.secret, event.montant, event.mobile, event.pays, event.nom, event.prenom, event.question, event.reponse)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield BgfiExpressLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield BgfiExpressError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield BgfiExpressUninitialized();
    }

    if(event is Confirm) {
      yield BgfiExpressInitialized(confirm: true);
      Reponse response = await _bgfiExpressRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield BgfiExpressConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield BgfiExpressError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield BgfiExpressUninitialized();
    }

  }

}