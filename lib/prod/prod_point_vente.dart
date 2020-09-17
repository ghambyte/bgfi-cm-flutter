
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/point_vente_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdPointVenteRepository implements PointVenteRepository {

  HttpHandler httpHandler;

  ProdPointVenteRepository() {
    httpHandler = new HttpHandler();
  }

  @override
  Future<Reponse> getPointsVente(int index, String type) async {
    // TODO: implement getInfo

    String imei = '';
    String codeClient = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    await Utils.getCodeClient().then((val){
      codeClient = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
    return httpHandler.get('/agence/all?codeClient=$codeClient&imei=$imei');
  }

}