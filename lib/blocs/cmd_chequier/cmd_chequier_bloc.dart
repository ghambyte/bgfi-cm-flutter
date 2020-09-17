
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/cmd_chequier/cmd_chequier_event.dart';
import 'package:gui/blocs/cmd_chequier/cmd_chequier_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/cmd_chequier_repository.dart';
import 'package:gui/tools/config.dart';

class CmdChequierBloc extends BlocEventStateBase<CmdChequierEvent, CmdChequierState> {

  CmdChequierRepository _cmdChequierRepository = new InjectorApp().cmdChequierRepository;

  CmdChequierBloc() :super(initialState: CmdChequierUninitialized());

  @override
  Stream<CmdChequierState> eventHandler(CmdChequierEvent event, CmdChequierState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield CmdChequierInitialized();
      Reponse response = await _cmdChequierRepository
          .request(event.compte, event.agence, event.typeChequier, event.volumeChequier)
          .then((rep)=> rep)
          .catchError((onError) => onError.response
          );
      if(response.statutcode == Config.codeSuccess) {
        yield CmdChequierSuccess(success: response.message);
      } else {
        yield CmdChequierError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CmdChequierUninitialized();
    }
  }

}