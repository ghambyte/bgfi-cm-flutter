
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/fenix/fenix_event.dart';
import 'package:gui/blocs/fenix/fenix_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/fenix_repository.dart';
import 'package:gui/tools/config.dart';

class FenixBloc extends BlocEventStateBase<FenixEvent, FenixState> {

  final FenixRepository _fenixRepository = new InjectorApp().fenixRepository;

  FenixBloc() :super(initialState: FenixUninitialized());

  @override
  Stream<FenixState> eventHandler(FenixEvent event, FenixState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield FenixInitialized(confirm: false);

      Reponse response = await _fenixRepository
          .payer(event.secret, event.reference)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield FenixLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield FenixError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield FenixUninitialized();
    }

    if(event is Confirm) {
      yield FenixInitialized(confirm: true);
      Reponse response = await _fenixRepository
          .confirmer(event.id, event.action,  event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield FenixConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield FenixError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield FenixUninitialized();
    }

  }

}