
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/canal_plus/canal_plus_event.dart';
import 'package:gui/blocs/canal_plus/canal_plus_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/nf_pref_canal_item.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/canal_plus_repository.dart';
import 'package:gui/repository/preference_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class CanalPlusBloc extends BlocEventStateBase<CanalPlusEvent, CanalPlusState> {

  CanalPlusRepository _canalPlusRepository = new InjectorApp().canalPlusRepository;

  PreferenceRepository _preferenceRepository = new InjectorApp().preferenceRepository;

  CanalPlusBloc() :super(initialState: CanalPlusUninitialized());

  @override
  Stream<CanalPlusState> eventHandler(CanalPlusEvent event, CanalPlusState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield CanalPlusInitialized(confirm: false);

      Reponse response = await _canalPlusRepository
          .payer(event.secret, event.carte, event.formule, event.duree, event.charme, event.ssport, event.ecran)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalPlusLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield CanalPlusError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalPlusUninitialized();
    }

    if(event is Confirm) {
      yield CanalPlusInitialized(confirm: true);
      Reponse response = await _canalPlusRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalPlusConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield CanalPlusError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalPlusUninitialized();
    }

    if(event is Preference) {
      yield CanalPlusInitialized(confirm: false);
      Reponse response = await _preferenceRepository
          .savePreference(event.libelle, event.valeur, 'CPLUS')
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalPlusPreference(reponse: response);
      } else {
        yield CanalPlusError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalPlusUninitialized();
    }

    if(event is GetPreference) {
      yield CanalPlusInitialized(confirm: false);
      Reponse response = await _preferenceRepository
          .getPreferences('CPLUS')
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalPlusGetPreference(nfPrefItems: response.reponse['preferences'].map<NfPrefCanalItem>((val) => NfPrefCanalItem.fromMap(val)).toList());
      } else {
        yield CanalPlusError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalPlusUninitialized();
    }

  }

}