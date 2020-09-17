
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/canal_massando/canal_massando_event.dart';
import 'package:gui/blocs/canal_massando/canal_massando_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/canal_massando_repository.dart';
import 'package:gui/repository/preference_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class CanalMassandoBloc extends BlocEventStateBase<CanalMassandoEvent, CanalMassandoState> {

  CanalMassandoRepository _canalMassandoRepository = new InjectorApp().canalMassandoRepository;

  PreferenceRepository _preferenceRepository = new InjectorApp().preferenceRepository;

  CanalMassandoBloc() :super(initialState: CanalMassandoUninitialized());

  @override
  Stream<CanalMassandoState> eventHandler(CanalMassandoEvent event, CanalMassandoState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield CanalMassandoInitialized(confirm: false);

      Reponse response = await _canalMassandoRepository
          .payer(event.secret, event.carte, event.formule, event.duree, event.adulte, event.agence)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalMassandoLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield CanalMassandoError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalMassandoUninitialized();
    }

    if(event is Confirm) {
      yield CanalMassandoInitialized(confirm: true);
      Reponse response = await _canalMassandoRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalMassandoConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield CanalMassandoError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalMassandoUninitialized();
    }

    if(event is Preference) {
      yield CanalMassandoInitialized(confirm: false);
      Reponse response = await _preferenceRepository
          .savePreference(event.libelle, Utils.encodeBase64(event.valeur), 'BCANALMAS')
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalMassandoPreference(reponse: response);
      } else {
        yield CanalMassandoError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalMassandoUninitialized();
    }

    if(event is GetPreference) {
      yield CanalMassandoInitialized(confirm: false);
      Reponse response = await _preferenceRepository
          .getPreferences('BCANALMAS')
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield CanalMassandoGetPreference(nfPrefItems: response.reponse['preferences'].map<NfPrefItem>((val) => NfPrefItem.fromMap(val)).toList());
      } else {
        yield CanalMassandoError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield CanalMassandoUninitialized();
    }

  }

}