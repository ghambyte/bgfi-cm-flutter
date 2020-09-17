
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/messagerie_repository.dart';
import 'package:gui/repository/virement_banque_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdMessagerieRepository implements MessagerieRepository {

  HttpHandler httpHandler;

  ProdMessagerieRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> send(String objet, String compte, String agence, String message) async {
    Map<String, dynamic> data = {
      "codeClient": "string",
      "objet": objet,
      "compte": compte,
      "codeAgence": agence,
      "message": message,
      "imei": "string"
    };
    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getCodeClient().then((val){
      data['codeClient'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));

    print(data);
    return httpHandler.post('/message/new', data);
  }

  @override
  Future<Reponse> getMessages(int index, String type) async {
    String imei = '';
    String codeClient = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      codeClient = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.get('/message/list?codeClient=$codeClient&imei=$imei&type=1&per_page=10&page=$index');
  }

}