import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/authentication/authentication_event.dart';
import 'package:gui/blocs/authentication/authentication_state.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class AuthenticationBloc extends BlocEventStateBase<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc()
      : super(
    initialState: AuthenticationState.notiniAuthenticated(),
  );

  @override
  Stream<AuthenticationState> eventHandler(AuthenticationEvent event, AuthenticationState currentState) async* {

    if(event is AppStarted) {

      final String isConnectMM = await Utils.getLogin(Config.serviceMMoney).then((val)=>val).catchError((Object error) =>null);
      final String isConnectMB = await Utils.getLogin(Config.serviceMBanking).then((val)=>val).catchError((Object error) =>null);

      yield AuthenticationState.authenticated(isConnectMM, isConnectMB, Config.serviceMMoney);
      yield AuthenticationState.authenticated(isConnectMM, isConnectMB, Config.serviceMBanking);

    }

    if (event is LoggedInToken) {

      yield AuthenticationState.authenticating(null);

      await Utils.saveToken(event.name);
      final String isConnectMM = await Utils.getLogin(Config.serviceMMoney).then((val)=>val).catchError((Object error) =>null);
      final String isConnectMB = await Utils.getLogin(Config.serviceMBanking).then((val)=>val).catchError((Object error) =>null);

      yield AuthenticationState.authenticated(isConnectMM, isConnectMB, null);

    }

    if (event is LoggedInMM) {

      yield AuthenticationState.authenticating(Config.serviceMMoney);

      await Utils.saveLogin(Config.serviceMMoney, event.name);
      final String isConnectMB = await Utils.getLogin(Config.serviceMBanking).then((val)=>val).catchError((Object error) =>null);

      yield AuthenticationState.authenticated(event.name, isConnectMB, Config.serviceMMoney);

    }

    if (event is LoggedInMB) {

      yield AuthenticationState.authenticating(Config.serviceMBanking);

      await Utils.saveLogin(Config.serviceMBanking, event.name);
      final String isConnectMM = await Utils.getLogin(Config.serviceMMoney).then((val)=>val).catchError((Object error) =>null);

      yield AuthenticationState.authenticated(isConnectMM, event.name, Config.serviceMBanking);

    }

    if (event is AuthenticationEventLogoutMM){
      final String isConnectMB = await Utils.getLogin(Config.serviceMBanking).then((val)=>val).catchError((Object error) =>null);
      yield AuthenticationState.notAuthenticated(null, isConnectMB, Config.serviceMMoney);
    }

    if (event is AuthenticationEventLogoutMB){
      final String isConnectMM = await Utils.getLogin(Config.serviceMMoney).then((val)=>val).catchError((Object error) =>null);
      yield AuthenticationState.notAuthenticated(isConnectMM, null, Config.serviceMBanking);
    }
  }
}