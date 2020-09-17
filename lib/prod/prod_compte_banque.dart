
import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/compte_banque_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdCompteBanqueRepository implements CompteBanqueRepository {

  HttpHandler httpHandler;

  ProdCompteBanqueRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> confirmer(String id, int action, String token) {
    // TODO: implement confirmer
    httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
        onRequest: (Options option) async{
          option.headers['Authorization'] = token;
        }
    ));
    return httpHandler.put('/achatcredit/$id/$action', {});
  }

  @override
  Future<Reponse> payer(String secret, double montant, String mobile, String carrier) async{
    // TODO: implement payer
    Map<String, dynamic> data = {
      "secret": "string",
      "os": "MIX",
      "montant": montant,
      "mobile": mobile,
      "carrier": carrier,
      "imei": "string"
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getFactor(Config.serviceMMoney).then((factor){
      print('FACTOR FOCTOR $factor');
      data['secret'] = Utils.computePass(data['imei'],  factor, secret);
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le factor n'existe pas", reponse: null)));

    return httpHandler.post('/achatcredit', data);
  }

  @override
  Future<Reponse> comptes() async {
    String imei = '';
    String codeClient = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      codeClient = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.get('/compte/$codeClient/$imei');
  }

}