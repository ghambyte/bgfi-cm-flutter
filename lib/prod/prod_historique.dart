
import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/historique_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdHistoriqueRepository implements HistoriqueRepository {

  HttpHandler httpHandler;

  ProdHistoriqueRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> getInfo(int index, String type) async {
    // TODO: implement getInfo

    String imei = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    if(type== Config.serviceMBanking) {
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
      return httpHandler.get('/enquiries/operations/$imei/$index');
    } else {
      await Utils.getToken().then((token) {
        print(token);
        httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
            onRequest: (Options option) async{
              option.headers['Authorization'] = token;
            }
        ));
      });
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
      return httpHandler.get('/enquiries/operations/$imei/$index');
    }
  }

  @override
  Future<Reponse> detailsInfo(String codeSecret, String reference) async {
    // TODO: implement detailsInfo
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
    await Utils.getToken().then((token) {
      print(token);
      httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
          onRequest: (Options option) async{
            option.headers['Authorization'] = token;
          }
      ));
    });
    Map<String, dynamic> data = {
      "reference": reference,
      "secret": "string",
      "os": "MIX",
      "imei": "string"
    };
    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getFactor(Config.serviceMMoney).then((factor){

      print('factor $factor');
      data['secret'] = Utils.computePass(data['imei'],  factor, codeSecret);
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    return httpHandler.post('/enquiries/infos', data);
  }

}