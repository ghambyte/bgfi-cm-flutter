
import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/preference_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdPreferenceRepository implements PreferenceRepository{

  HttpHandler httpHandler;

  ProdPreferenceRepository() {
    httpHandler = new HttpHandler();
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
  }

  @override
  Future<Reponse> getPreferences(String type) async{
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
    return httpHandler.get('/preferences/$imei/$type');
  }

  @override
  Future<Reponse> savePreference(String libelle, String valeur, String type) async{
    await Utils.getToken().then((token) {
      print(token);
      httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
          onRequest: (Options option) async{
            option.headers['Authorization'] = token;
          }
      ));
    });
    Map<String, dynamic> data = {
      "valeur": valeur,
      "libelle": libelle,
      "type": type,
      "os": "MIX",
      "imei": "string"
    };
    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    return httpHandler.post('/preferences', data);
  }

}