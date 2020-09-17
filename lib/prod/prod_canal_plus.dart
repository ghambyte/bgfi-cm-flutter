
import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/canal_plus_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdCanalPlusRepository implements CanalPlusRepository{

  HttpHandler httpHandler;

  ProdCanalPlusRepository() {
    httpHandler = new HttpHandler();
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
  }

  @override
  Future<Reponse> confirmer(String id, int action, String token) {
    // TODO: implement confirmer
    httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
        onRequest: (Options option) async{
          option.headers['Authorization'] = token;
        }
    ));
    return httpHandler.put('/factures/cplus/$id/$action', {});
  }

  @override
  Future<Reponse> payer(String secret, String carte, String formule, String duree, String charme, String ssport, String ecran) async{
    // TODO: implement payer
    await Utils.getToken().then((token) {
      print(token);
      httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
          onRequest: (Options option) async{
            option.headers['Authorization'] = token;
          }
      ));
    });
    Map<String, dynamic> data = {
      "carte": carte,
      "secret": "string",
      "formule": formule,
      "duree": duree,
      "options": charme,
      "type": ecran,
      "imei": "string",
      "os": "MIX"
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getFactor(Config.serviceMMoney).then((factor){
      print('FACTOR FOCTOR $factor');
      data['secret'] = Utils.computePass(data['imei'],  factor, secret);
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le factor n'existe pas", reponse: null)));

    return httpHandler.post('/factures/cplus', data);
  }
}