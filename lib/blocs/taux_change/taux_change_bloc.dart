
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/taux_change/taux_change_event.dart';
import 'package:gui/blocs/taux_change/taux_change_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/taux_change.dart';
import 'package:gui/repository/taux_change_repository.dart';
import 'package:gui/tools/config.dart';

class TauxChangeBloc extends BlocEventStateBase<TauxChangeEvent, TauxChangeState> {

  TauxChangeRepository _TauxChangeRepository = new InjectorApp().tauxChangeRepository;

  TauxChangeBloc():super(initialState: TauxChangeUninitialized());

  @override
  Stream<TauxChangeState> eventHandler(TauxChangeEvent event, TauxChangeState currentState) async* {

    if (event is Fetch) {
      if(event.init) {
        yield TauxChangeUninitialized();
        try{
          final tauxChange = await _fetchTauxChange(0, event.type);
          if(tauxChange.length>0){
            yield TauxChangeLoaded(tauxChange: tauxChange, hasReachedMax: false, page: 0);
          } else if(currentState is TauxChangeLoaded){
            yield TauxChangeLoaded(tauxChange: currentState.tauxChange, hasReachedMax: false, page: 0);
          }
        } catch (e) {
          if (currentState is TauxChangeLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield TauxChangeError(error: e.response.message);
          }
        }
      } else if(!_hasReachedMax(currentState)){

        try {
          if (currentState is TauxChangeUninitialized || currentState is TauxChangeError) {
            final tauxChange = await _fetchTauxChange(0, event.type);
            yield TauxChangeLoaded(tauxChange: tauxChange, hasReachedMax: false, page: 0);
          }
          if (currentState is TauxChangeLoaded) {
            final tauxChange = await _fetchTauxChange(currentState.page+1, event.type);
            yield tauxChange.isEmpty
                ? currentState.copyWith(hasReachedMax: true, error: null)
                : TauxChangeLoaded(tauxChange: currentState.tauxChange + tauxChange, hasReachedMax: false, page: currentState.page+1);
          }
        } catch (e) {
          if(currentState is TauxChangeUninitialized) {
            yield TauxChangeError(error: e.response.message);
          }
          if(currentState is TauxChangeLoaded) {
            yield currentState.copyWith(error: e.response.message);
          }
        }

      }
    }
  }

  bool _hasReachedMax(TauxChangeState state) =>
      state is TauxChangeLoaded && state.hasReachedMax;

  Future<List<TauxChange>> _fetchTauxChange(int page, String type) async {
    final Reponse response= await _TauxChangeRepository.getTauxChange(page, type);
    if (response.statutcode == Config.codeSuccess) {
      return response.reponse['devises'].map<TauxChange>((val) => TauxChange.fromMap(val)).toList();
    } else {
      throw response;
    }
  }

}

