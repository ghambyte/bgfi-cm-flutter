
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/nf_operation.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/reponse_list.dart';
import 'package:gui/repository/historique_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:rxdart/rxdart.dart';

class HistoriqueBloc implements BlocBase {

  Set<ReponseList<NFOperation>> _currents = Set<ReponseList<NFOperation>>();

  HistoriqueRepository _historiqueRepository = InjectorApp().historiqueRepository;

  final BehaviorSubject<ReponseList<NFOperation>> _response = BehaviorSubject<ReponseList<NFOperation>>();

  BehaviorSubject<ReponseList<NFOperation>> get response => _response;

  final BehaviorSubject<Reponse> _details = BehaviorSubject<Reponse>();

  BehaviorSubject<ReponseList<NFOperation>> get details => _response;

  @override
  void dispose() {
    _response?.close();
    _details?.close();
    // TODO: implement dispose
  }

  Future getDetailsInfo(String codeSecret, String reference) async{
    Reponse response= await _historiqueRepository
        .detailsInfo(codeSecret, reference)
        .then((rep)=> rep)
        .catchError((onError)=> onError.response);

    _details.sink.add(response);
  }

  getInfo(String type, {bool init: false} ) async{
    Reponse response= await _historiqueRepository
        .getInfo(_currents.length<=0 || init ?0:_currents.first.page, type)
        .then((rep)=> rep)
        .catchError((onError)=> onError.response);
    if(response.statutcode == Config.codeSuccess) {
      if(_currents.length<=0 || init) {
        _currents.clear();
        _currents.add(ReponseList<NFOperation>(currentStatut:response.statutcode, page: 1 , statutcode: response.statutcode, message: response.message, reponses: response.reponse['operations'].map<NFOperation>((val) => NFOperation.fromMap(val)).toList()));
      } else {
        _currents.first.currentStatut = response.statutcode;
        _currents.first.message = response.message;
        if(response.reponse['operations'].length<=0) {
          _currents.first.page = _currents.first.page;
        } else {
          _currents.first.page = _currents.first.page +1;
        }
        _currents.first.reponses.addAll(response.reponse['operations'].map<NFOperation>((val) => NFOperation.fromMap(val)).toList());
      }
      _response.sink.add(_currents.first);
    } else {
      if(_currents.length<=0 || init) {
        _response.sink.add(ReponseList<NFOperation>(statutcode: response.statutcode, message: response.message, reponses: null, currentStatut: response.statutcode, page: 0));
      } else {
        _currents.first.currentStatut = response.statutcode;
        _currents.first.message = response.message;
        _currents.first.page = _currents.first.page;
        _response.sink.add(_currents.first);
      }
    }
  }

}