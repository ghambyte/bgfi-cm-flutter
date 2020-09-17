
import 'package:gui/blocs/bloc_event_state.dart';

class LoginState extends BlocState {
  LoginState({
    this.isBusy: false,
    this.isSuccess: false,
    this.isFailure: false,
    this.errorMessage: '',
    this.successMessage: '',
    this.service: '',
  });

  final bool isBusy;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;
  final String successMessage;
  final String service;

  factory LoginState.noAction() {
    return LoginState();
  }

  factory LoginState.busy([String service = '']){
    return LoginState(isBusy: true, service: service);
  }

  factory LoginState.success(String message){
    return LoginState(isSuccess: true, successMessage: message);
  }

  factory LoginState.failure(String message){
    return LoginState(isFailure: true, errorMessage: message);
  }

  factory LoginState.messageError(String message){
    return LoginState(errorMessage: message,);
  }

}