
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/virements_banque/virements_banque_event.dart';
import 'package:gui/blocs/virements_banque/virements_banque_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/beneficiaire.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/virement_banque.dart';
import 'package:gui/repository/beneficiaire_repository.dart';
import 'package:gui/repository/preference_repository.dart';
import 'package:gui/repository/virement_banque_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class VirementsBanqueBloc extends BlocEventStateBase<VirementsBanqueEvent, VirementsBanqueState> {

  VirementBanqueRepository _virementBanqueRepository = new InjectorApp().virementsBanqueRepository;

  BeneficiaireRepository _beneficiaireRepository = new InjectorApp().beneficiaireRepository;

  VirementsBanqueBloc():super(initialState: VirementsBanqueUninitialized());

  @override
  Stream<VirementsBanqueState> eventHandler(VirementsBanqueEvent event, VirementsBanqueState currentState) async* {

    if(event is Post) {

      yield VirementsBanqueInitialized();

      Reponse response = await _virementBanqueRepository
          .virement(event.secret, event.beneficiaires)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield VirementsBanqueSuccess(success: response.message);
      } else {
        yield VirementsBanqueError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield VirementsBanqueUninitialized();
    }

    if (event is Fetch) {
      if(event.init) {
        yield VirementsBanqueUninitialized();
        try{
          final virements = await _fetchVirementsBanque(0, event.type);
          if(virements.length>0){
            yield VirementsBanqueLoaded(virements: virements, hasReachedMax: false, page: 0);
          } else if(currentState is VirementsBanqueLoaded){
            yield VirementsBanqueLoaded(virements: currentState.virements, hasReachedMax: false, page: 0);
          }
        } catch (e) {
          if (currentState is VirementsBanqueLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield VirementsBanqueError(error: e.response.message);
          }
        }
      } else if(!_hasReachedMax(currentState)){

        try {
          if (currentState is VirementsBanqueUninitialized || currentState is VirementsBanqueError) {
            final virements = await _fetchVirementsBanque(0, event.type);
            yield VirementsBanqueLoaded(virements: virements, hasReachedMax: false, page: 0);
          }
          if (currentState is VirementsBanqueLoaded) {
            final agences = await _fetchVirementsBanque(currentState.page+1, event.type);
            yield agences.isEmpty
                ? currentState.copyWith(hasReachedMax: true, error: null)
                : VirementsBanqueLoaded(virements: currentState.virements + agences, hasReachedMax: false, page: currentState.page+1);
          }
        } catch (e) {
          if(currentState is VirementsBanqueUninitialized) {
            yield VirementsBanqueError(error: e.response.message);
          }
          if(currentState is VirementsBanqueLoaded) {
            yield currentState.copyWith(error: e.response.message);
          }
        }

      }
    }

    if(event is Preference) {
      yield VirementsBanqueInitialized(confirm: false);
      Reponse response = await _beneficiaireRepository
          .addBeneficiaire(event.numCpt, event.nomTitulaire, event.codeBanque, event.codeGuichet, event.nomBanque, event.typeCompte)
          .then((rep)=> rep)
          .catchError((onError){
            print("ERRRROOORRRR ${onError.toString()}");
      });
      if(response.statutcode == Config.codeSuccess) {
        yield VirementsBanquePreference(reponse: response);
      } else {
        yield VirementsBanqueError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield VirementsBanqueUninitialized();
    }

    if(event is DeletePreference) {
      yield VirementsBanqueInitialized(confirm: false, delete: true);
      Reponse response = await _beneficiaireRepository
          .deleteBeneficiaire(event.id)
          .then((rep)=> rep)
          .catchError((onError){
        print("ERRRROOORRRR ${onError.toString()}");
      });
      if(response.statutcode == Config.codeSuccess) {
        yield VirementsBanquePreference(reponse: response);
      } else {
        yield VirementsBanqueError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield VirementsBanqueUninitialized();
    }

    if(event is GetPreference) {
      yield VirementsBanqueInitialized(confirm: false,preference: true);
      Reponse response = await _beneficiaireRepository
          .getBeneficiaires()
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield VirementsBanqueGetPreference(beneficiaires: response.reponse['beneficaires'].map<Beneficiaire>((val) => Beneficiaire.fromMap(val)).toList());
      } else {
        yield VirementsBanqueError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield VirementsBanqueUninitialized();
    }
  }

  bool _hasReachedMax(VirementsBanqueState state) =>
      state is VirementsBanqueLoaded && state.hasReachedMax;

  Future<List<VirementBanque>> _fetchVirementsBanque(int page, String type) async {
    final Reponse response= await _virementBanqueRepository.getVirements(page, type);
    if (response.statutcode == Config.codeSuccess) {
      return response.reponse['virements'].map<VirementBanque>((val) => VirementBanque.fromMap(val)).toList();
    } else {
      throw response;
    }
  }

}

