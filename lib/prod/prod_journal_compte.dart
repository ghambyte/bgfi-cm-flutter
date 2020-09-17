
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/compte_banque_repository.dart';
import 'package:gui/repository/journal_banque_repository.dart';
import 'package:gui/repository/point_vente_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdJournalCompteRepository implements JournalBanqueRepository {

  HttpHandler httpHandler;

  ProdJournalCompteRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> getJournal(int index, String type) async {
    String imei = '';
    String codeClient = '';
    String compte = '';
    String agence = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      codeClient = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));
    await Utils.getCompteClient().then((val){
      compte = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le compte n'existe pas", reponse: null)));
    await Utils.getAgenceClient().then((val){
      agence = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code agence n'existe pas", reponse: null)));
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
//    return httpHandler.get('/agence/all?codeClient=$codeClient&imei=$imei');
    return httpHandler.get('/journal/$codeClient/$imei/$compte/$agence');
  }

}