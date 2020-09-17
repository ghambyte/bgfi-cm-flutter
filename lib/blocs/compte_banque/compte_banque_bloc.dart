
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/compte_banque/compte_banque_event.dart';
import 'package:gui/blocs/compte_banque/compte_banque_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/models/nf_confirm_response.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/reponse_list.dart';
import 'package:gui/repository/compte_banque_repository.dart';
import 'package:gui/tools/config.dart';

class CompteBanqueBloc extends BlocEventStateBase<CompteBanqueEvent, CompteBanqueState> {

  CompteBanqueRepository _compteBanqueRepository = new InjectorApp().compteBanqueRepository;

  CompteBanqueBloc() :super(initialState: CompteBanqueUninitialized());

  Set<ReponseList<Compte>> _comptes = Set<ReponseList<Compte>>();

  @override
  Stream<CompteBanqueState> eventHandler(CompteBanqueEvent event, CompteBanqueState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

    }

    if(event is Confirm) {

    }

    if(event is Fetch){
      if(event.init) {
        yield CompteBanqueUninitialized();
        try{
          final comptes = await _fetchCompte();
          if(comptes.length>0){
            yield CompteBanqueLoaded(comptes: comptes);
          } else if(currentState is CompteBanqueLoaded){
            yield CompteBanqueLoaded(comptes: currentState.comptes);
          }
        } catch (e) {
          if(currentState is CompteBanqueLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield CompteBanqueError(error: e.toString());
          }
        }
      }
    }
  }

  Future<List<Compte>> _fetchCompte() async {
    final Reponse response= await _compteBanqueRepository.comptes();
    if (response.statutcode == Config.codeSuccess) {
      DatabaseClient().deleteCompte();
      DatabaseClient().createCompte();
      _comptes.add(ReponseList<Compte>(currentStatut:response.statutcode, page: 1 , statutcode: response.statutcode, message: response.message, reponses: response.reponse['comptes'].map<Compte>((val){
        DatabaseClient().ajouterCompte(Compte.fromMap(val));
      }).toList()));
      return response.reponse['comptes'].map<Compte>((val) => Compte.fromMap(val)).toList();
    } else {
      throw response;
    }
  }

}