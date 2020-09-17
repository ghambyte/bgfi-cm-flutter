
import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/paiement_marchant_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdPaiementMarchantRepository implements PaiementMarchantRepository {

  HttpHandler httpHandler;

  ProdPaiementMarchantRepository() {
    httpHandler = new HttpHandler();
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
  }

  @override
  Future<Reponse> confirmer(String id, int action, String token) {
    httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
        onRequest: (Options option) async{
          option.headers['Authorization'] = token;
        }
    ));
    return httpHandler.put('/paiementmarchand/$id/$action', {});
  }

  @override
  Future<Reponse> payer(String secret, double montant, String code) async {
    await Utils.getToken().then((token) {
      print(token);
      httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
          onRequest: (Options option) async{
            option.headers['Authorization'] = token;
          }
      ));
    });
    Map<String, dynamic> data = {
      "parametre": code,
      "secret": "string",
      "os": "MIX",
      "montant": montant,
      "imei": "string"
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getFactor(Config.serviceMMoney).then((factor){
      print('FACTOR FOCTOR $factor');
      data['secret'] = Utils.computePass(data['imei'],  factor, secret);
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le factor n'existe pas", reponse: null)));

    return httpHandler.post('/paiementmarchand', data);
  }

}