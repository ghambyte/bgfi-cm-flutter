
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/canal_sol/canal_sol_event.dart';
import 'package:gui/blocs/canal_sol/canal_sol_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/canal_sol_repository.dart';
import 'package:gui/repository/preference_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class CanalSolBloc extends BlocEventStateBase<CanalSolEvent, CanalSolState> {

  CanalSolRepository _canalSolRepository = new InjectorApp().canalSolRepository;

  PreferenceRepository _preferenceRepository = new InjectorApp().preferenceRepository;

  CanalSolBloc() :super(initialState: CanalSolUninitialized());

  @override
  Stream<CanalSolState> eventHandler(CanalSolEvent event, CanalSolState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield CanalSolInitialized(confirm: false);

      Reponse response = await _canalSolRepository
          .payer(event.secret, event.carte, event.formule, event.duree, event.charme, event.agence)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalSolLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield CanalSolError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalSolUninitialized();
    }

    if(event is Confirm) {
      yield CanalSolInitialized(confirm: true);
      Reponse response = await _canalSolRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalSolConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield CanalSolError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalSolUninitialized();
    }

    if(event is Preference) {
      yield CanalSolInitialized(confirm: false);
      Reponse response = await _preferenceRepository
          .savePreference(event.libelle, Utils.encodeBase64(event.valeur), 'BCANALSOL')
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalSolPreference(reponse: response);
      } else {
        yield CanalSolError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalSolUninitialized();
    }

    if(event is GetPreference) {
      yield CanalSolInitialized(confirm: false);
      Reponse response = await _preferenceRepository
          .getPreferences('BCANALSOL')
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalSolGetPreference(nfPrefItems: response.reponse['preferences'].map<NfPrefItem>((val) => NfPrefItem.fromMap(val)).toList());
      } else {
        yield CanalSolError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalSolUninitialized();
    }

  }

}