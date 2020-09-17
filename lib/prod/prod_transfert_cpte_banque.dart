
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/transfert_cpt_banque_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdTransfertCompteBanqueRepository implements TransfertCompteBanqueRepository {

  HttpHandler httpHandler;

  ProdTransfertCompteBanqueRepository() {
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
    return httpHandler.put('/transfers/account/$id/$action', {});
  }

  @override
  Future<Reponse> payer(String secret, double montant, String banque, String pays, String titnom, String titprenom, String compte) async{
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
      "secret": "string",
      "os": "MIX",
      "montant": montant,
      "banque": banque,
      "pays": pays,
      "titnom": titnom,
      "titprenom": titprenom,
      "compte": compte,
      "imei": "string"
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getFactor(Config.serviceMMoney).then((factor){
      print('FACTOR FOCTOR $factor');
      data['secret'] = Utils.computePass(data['imei'],  factor, secret);
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le factor n'existe pas", reponse: null)));

    return httpHandler.post('/transfers/account', data);
  }

  @override
  Future<Reponse> savePreference(String libelle, String banque, String codeBanque, String codeAgence, String pays, String codePays, String nom, String prenom, String compte) async{
    await Utils.getToken().then((token) {
      print(token);
      httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
          onRequest: (Options option) async{
            option.headers['Authorization'] = token;
          }
      ));
    });

    Map<String, dynamic> data = {
      "valeur":codeBanque+codeAgence+compte,
      "libelle": libelle,
      "type": "COMPTE",
      "os": "MIX",
      "imei": "string"
    };
    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    return httpHandler.post('/preferences', data);
  }

  @override
  Future<Reponse> getPreferences() async{
    await Utils.getToken().then((token) {
      print(token);
      httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
          onRequest: (Options option) async{
            option.headers['Authorization'] = token;
          }
      ));
    });
    String imei ='';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    return httpHandler.get('/preferences/$imei/COMPTE');
    // TODO: implement getPreferences
  }

}