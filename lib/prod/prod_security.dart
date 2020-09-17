
import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/httpClient/http_handler.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/security_repository.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class ProdSecurityRepository implements SecurityRepository {

  HttpHandler httpHandler;

  ProdSecurityRepository() {
    httpHandler = new HttpHandler();
  }

  //Recuperation du token mobile money
  @override
  Future<Reponse> getTokenDevice() async {
    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
    Map<String, dynamic> data = {
      "consumerid": Config.CONSUMMER['id'],
      "consumersecret": Config.CONSUMMER['secret'],
      "imei": '',
      "os": "mix",
    };
    await Utils.getImei().then((imei){
      print(imei);
      data['imei'] = imei;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    return httpHandler.post("/authdevice", data);

    // TODO: implement getTokenDevice
  }

  //Connexion Mobile money mobile Banking
  @override
  Future<Reponse> login(String codeclient, String codesecret, String type) async{
    Map<String, String> data = {
      'codeClient' : codeclient,
      'os': 'mix',
      'secret' : codesecret,
      'imei' : '',
      'mobile' : codeclient
    };

    print('CONNEXION');

    await Utils.getImei().then((imei){
      data['imei'] = imei;
      print('imei : $imei');
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));





    if(type==Config.serviceMBanking) {
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
      data['secret'] = Utils.md5(codesecret);

      print('secret : '+data['secret']);
      print('mobile : $codeclient');



      return httpHandler.post('/abonne/connect', data);
    }else {
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
      return httpHandler.put('/signin', data);
    }
  }

  //Souscription Mobile money
  @override
  Future<Reponse> subscribe(String datenaissance, String secret, String mobile, String prenom, String nom,
      String sexe, String email, String reponse, String question, String pays, String typepiece,
      String numeropiece, String lieunaissance) async{
    Map<String, String> data = {
      'datenaissance' : datenaissance,
      'secret' : secret,
      'mobile' : mobile,
      'prenom' : prenom,
      'nom' : nom,
      'sexe' : sexe,
      'email' : email,
      'reponse' : reponse,
      'question' : question,
      'pays' : pays,
      'typepiece' : typepiece,
      'numeropiece' : numeropiece,
      'lieunaissance' : "Dakar",
      'os': 'mix',
      'imei' : ''
    };

    print('SOUSCRIPTION ®#### ${data}');

    await Utils.getImei().then((imei){
      data['imei'] = imei;
      print('imei : $imei');
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
    return httpHandler.post('/signup', data);
  }

  @override
  Future<Reponse> activation(int codeactivation, String type) async {
    Map<String, dynamic> data = {
      'codeactivation' : codeactivation,
      'code' : "$codeactivation",
      'os': 'mix',
      'imei' : '',
    };
    await Utils.getImei().then((imei){
      data['imei'] = imei;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    print(data);
    if(type==Config.serviceMBanking) {
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
      return httpHandler.post('/abonne/confirm', data);
    }else {
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
      return httpHandler.put('/signconfirm', data);
    }
  }

  @override
  Future<Reponse> getStatus(String type) async {
    // TODO: implement getStatus
    String imei = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    if(type== Config.serviceMBanking) {
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
      return httpHandler.get('/abonne/status/$imei');
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
      return httpHandler.get('/enquiries/balance/$imei');
    }
  }

  @override
  Future<Reponse> signout(String type) async{
// TODO: implement signoutMM
    String imei = '';
    await Utils.getImei().then((val){
      imei = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    if(type== Config.serviceMBanking) {
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
      return httpHandler.get('/abonne/disconnect/$imei');
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
      return httpHandler.delete('/signout/$imei');
    }
  }

  @override
  Future<Reponse> changeSecret(String password, String nouveauSecret, String confirmSecret, String type) async{
// TODO: implement signoutMM
    Map<String, dynamic> dataMoney = {
      'secret' : "string",
      'newsecret' : nouveauSecret,
      'imei' : "string",
      'os' : "mix",
    };

    Map<String, dynamic> dataBanking = {
      'ancienSecret' : Utils.md5(password),
      'nouveauSecret' : Utils.md5(nouveauSecret),
      'confirmSecret' : Utils.md5(confirmSecret),
      'codeClient' : "string",
    };

    await Utils.getImei().then((imei){
      dataMoney['imei'] = imei;
      dataBanking['imei'] = imei;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));

    await Utils.getCodeClient().then((val){
      dataBanking['codeClient'] = val;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));


    print(type);

    if(type== Config.serviceMBanking) {
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
      return httpHandler.post('/abonne/changerSecret', dataBanking);
    } else {
      await Utils.getToken().then((token) {
        print(token);
        httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
            onRequest: (Options option) async{
              option.headers['Authorization'] = token;
            }
        ));
      });
      await Utils.getFactor(Config.serviceMMoney).then((factor){
        dataMoney['secret'] = Utils.computePass(dataMoney['imei'],  factor, password);
      }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le factor n'existe pas", reponse: null)));


      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
      return httpHandler.post('/parametres/changepass', dataMoney);
    }
  }

  @override
  Future<Reponse> verify(String codesecret, String type) async{
    Map<String, String> dataMoney = {
      'os': 'mix',
      'secret' : codesecret,
      'imei' : '',
    };

    Map<String, String> dataBanking = {
      'codeClient': '',
      'secret' : codesecret,
      'imei' : '',
    };
    String _imei;
    await Utils.getImei().then((imei){
      
      _imei = imei;
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "L'imei n'existe pas", reponse: null)));
    
    
    if(type==Config.serviceMBanking) {

      dataBanking['imei'] = _imei ;

      await Utils.getCodeClient().then((val){
        dataBanking['codeClient'] = val;
      }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le code client n'existe pas", reponse: null)));

      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMBanking];
      dataBanking['secret'] = Utils.md5(codesecret);
      return httpHandler.post('/abonne/verifyPass', dataBanking);

    }else {
      await Utils.getToken().then((token) {
        print(token);
        httpHandler.diohttp.interceptors.add(InterceptorsWrapper(
            onRequest: (Options option) async{
              option.headers['Authorization'] = token;
            }
        ));
      });
      dataMoney['imei'] = _imei ;

      await Utils.getFactor(Config.serviceMMoney).then((factor){
        dataMoney['secret'] = Utils.computePass(dataMoney['imei'],  factor, codesecret);
      }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le factor n'existe pas", reponse: null)));
      httpHandler.diohttp.options.baseUrl = httpHandler.baseUrl[Config.serviceMMoney];
      return httpHandler.post('/verifypass', dataMoney);
    }
  }

}