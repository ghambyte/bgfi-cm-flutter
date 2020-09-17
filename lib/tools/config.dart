enum FLAVOR {
  MOCK,
  PROD
}

class Config {

  static const String TOKEN = 'token';

  static const String INIT = 'initial';

  static const String LOGIN_MONEY = 'logmoney';

  static const String LOGIN_Banking = 'logbanking';

  static const String CODE_CLIENT = 'codeclient';

  static const String factorMoney = 'factmoney';

  static const String factorMBanking = 'factbanking';

  static const String serviceMBanking = 'banking';

  static const String serviceMMoney = 'money';

  static const String connectedMMoney = "connectedMM";

  static const String connectedMbanking = "connectedMB";

  static const int codeSuccess = 1000;

  static const int codeError = 4000;

  static const int CODE_ERROR_INTERNE = 12000;

  static const String IMEI = 'imei';

  static const CONSUMMER ={'id':'88d2d7dc-0470-11e9-ad6b-fc15b48e1b50', 'secret': '271cf3189f11f3905760cf657c43168ff18f9239'};

  static const BASE_URL_PROD ={'banking':'http://', 'money': 'http://'};

//  static const BASE_URL_TEST ={'banking':'http://89.30.96.166:1003', 'money': 'http://89.30.96.166:1000'};

//  static const BASE_URL_TEST ={'banking':'https://cm-mobilebanking.bgfimobilecenter.com', 'money': 'https://cm-mobilemoney.bgfimobilecenter.com'};
  static const BASE_URL_TEST ={'banking':'https://cm-prod-mobilebanking.chakamobile.com', 'money': 'https://cm-prod-nafabackend.chakamobile.com'};
  static const code_miles = '88534766';

  static const String compte = 'compteclient';

  static const String agence = 'agenceclient';

}