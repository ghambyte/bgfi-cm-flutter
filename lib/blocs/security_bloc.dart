
import 'package:gui/blocs/authentication/authentication_state.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/security_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:rxdart/rxdart.dart';

class SecurityBloc implements BlocBase {

  SecurityRepository _securityRepository = InjectorApp().securityRepository;

  final BehaviorSubject<Reponse> _response = BehaviorSubject<Reponse>();

  BehaviorSubject<Reponse> get response => _response;
  @override
  void dispose() {
    _response?.close();
    // TODO: implement dispose
  }

  Future<bool> getStatus(String type) async{
    Reponse response= await _securityRepository
        .getStatus(type)
        .then((rep)=> rep)
        .catchError((onError)=> onError.response );
    _response.sink.add(response);
    if (type == Config.serviceMBanking){
      print("RESPONSE #### ${response.statutcode}");
      if (response.statutcode != Config.codeSuccess) {
        Utils.removeLogin(Config.serviceMBanking);
        return false;
      }else{
        return true;
      }
    }else{
      if (response.statutcode != Config.codeSuccess){
        Utils.removeLogin(Config.serviceMMoney);
        return false;
      }else{
        Utils.saveLogin(Config.serviceMMoney, response.reponse['nomclient']);
        return true;
      }
    }
  }

}