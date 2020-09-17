
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/details_info/details_info_event.dart';
import 'package:gui/blocs/details_info/details_info_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/historique_repository.dart';
import 'package:gui/tools/config.dart';

class DetailsInfoBloc extends BlocEventStateBase<DetailsInfoEvent, DetailsInfoState> {

  HistoriqueRepository _historiqueRepository = new InjectorApp().historiqueRepository;

  DetailsInfoBloc() :super(initialState: DetailsInfoUninitialized());

  @override
  Stream<DetailsInfoState> eventHandler(DetailsInfoEvent event, DetailsInfoState currentState) async*{
    // TODO: implement eventHandler
    if(event is Post) {

      if(event.init){
        yield DetailsInfoInitialized();

        Reponse response= await _historiqueRepository
            .detailsInfo(event.secret, event.reference)
            .then((rep)=> rep)
            .catchError((onError)=> onError.response);
        if(response.statutcode == Config.codeSuccess) {
          yield DetailsInfoLoaded(nfdetailsinfos: response.reponse['infos'].map<NFDetailsInfo>((val) => NFDetailsInfo.fromMap(val)).toList());
        } else {
          yield DetailsInfoError(error: response.message);
        }
      } else {
        yield DetailsInfoUninitialized();
      }

      await Future.delayed(Duration(seconds: 1));
      yield DetailsInfoUninitialized();
    }
  }

}