import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/authentication/authentication_event.dart';
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/blocs/login/login_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/agences.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/models/horaireAgence.dart';
import 'package:gui/models/plafonds.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/reponse_list.dart';
import 'package:gui/models/typeChequier.dart';
import 'package:gui/repository/compte_banque_repository.dart';
import 'package:gui/repository/security_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocEventStateBase<LoginEvent, LoginState> {

  SecurityRepository _repository= new InjectorApp().securityRepository;

  CompteBanqueRepository _compteBanqueRepository = new InjectorApp().compteBanqueRepository;

  Set<ReponseList<Compte>> _comptes = Set<ReponseList<Compte>>();

  Set<ReponseList<Plafonds>> _plafonds = Set<ReponseList<Plafonds>>();

  Set<ReponseList<Agences>> _agences = Set<ReponseList<Agences>>();

  Set<ReponseList<HoraireAgence>> _horaireAgence = Set<ReponseList<HoraireAgence>>();

  Set<ReponseList<TypeChequier>> _typeChequier = Set<ReponseList<TypeChequier>>();

  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    this.authenticationBloc,
  }) :assert(authenticationBloc != null), super(initialState: LoginState.noAction());


  @override
  Stream<LoginState> eventHandler(LoginEvent event, LoginState currentState) async* {

    if (event.event == LoginEventType.working){
      yield LoginState.busy();

      Reponse reponse =  await _repository.login(event.email, event.password, event.service)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      print(reponse.message);
      print(reponse.statutcode);
      print(Config.codeSuccess);
      if(reponse.statutcode == Config.codeSuccess) {
        yield LoginState.success("CONNECTÉ");
      } else {
        yield LoginState.messageError(reponse.message);
        yield LoginState.failure(reponse.message);
      }

      print(reponse.message);
    }

    if (event.event == LoginEventType.subscribe){
      yield LoginState.busy();

      Reponse reponse =  await _repository.subscribe(event.datenaissance, event.secret, event.mobile, event.prenom,
          event.nom, event.sexe, event.email, event.reponse, event.question, event.pays, event.typepiece, event.numeropiece,
          event.lieunaissance)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      print(reponse.message);
      print(reponse.statutcode);
      print(Config.codeSuccess);
      if(reponse.statutcode == Config.codeSuccess) {
        yield LoginState.success("CONNECTÉ");
      } else {
        yield LoginState.messageError(reponse.message);
        yield LoginState.failure(reponse.message);
      }

      print(reponse.message);
    }

    if (event.event == LoginEventType.getComptes){
      yield LoginState.busy();
      Reponse response=  await _compteBanqueRepository.comptes()
          .then((rep)=> rep)
          .catchError((onError)=> onError.response );
      print(response.message);
      print(response.statutcode);
      print(Config.codeSuccess);
      print(response.reponse);
      if(response.statutcode == Config.codeSuccess) {
        DatabaseClient().deleteCompte();
        DatabaseClient().createCompte();
        _comptes.add(ReponseList<Compte>(currentStatut:response.statutcode, page: 1 , statutcode: response.statutcode, message: response.message, reponses: response.reponse['comptes'].map<Compte>((val){
          DatabaseClient().ajouterCompte(Compte.fromMap(val));
        }).toList()));
        yield LoginState.success("comptes");
      } else {
        print('ERRRRRR RECUPERATION COMPTES');
        yield LoginState.failure("ECHEC RECUPERATION COMPTES");
      }

    }

    if (event.event == LoginEventType.disconnect){
      yield LoginState.busy('disconnect');

      Reponse reponse =  await _repository.signout(event.service)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response );
      print(reponse.message);
      print(reponse.statutcode);
      print(Config.codeSuccess);
      if(reponse.statutcode == Config.codeSuccess) {
        Utils.removeLogin(event.service);
        yield LoginState.success(reponse.message);
      } else {
        yield LoginState.messageError(reponse.message);
        yield LoginState.failure("ERREUR DECONNEXION");
      }

      print(reponse.message);
    }

    if (event.event == LoginEventType.token){

      yield LoginState.busy();

      Reponse reponse=  await _repository.getTokenDevice()
          .then((rep)=> rep)
          .catchError((onError)=> onError.response );
      print(reponse.message);
      print(reponse.statutcode);
      print(Config.codeSuccess);

      if(reponse.statutcode == Config.codeSuccess) {
        authenticationBloc.emitEvent(LoggedInToken(name: reponse.reponse['token']));
        yield LoginState.success("CONNECTÉ");
      } else {
        yield LoginState.messageError(reponse.message);
        yield LoginState.failure("ERREUR TOKEN");
      }
    }

    if (event.event == LoginEventType.activation){
      yield LoginState.busy();
      Reponse reponse=  await _repository.activation(event.activation, event.service)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response );
      print(reponse.message);
      print(reponse.statutcode);
      print(Config.codeSuccess);
      print(reponse.reponse);
      if(reponse.statutcode == Config.codeSuccess) {
        print('LOGIN SUCCESS REPONSE ${reponse.reponse.toString()}');
        print(reponse.reponse['nom']);
        if(event.service == 'banking'){
          DatabaseClient().deleteCompte();
          DatabaseClient().createCompte();
          DatabaseClient().deletePlafonds();
          DatabaseClient().createPlafonds();
          DatabaseClient().deleteAgences();
          DatabaseClient().createAgences();
          DatabaseClient().deleteHorairesAgences();
          DatabaseClient().createHorairesAgences();
          DatabaseClient().deleteChequier();
          DatabaseClient().createChequier();
          _comptes.add(ReponseList<Compte>(currentStatut:reponse.statutcode, page: 1 , statutcode: reponse.statutcode, message: reponse.message, reponses: reponse.reponse['comptes'].map<Compte>((val){
            DatabaseClient().ajouterCompte(Compte.fromMap(val));
            print('## COMPTES ## ${Compte.fromMap(val).numeroCompte}');
          }).toList()));
          _plafonds.add(ReponseList<Plafonds>(currentStatut:reponse.statutcode, page: 1 , statutcode: reponse.statutcode, message: reponse.message, reponses: reponse.reponse['plafonds'].map<Plafonds>((val){
            DatabaseClient().ajouterPlafond(Plafonds.fromMap(val));
//            print('## Plafond ## ${Plafonds.fromMap(val).service}');
          }).toList()));
          _agences.add(ReponseList<Agences>(currentStatut:reponse.statutcode, page: 1 , statutcode: reponse.statutcode, message: reponse.message, reponses: reponse.reponse['agences'].map<Agences>((val){
            DatabaseClient().ajouterAgence(Agences.fromMap(val));
//            print('## Agence ## ${Agences.fromMap(val).codeAgence}');
          }).toList()));
          _typeChequier.add(ReponseList<TypeChequier>(currentStatut:reponse.statutcode, page: 1 , statutcode: reponse.statutcode, message: reponse.message, reponses: reponse.reponse['type_chequier'].map<TypeChequier>((val){
            DatabaseClient().ajouterChequier(TypeChequier.fromMap(val));
//            print('## TypeChequier ## ${TypeChequier.fromMap(val).libelleType}');
          }).toList()));
          Utils.saveLogin(event.service, reponse.reponse['nom']);
          Utils.saveCodeClient(reponse.reponse['codeClient']);
          authenticationBloc.emitEvent(LoggedInMB(name: reponse.reponse['nom']));
        }else{
          Utils.saveLogin(event.service, reponse.reponse['nom']);
          authenticationBloc.emitEvent(LoggedInMM(name: reponse.reponse['nom']));
        }
        yield LoginState.success("CONNECTÉ");
      } else {
        print('ERRRRRR');
        yield LoginState.failure("ERREUR CONNEXION");
      }

    }

    if (event.event == LoginEventType.verify){
      yield LoginState.busy();
      Reponse reponse=  await _repository.verify(event.password, event.service)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response );
      print(reponse.message);
      print(reponse.statutcode);
      print(Config.codeSuccess);
      print(reponse.reponse);
      if(reponse.statutcode == Config.codeSuccess) {
        print('LOGIN SUCCESS REPONSE ${reponse.reponse.toString()}');
        print(reponse.reponse['nom']);

        yield LoginState.success("verified");
      } else {
        print('ERRRRRR vérification');
        yield LoginState.failure("ERREUR CONNEXION");
      }

    }

    if (event.event == LoginEventType.changeSecret){
      yield LoginState.busy();
      Reponse reponse=  await _repository.changeSecret(event.password, event.nouveauSecret, event.confirmSecret, event.service)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response );
      print(reponse.message);
      print(reponse.statutcode);
      print(Config.codeSuccess);
      print(reponse.reponse);
      if(reponse.statutcode == Config.codeSuccess) {
        yield LoginState.success(reponse.reponse['message']);
      } else {
        yield LoginState.failure(reponse.message);
      }

    }

    if (event.event == LoginEventType.error){
      yield LoginState.failure("ERREUR CONNEXION");
    }

    if (event.event == LoginEventType.success){
      yield LoginState.success("CONNECTÉ");
    }

    if (event.event == LoginEventType.successToken){
      Utils.saveToken(event.token);
      yield LoginState.success("CONNECTÉ");
    }

    if (event.event == LoginEventType.successActivation){
      Utils.saveFactor(event.service, event.factor);
      Utils.saveLogin(event.service, event.nom);
      yield LoginState.success("CONNECTÉ");
    }
  }

  void deleteCompte() async{
    DatabaseClient().delete().then((val){
      print('Database deleted ###');
    });
  }
}