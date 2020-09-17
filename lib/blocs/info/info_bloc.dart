
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/info/info_event.dart';
import 'package:gui/blocs/info/info_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_operation.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/historique_repository.dart';
import 'package:gui/tools/config.dart';

class InfoBloc extends BlocEventStateBase<InfoEvent, InfoState> {

  HistoriqueRepository _historiqueRepository = new InjectorApp().historiqueRepository;

  InfoBloc():super(initialState: InfoUninitialized());

  @override
  Stream<InfoState> eventHandler(InfoEvent event, InfoState currentState) async* {

    if (event is Fetch) {
      if(event.init) {
        yield InfoUninitialized();
        try{
          final nfoperations = await _fetchInfo(0, event.type);
          if(nfoperations.length>0){
            yield InfoLoaded(nfoperations: nfoperations, hasReachedMax: false, page: 0);
          } else if(currentState is InfoLoaded){
            yield InfoLoaded(nfoperations: currentState.nfoperations, hasReachedMax: false, page: 0);
          }
        } catch (e) {
          if (currentState is InfoLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield InfoError(error: e.response.message);
          }
        }
      } else if(!_hasReachedMax(currentState)){

        try {
          if (currentState is InfoUninitialized || currentState is InfoError) {
            final nfoperations = await _fetchInfo(0, event.type);
            yield InfoLoaded(nfoperations: nfoperations, hasReachedMax: false, page: 0);
          }
          if (currentState is InfoLoaded) {
            final nfoperations = await _fetchInfo(currentState.page+1, event.type);
            yield nfoperations.isEmpty
                ? currentState.copyWith(hasReachedMax: true, error: null)
                : InfoLoaded(nfoperations: currentState.nfoperations + nfoperations, hasReachedMax: false, page: currentState.page+1);
          }
        } catch (e) {
          if(currentState is InfoUninitialized) {
            yield InfoError(error: e.response.message);
          }
          if(currentState is InfoLoaded) {
            yield currentState.copyWith(error: e.response.message);
          }
        }

      }
    }
  }

  bool _hasReachedMax(InfoState state) =>
      state is InfoLoaded && state.hasReachedMax;

  Future<List<NFOperation>> _fetchInfo(int page, String type) async {
    final Reponse response= await _historiqueRepository.getInfo(page, type);
    if (response.statutcode == Config.codeSuccess) {
      return response.reponse['operations'].map<NFOperation>((val) => NFOperation.fromMap(val)).toList();
    } else {
      throw response;
    }
  }

}

