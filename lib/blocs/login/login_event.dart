import 'package:gui/blocs/bloc_event_state.dart';

class LoginEvent extends BlocEvent {

  LoginEvent({
    this.event,
    this.email,
    this.password,
    this.nouveauSecret,
    this.confirmSecret,
    this.service,
    this.messageError,
    this.token,
    this.activation,
    this.factor,
    this.nom,
    this.imei,
    this.datenaissance,
    this.secret,
    this.mobile,
    this.prenom,
    this.sexe,
    this.reponse,
    this.question,
    this.pays,
    this.os,
    this.typepiece,
    this.numeropiece,
    this.lieunaissance
  });

  final LoginEventType event;
  final String email;
  final String password;
  final String nouveauSecret;
  final String confirmSecret;
  final String service;
  final String messageError;
  final String token;
  final int activation;
  final int factor;
  final String nom;
  final String imei;
  final String datenaissance;
  final String secret;
  final String mobile;
  final String prenom;
  final String sexe;
  final String reponse;
  final String question;
  final String pays;
  final String os;
  final String typepiece;
  final String numeropiece;
  final String lieunaissance;
}

enum LoginEventType {
  none,
  token,
  activation,
  success,
  successActivation,
  successToken,
  error,
  working,
  disconnect,
  verify,
  getComptes,
  changeSecret,
  subscribe,
}