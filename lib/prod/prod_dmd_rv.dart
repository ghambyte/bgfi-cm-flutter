
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/achat_credit_repository.dart';
import 'package:gui/repository/dmd_rv_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdDmdRvRepository implements DmdRvRepository {

  HttpHandler httpHandler;

  ProdDmdRvRepository() {
    httpHandler = new HttpHandler();
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
  }

  @override
  Future<Reponse> demanderRV(/*String secret, */String compte, String objet, String date, String agence) async{
    // TODO: implement payer
    Map<String, dynamic> data = {
      "codeClient": "string",
      //"os": "MIX",
      "imei": "string",
      "objet": objet,
      "compte": compte,
      "date": date,
      "agence": agence,
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getCodeClient().then((val){

      data['codeClient']= val ;

      print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      print(data);

    }).catchError((error) => throw new FetchException(Reponse(statutcode: Config.codeError, message : "Le code Client n'existe pas", reponse: null)));

    return httpHandler.post('/rv/new', data);
  }

}