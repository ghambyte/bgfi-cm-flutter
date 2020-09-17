
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/miles_travel/miles_travel_event.dart';
import 'package:gui/blocs/miles_travel/miles_travel_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/miles_travel_repository.dart';
import 'package:gui/tools/config.dart';

class MilesTravelBloc extends BlocEventStateBase<MilesTravelEvent, MilesTravelState> {

  final MilesTravelRepository _milesTravelRepository = new InjectorApp().milesTravelRepository;

  MilesTravelBloc() :super(initialState: MilesTravelUninitialized());

  @override
  Stream<MilesTravelState> eventHandler(MilesTravelEvent event, MilesTravelState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield MilesTravelInitialized(confirm: false);

      Reponse response = await _milesTravelRepository
          .payer(event.secret, event.montant)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield MilesTravelLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield MilesTravelError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield MilesTravelUninitialized();
    }

    if(event is Confirm) {
      yield MilesTravelInitialized(confirm: true);
      Reponse response = await _milesTravelRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield MilesTravelConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield MilesTravelError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield MilesTravelUninitialized();
    }

  }

}