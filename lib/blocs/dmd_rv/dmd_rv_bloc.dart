
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/dmd_rv/dmd_rv_event.dart';
import 'package:gui/blocs/dmd_rv/dmd_rv_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/dmd_rv_repository.dart';
import 'package:gui/tools/config.dart';

class DmdRvBloc extends BlocEventStateBase<DmdRvEvent, DmdRvState> {

  DmdRvRepository _dmdRvRepository = new InjectorApp().dmdRvRepository;

  DmdRvBloc() :super(initialState: DmdRvUninitialized());

  @override
  Stream<DmdRvState> eventHandler(DmdRvEvent event, DmdRvState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield DmdRvInitialized(confirm: false);

      Reponse response = await _dmdRvRepository
          .demanderRV(/*event.secret, */event.compte, event.objet, event.date, event.agence)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield DmdRvSuccess(success: response.message);
      } else {
        yield DmdRvError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield DmdRvUninitialized();
    }

  }

}