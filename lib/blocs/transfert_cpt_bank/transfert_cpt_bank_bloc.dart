
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/transfert_cpt_bank/transfert_cpt_bank_event.dart';
import 'package:gui/blocs/transfert_cpt_bank/transfert_cpt_bank_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/transfert_cpt_banque_repository.dart';
import 'package:gui/tools/config.dart';

class TransfertCompteBanqueBloc extends BlocEventStateBase<TransfertCompteBanqueEvent, TransfertCompteBanqueState> {

  TransfertCompteBanqueRepository _transfertCompteBanqueRepository = new InjectorApp().transfertCompteBanqueRepository;

  TransfertCompteBanqueBloc() :super(initialState: TransfertCompteBanqueUninitialized());

  @override
  Stream<TransfertCompteBanqueState> eventHandler(TransfertCompteBanqueEvent event, TransfertCompteBanqueState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      yield TransfertCompteBanqueInitialized(confirm: false);

      Reponse response = await _transfertCompteBanqueRepository
          .payer(event.secret, event.montant, event.banque, event.pays, event.titnom, event.titprenom, event.compte)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield TransfertCompteBanqueLoaded(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield TransfertCompteBanqueError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield TransfertCompteBanqueUninitialized();
    }

    if(event is Confirm) {
      yield TransfertCompteBanqueInitialized(confirm: true);
      Reponse response = await _transfertCompteBanqueRepository
          .confirmer(event.id, event.action, event.token)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield TransfertCompteBanqueConfirm(nfConfirmResponse: NFConfirmResponse.fromMap(response.reponse));
      } else {
        yield TransfertCompteBanqueError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield TransfertCompteBanqueUninitialized();
    }

    if(event is Preference) {
      yield TransfertCompteBanqueInitialized(confirm: false);
      Reponse response = await _transfertCompteBanqueRepository
          .savePreference(event.libelle, event.banque, event.codeBanque, event.codeAgence, event.pays, event.codePays, event.nom, event.prenom, event.compte)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield TransfertCompteBanquePreference(reponse: response);
      } else {
        yield TransfertCompteBanqueError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield TransfertCompteBanqueUninitialized();
    }

    if(event is GetPreference) {
      yield TransfertCompteBanqueInitialized(confirm: false);
      Reponse response = await _transfertCompteBanqueRepository
          .getPreferences()
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield TransfertCompteBanqueGetPreference(nfPrefItems: response.reponse['preferences'].map<NfPrefItem>((val) => NfPrefItem.fromMap(val)).toList());
      } else {
        yield TransfertCompteBanqueError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield TransfertCompteBanqueUninitialized();
    }

  }

}