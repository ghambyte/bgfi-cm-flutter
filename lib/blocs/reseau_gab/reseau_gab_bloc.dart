
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/reseau_gab/reseau_gab_event.dart';
import 'package:gui/blocs/reseau_gab/reseau_gab_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/gabs.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/reseau_gab_repository.dart';
import 'package:gui/tools/config.dart';

class ReseauGabBloc extends BlocEventStateBase<ReseauGabEvent, ReseauGabState> {

  ReseauGabRepository _reseauGabRepository = new InjectorApp().reseauGabRepository;

  ReseauGabBloc():super(initialState: ReseauGabUninitialized());

  @override
  Stream<ReseauGabState> eventHandler(ReseauGabEvent event, ReseauGabState currentState) async* {

    if (event is Fetch) {
      if(event.init) {
        yield ReseauGabUninitialized();
        try{
          final gabs = await _fetchGabs(0, event.type);
          if(gabs.length>0){
            yield ReseauGabLoaded(gabs: gabs, hasReachedMax: false, page: 0);
          } else if(currentState is ReseauGabLoaded){
            yield ReseauGabLoaded(gabs: currentState.gabs, hasReachedMax: false, page: 0);
          }
        } catch (e) {
          if (currentState is ReseauGabLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield ReseauGabError(error: e.response.message);
          }
        }
      } else if(!_hasReachedMax(currentState)){

        try {
          if (currentState is ReseauGabUninitialized || currentState is ReseauGabError) {
            final gabs = await _fetchGabs(0, event.type);
            yield ReseauGabLoaded(gabs: gabs, hasReachedMax: false, page: 0);
          }
          if (currentState is ReseauGabLoaded) {
            final gabs = await _fetchGabs(currentState.page+1, event.type);
            yield gabs.isEmpty
                ? currentState.copyWith(hasReachedMax: true, error: null)
                : ReseauGabLoaded(gabs: currentState.gabs + gabs, hasReachedMax: false, page: currentState.page+1);
          }
        } catch (e) {
          if(currentState is ReseauGabUninitialized) {
            yield ReseauGabError(error: e.response.message);
          }
          if(currentState is ReseauGabLoaded) {
            yield currentState.copyWith(error: e.response.message);
          }
        }

      }
    }
  }

  bool _hasReachedMax(ReseauGabState state) =>
      state is ReseauGabLoaded && state.hasReachedMax;

  Future<List<Gabs>> _fetchGabs(int page, String type) async {
    final Reponse response= await _reseauGabRepository.getReseauGab(page, type);
    print('### REPONSE ###');
    if (response.statutcode == Config.codeSuccess) {
      return response.reponse['gabs'].map<Gabs>((val) => Gabs.fromMap(val)).toList();
//      return response.reponse['operations'].map<NFOperation>((val) => NFOperation.fromMap(val)).toList();
    } else {
      throw response;
    }
  }

}

