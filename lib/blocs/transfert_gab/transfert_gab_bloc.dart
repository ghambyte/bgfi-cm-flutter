
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/transfert_gab/transfert_gab_event.dart';
import 'package:gui/blocs/transfert_gab/transfert_gab_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/transfert_gab_repository.dart';
import 'package:gui/tools/config.dart';

class TransfertGabBloc extends BlocEventStateBase<TransfertGabEvent, TransfertGabState> {

  final TransfertGabRepository _transfertGabRepository = new InjectorApp().transfertGabRepository;

  TransfertGabBloc() :super(initialState: TransfertGabUninitialized());

  @override
  Stream<TransfertGabState> eventHandler(TransfertGabEvent event, TransfertGabState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield TransfertGabInitialized(confirm: false);

      Reponse response = await _transfertGabRepository
          .payer(event.secret, event.montant, event.isgimac)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield TransfertGabLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield TransfertGabError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield TransfertGabUninitialized();
    }

    if(event is Confirm) {
      yield TransfertGabInitialized(confirm: true);
      Reponse response = await _transfertGabRepository
          .confirmer(event.id, event.action, event.isgimac, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield TransfertGabConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield TransfertGabError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield TransfertGabUninitialized();
    }

  }

}