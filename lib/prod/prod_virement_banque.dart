import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/beneficiaire.dart';
import 'package:gui/models/newVirementItem.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/models/virementbankitem.dart';
import 'package:gui/repository/virement_banque_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'dart:convert';

class ProdVirementBanqueRepository implements VirementBanqueRepository {
  HttpHandler httpHandler;

  ProdVirementBanqueRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> virement(
      String secret, List<VirementBankItem> beneficiaires) async {
    Map<String, dynamic> data = new Map();

    var liste = new List();

    Map<String, String> beneficiaire = new Map();

    for (var i = 0; i < beneficiaires.length; i++) {
      beneficiaire = {
        "numCptADebiter": beneficiaires[i].numCptADebiter,
        "codeAgence": beneficiaires[i].codeagence,
        "libelle": beneficiaires[i].libelle,
        "montant": beneficiaires[i].montant,
        "nomBeneficiaire": beneficiaires[i].nomBeneficiaire,
        "nomBanque": beneficiaires[i].nomBanque,
        "codeBanque": beneficiaires[i].codeBanque,
        "codeGuichet": beneficiaires[i].codeGuichet,
        "compte": beneficiaires[i].compte,
      };
      liste.add(beneficiaire);
    }
    data["beneficiaire"] = liste;
    data["secret"] = Utils.md5(secret);

    String imei = '';
    String codeClient = '';
    await Utils.getImei().then((val) {
      imei = val;
    }).catchError((error) => throw new FetchException(Reponse(
        statutcode: Config.codeError,
        message: "L'imei n'existe pas",
        reponse: null)));
    await Utils.getCodeClient().then((val) {
      codeClient = val;
    }).catchError((error) => throw new FetchException(Reponse(
        statutcode: Config.codeError,
        message: "Le code client n'existe pas",
        reponse: null)));
    print("**********************************************");
    print(data);
    print("**************************************************");
    httpHandler.diohttp.options.baseUrl =
        httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.post('/virements/$codeClient/$imei', data);
  }

  @override
  Future<Reponse> getVirements(int index, String type) async {
    String imei = '';
    String codeClient = '';
    await Utils.getImei().then((val) {
      imei = val;
    }).catchError((error) => throw new FetchException(Reponse(
        statutcode: Config.codeError,
        message: "L'imei n'existe pas",
        reponse: null)));
    await Utils.getCodeClient().then((val) {
      codeClient = val;
    }).catchError((error) => throw new FetchException(Reponse(
        statutcode: Config.codeError,
        message: "Le code client n'existe pas",
        reponse: null)));
    httpHandler.diohttp.options.baseUrl =
        httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.get('/virements/$codeClient/$imei');
  }
}
