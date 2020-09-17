
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_event.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/virement_virtuel.dart';
import 'package:gui/repository/virement_cv_repository.dart';
import 'package:gui/tools/config.dart';

class VirementsVirtuelsBloc extends BlocEventStateBase<VirementsVirtuelsEvent, VirementsVirtuelsState> {

  VirementCVRepository _virementVirtuelRepository = new InjectorApp().virementsVirtuelsRepository;

  VirementsVirtuelsBloc():super(initialState: VirementsVirtuelsUninitialized());

  @override
  Stream<VirementsVirtuelsState> eventHandler(VirementsVirtuelsEvent event, VirementsVirtuelsState currentState) async* {

    if(event is Post) {

      yield VirementsVirtuelsInitialized();

      Reponse response = await _virementVirtuelRepository
          .virement(event.secret, event.source, event.agence, event.motif, event.compteVirtuel, event.montant)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield VirementsVirtuelsSuccess(success: response.message);
      } else {
        yield VirementsVirtuelsError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield VirementsVirtuelsUninitialized();
    }

    if (event is Fetch) {
      if(event.init) {
        yield VirementsVirtuelsUninitialized();
        try{
          final tauxChange = await _fetchVirementsVirtuels(0, event.type);
          if(tauxChange.length>0){
            yield VirementsVirtuelsLoaded(virementsVirtuels: tauxChange, hasReachedMax: false, page: 0);
          } else if(currentState is VirementsVirtuelsLoaded){
            yield VirementsVirtuelsLoaded(virementsVirtuels: currentState.virementsVirtuels, hasReachedMax: false, page: 0);
          }
        } catch (e) {
          if (currentState is VirementsVirtuelsLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield VirementsVirtuelsError(error: e.response.message);
          }
        }
      } else if(!_hasReachedMax(currentState)){

        try {
          if (currentState is VirementsVirtuelsUninitialized || currentState is VirementsVirtuelsError) {
            final tauxChange = await _fetchVirementsVirtuels(0, event.type);
            yield VirementsVirtuelsLoaded(virementsVirtuels: tauxChange, hasReachedMax: false, page: 0);
          }
          if (currentState is VirementsVirtuelsLoaded) {
            final tauxChange = await _fetchVirementsVirtuels(currentState.page+1, event.type);
            yield tauxChange.isEmpty
                ? currentState.copyWith(hasReachedMax: true, error: null)
                : VirementsVirtuelsLoaded(virementsVirtuels: currentState.virementsVirtuels + tauxChange, hasReachedMax: false, page: currentState.page+1);
          }
        } catch (e) {
          if(currentState is VirementsVirtuelsUninitialized) {
            yield VirementsVirtuelsError(error: e.response.message);
          }
          if(currentState is VirementsVirtuelsLoaded) {
            yield currentState.copyWith(error: e.response.message);
          }
        }

      }
    }
  }

  bool _hasReachedMax(VirementsVirtuelsState state) =>
      state is VirementsVirtuelsLoaded && state.hasReachedMax;

  Future<List<VirementVirtuel>> _fetchVirementsVirtuels(int page, String type) async {
    final Reponse response= await _virementVirtuelRepository.getVirements(page, type);
    if (response.statutcode == Config.codeSuccess) {
      return response.reponse['demandes'].map<VirementVirtuel>((val) => VirementVirtuel.fromMap(val)).toList();
    } else {
      throw response;
    }
  }

}

