
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/newVirementItem.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/beneficiaire_repository.dart';
import 'package:gui/repository/virement_banque_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdBeneficiaireRepository implements BeneficiaireRepository {

  HttpHandler httpHandler;

  ProdBeneficiaireRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> addBeneficiaire(String numCpt,
      String nomTitulaire, String codeBanque, String codeGuichet,
      String nomBanque, String typeCompte) async {

    Map<String, dynamic> data = {
      "codeClient": "string",
      "imei": "string",
      "numCpt": numCpt,
      "nomTitulaire": nomTitulaire,
      "codeBanque": codeBanque,
      "codeGuichet": codeGuichet,
      "nomBanque": nomBanque,
      "typeCompte": typeCompte
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      data['codeClient'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));

    print(data);
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.post('/beneficiare/add/', data);
  }

  @override
  Future<Reponse> deleteBeneficiaire(String id) async {
    Map<String, String> beneficiaire = new Map();
    var liste = new List();
    beneficiaire = {
      "id": id,
    };
    liste.add(beneficiaire);

    Map<String, dynamic> data = {
      "codeClient": "string",
      "imei": "string",
      "beneficiaires": liste
    };

    await Utils.getImei().then((val){
      data['imei'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      data['codeClient'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));

    print(data);
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.put('/beneficiare/del/', data);
  }

  @override
  Future<Reponse> getBeneficiaires() async {
    String imei = '';
    String codeClient = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      codeClient = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.get('/beneficiare/all/$codeClient/$imei');
  }

}