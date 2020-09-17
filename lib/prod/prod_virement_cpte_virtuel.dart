
import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/point_vente_repository.dart';
import 'package:gui/repository/taux_change_repository.dart';
import 'package:gui/repository/virement_cv_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdVirementCptVirtuelRepository implements VirementCVRepository {

  HttpHandler httpHandler;

  ProdVirementCptVirtuelRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> getVirements(int index, String type) async {
    String imei = '';
    String codeClient = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      codeClient = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.get('/compte/virementCompte/$codeClient/$imei');
  }

  @override
  Future<Reponse> virement(String secret, String source, String codeAgence, String motif, String compteVirtuel, String montant) async {
    await Utils.getToken().then((token) {
      print(token);
      httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
          onRequest: (Options option) async{
            option.headers['Authorization'] = token;
          }
      ));
    });
    Map<String, dynamic> data = {
      "secret": Utils.md5(secret),
      "os": "MIX",
      "montant": montant,
      "motif": motif,
      "compteVirtuel": compteVirtuel,
      "source": source,
      "codeAgence": codeAgence,
      "codeClient": 'string',
      "imei": "string"
    };
    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      data['codeClient'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));
    print(data);
    return httpHandler.post('/compte/rechargeVirtual', data);
  }

}