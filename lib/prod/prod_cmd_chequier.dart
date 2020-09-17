
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/cmd_chequier_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdCmdChequierRepository implements CmdChequierRepository {

  HttpHandler httpHandler;

  ProdCmdChequierRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> request(String compte, String agence, String typeChequier, String volumeChequier) async{
    // TODO: implement payer
    Map<String, dynamic> data = {
      "codeClient": "string",
      "compte": compte,
      "codeAgence": agence,
      "typeChequier": typeChequier,
      "volumeChequier": volumeChequier,
      "imei": "string"
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getCodeClient().then((val){
      data['codeClient'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));

    print(data);
    return httpHandler.post('/chequier', data);
  }

}