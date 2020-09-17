import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/splash/splash_event.dart';
import 'package:gui/blocs/splash/splash_state.dart';
import 'package:gui/tools/utils.dart';

class SplashBloc extends BlocEventStateBase<SplashEvent, SplashState> {
  SplashBloc() : super(initialState: new SplashState(isInit: false),);

  @override
  Stream<SplashState> eventHandler(SplashEvent event, SplashState currentState) async* {

    if (event is SplashEventLogin) {
      if(event.name == 'ok') {
        await Utils.saveInit('ok');
        yield SplashState.init();
      }
      if(event.name == 'get') {
        print('get');
        String on = '';
        try {
          on = await Utils.getInit().then((val)=>val).catchError((Object error)=>'');
        }catch(e) {
          on = '';
        }
        if(on == null) {
          yield SplashState.not();
        } else if(on == 'ok') {
          yield SplashState.init();
        }else {
          yield SplashState.not();
        }
      }
    }
  }
}