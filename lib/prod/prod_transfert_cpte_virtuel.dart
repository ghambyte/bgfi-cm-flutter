
import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/transfert_cpt_virtuel_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdTransfertCompteVirtuelRepository implements TransfertCompteVirtuelRepository {

  HttpHandler httpHandler;

  ProdTransfertCompteVirtuelRepository() {
    httpHandler = new HttpHandler();
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
  }

  @override
  Future<Reponse> confirmer(String id, int action, String token, String isgimac) {
    // TODO: implement confirmer
    httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
        onRequest: (Options option) async{
          option.headers['Authorization'] = token;
        }
    ));
    return httpHandler.put('/transfers/virtualaccount/$id/$action/$isgimac', {});
  }

  @override
  Future<Reponse> payer(String secret, double montant, String compteBeneficiaire, String iden) async{
    // TODO: implement payer
    // TODO: implement payer
    Map<String, dynamic> data = {
      "secret": "string",
      "os": "MIX",
      "montant": montant,
      "iden": iden,
      "compte_beneficiaire": compteBeneficiaire,
      "imei": "string"
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getFactor(Config.serviceMMoney).then((factor){
      print('FACTOR FOCTOR $factor');
      data['secret'] = Utils.computePass(data['imei'],  factor, secret);
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le factor n'existe pas", reponse: null)));

    return httpHandler.post('/transfers/virtualaccount', data);
  }



}