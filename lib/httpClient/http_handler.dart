import 'package:dio/dio.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

class HttpHandler {

  static final HttpHandler _singleton = new HttpHandler._internal();

  Dio _dio;
  Map<String, String> _baseUrl;

  factory HttpHandler() {
    return _singleton;
  }

  HttpHandler._internal() {
    BaseOptions options = new BaseOptions(
      connectTimeout: 1000000,
      receiveTimeout: 2000000,
    );
    _dio = Dio(options);
    _baseUrl = new InjectorApp().baseUrl;
    _setupLoggingInterceptor();
  }

  Dio get diohttp => _dio;

  Map<String, String> get baseUrl => _baseUrl;

  void _setupLoggingInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          if(options.baseUrl == baseUrl[Config.serviceMMoney] && options.path !='/authdevice' && options.headers['Authorization']==null) {
            print("******  AUTHORISATION ******");
            print("******  ${options.headers['Authorization']} ******");
            print("******  ${options.path} ******");
            await Utils.getToken().then((token) {
              print(token);
              options.headers['Authorization'] = token;
            });
          }
          return options;
        },
        onResponse:(Response response) async {
          // Do something with response data
          print(response.statusCode);
          print(response.data.toString());
          //print('res ${response.statusCode}');
          if(response.data['factor']!=null && response.data['factor']!=0) {
            print(response.data);
            if(_dio.options.baseUrl==baseUrl[Config.serviceMMoney]) {
              await Utils.saveFactor(Config.serviceMMoney, response.data['factor']);
            } else if (_dio.options.baseUrl==baseUrl[Config.serviceMBanking]) {
              await Utils.saveFactor(Config.serviceMBanking, response.data['factor']);
            }
          }
          return response; // continue
        },
        onError: (DioError error) {
          print(error.response.data);
          return error;
        }
    ));

  }

  Future<Reponse> post (String url, Map<String, dynamic> data) {
    print("#### URL ##### ${_dio.options.baseUrl}");
    return _dio.post(
      url,
      data: data,
    ).then((response){
      if(response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 220) {
        print("STATUS : $response.statusCode");
        return Reponse(statutcode: Config.codeSuccess, message: 'Opération reussie', reponse: response.data) ;
      } else {
        print("STATUS : $response.statusCode");
        print(response.data);
        print(response);
        throw new FetchException(Reponse(statutcode: Config.codeError, message: "Une erreur s'est produite", reponse: response.data)) ;
      }
    }).catchError((onError) {
      print('### ERROR ${onError.toString()}');


      throw new FetchException(Reponse(statutcode: Config.codeError, message: Utils.handleError(onError),  reponse: null));
    });
  }

  Future<Reponse> put (String url, Map<String, dynamic> data) {
    return _dio.put(
      url,
      data: data,
    ).then((response){
      if(response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 220) {
        return Reponse(statutcode: Config.codeSuccess, message: 'Opération reussie', reponse: response.data) ;
      } else {
        throw new FetchException(Reponse(statutcode: Config.codeError, message: "Une erreur s'est produite", reponse: response.data)) ;
      }
    }).catchError((onError) {
      print(Utils.handleError(onError));
      throw new FetchException(Reponse(statutcode: Config.codeError, message: Utils.handleError(onError),  reponse: null));
    });
  }

  Future<Reponse> get (String url) {
    return _dio.get(url,).then((response){
      if(response.statusCode == 200) {
        return Reponse(statutcode: Config.codeSuccess, message: 'Opération reussie', reponse: response.data) ;
      } else {
        throw new FetchException(Reponse(statutcode: Config.codeError, message: "Une erreur s'est produite", reponse: response.data)) ;
      }
    }).catchError((onError) {
      throw new FetchException(Reponse(statutcode: Config.codeError, message: Utils.handleError(onError),  reponse: null));
    });
  }

  Future<Reponse> delete (String url) {
    return _dio.delete(url,).then((response){
      if(response.statusCode == 200) {
        return Reponse(statutcode: Config.codeSuccess, message: 'Opération reussie', reponse: response.data) ;
      } else {
        throw new FetchException(Reponse(statutcode: Config.codeError, message: "Une erreur s'est produite", reponse: response.data)) ;
      }
    }).catchError((onError) {
      throw new FetchException(Reponse(statutcode: Config.codeError, message: Utils.handleError(onError),  reponse: null));
    });
  }
}