
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/point_vente/point_vente_event.dart';
import 'package:gui/blocs/point_vente/point_vente_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/agences.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/point_vente_repository.dart';
import 'package:gui/tools/config.dart';

class PointVenteBloc extends BlocEventStateBase<PointVenteEvent, PointVenteState> {

  PointVenteRepository _pointVenteRepository = new InjectorApp().pointVenteRepository;

  PointVenteBloc():super(initialState: PointVenteUninitialized());

  @override
  Stream<PointVenteState> eventHandler(PointVenteEvent event, PointVenteState currentState) async* {

    if (event is Fetch) {
      if(event.init) {
        yield PointVenteUninitialized();
        try{
          final agences = await _fetchPointVente(0, event.type);
          if(agences.length>0){
            yield PointVenteLoaded(agences: agences, hasReachedMax: false, page: 0);
          } else if(currentState is PointVenteLoaded){
            yield PointVenteLoaded(agences: currentState.agences, hasReachedMax: false, page: 0);
          }
        } catch (e) {
          if (currentState is PointVenteLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield PointVenteError(error: e.response.message);
          }
        }
      } else if(!_hasReachedMax(currentState)){

        try {
          if (currentState is PointVenteUninitialized || currentState is PointVenteError) {
            final agences = await _fetchPointVente(0, event.type);
            yield PointVenteLoaded(agences: agences, hasReachedMax: false, page: 0);
          }
          if (currentState is PointVenteLoaded) {
            final agences = await _fetchPointVente(currentState.page+1, event.type);
            yield agences.isEmpty
                ? currentState.copyWith(hasReachedMax: true, error: null)
                : PointVenteLoaded(agences: currentState.agences + agences, hasReachedMax: false, page: currentState.page+1);
          }
        } catch (e) {
          if(currentState is PointVenteUninitialized) {
            yield PointVenteError(error: e.response.message);
          }
          if(currentState is PointVenteLoaded) {
            yield currentState.copyWith(error: e.response.message);
          }
        }

      }
    }
  }

  bool _hasReachedMax(PointVenteState state) =>
      state is PointVenteLoaded && state.hasReachedMax;

  Future<List<Agences>> _fetchPointVente(int page, String type) async {
    final Reponse response= await _pointVenteRepository.getPointsVente(page, type);
    print('### REPONSE ###');
    if (response.statutcode == Config.codeSuccess) {
      return response.reponse['agences'].map<Agences>((val) => Agences.fromMap(val)).toList();
//      return response.reponse['operations'].map<NFOperation>((val) => NFOperation.fromMap(val)).toList();
    } else {
      throw response;
    }
  }

}

