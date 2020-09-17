import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/tools/config.dart';

class AuthenticationState extends BlocState {

  AuthenticationState({
    this.isAuthenticatedMM : false,
    this.isAuthenticatedMB : false,
    this.isAuthenticatedToken :false,
    this.isAuthenticating: false,
    this.hasFailed: false,
    this.nameMM,
    this.nameMB,
  });

  bool _isAuth;
  bool isAuthenticatedMM;
  final bool isAuthenticatedToken;
  bool isAuthenticatedMB;
  final bool isAuthenticating;
  final bool hasFailed;

  final String nameMM;
  final String nameMB;

  Future<bool> isConnect() async {
    return _isAuth = true;
  }

  set isAuth(bool value) {
    _isAuth = value;
  }

  bool get isAuth => _isAuth;

  factory AuthenticationState.notiniAuthenticated() {
    return AuthenticationState(isAuthenticatedMM: false, isAuthenticatedMB: false);
  }

  factory AuthenticationState.notAuthenticated(String nameMM, String nameMB, String service) {
    return service==null
        ? AuthenticationState(isAuthenticatedToken: false)
        : service== Config.serviceMMoney
          ? AuthenticationState(isAuthenticatedMM: false)
          : AuthenticationState(isAuthenticatedMB: false);
  }

  factory AuthenticationState.authenticated(String nameMM, String nameMB, String service) {
    if(service==null) {
      print('OOOO2');
      return AuthenticationState(isAuthenticatedToken: true, nameMM: nameMM,  nameMB: nameMB, isAuthenticatedMB: nameMB==null?false:true, isAuthenticatedMM: nameMM==null?false:true);
    } else if( service == Config.serviceMMoney){
      print('OOOO');
      AuthenticationState auth = AuthenticationState(isAuthenticatedMM: true, nameMM: nameMM, nameMB: nameMB, isAuthenticatedMB: nameMB==null?false:true);
      return auth;
    } else {
      print('OOO3');
      return AuthenticationState(isAuthenticatedMB: true, nameMB: nameMB, nameMM: nameMM, isAuthenticatedMM: nameMM==null?false:true);
    }
  }

  factory AuthenticationState.authenticating(String service) {
    return service==null
        ? AuthenticationState(isAuthenticatedToken: false, isAuthenticating: true)
        : service== Config.serviceMMoney
          ? AuthenticationState(isAuthenticatedMM: false, isAuthenticating: true)
          : AuthenticationState(isAuthenticatedMB: false, isAuthenticating: true);
  }

  factory AuthenticationState.failure(String nameMM, String nameMB, String service) {
    return service==null
        ? AuthenticationState(isAuthenticatedToken: false, hasFailed: true, nameMM: nameMM,  nameMB: nameMB, isAuthenticatedMB: nameMB==null?false:true, isAuthenticatedMM: nameMM==null?false:true)
        : service== Config.serviceMMoney
          ? AuthenticationState(isAuthenticatedMM: false, hasFailed: true, nameMB: nameMB, isAuthenticatedMB: nameMB==null?false:true)
          : AuthenticationState(isAuthenticatedMB: false, hasFailed: true, nameMM: nameMM, isAuthenticatedMM: nameMM==null?false:true);
  }
}