import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:gui/models/item_menu.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/pages/banking/commandes_chequier.dart';
import 'package:gui/pages/banking/comptes_banque.dart';
import 'package:gui/pages/banking/dmd_rv.dart';
import 'package:gui/pages/banking/messagerie.dart';
import 'package:gui/pages/banking/point_vente.dart';
import 'package:gui/pages/banking/reseau_gab.dart';
import 'package:gui/pages/banking/taux_change.dart';
import 'package:gui/pages/banking/virements_banque.dart';
import 'package:gui/pages/banking/virements_virtuels.dart';
import 'package:gui/pages/money/achat_credit.dart';
import 'package:gui/pages/money/bgfi_express.dart';
import 'package:gui/pages/money/canal_massando.dart';
import 'package:gui/pages/money/canal_plus.dart';
import 'package:gui/pages/money/canal_sol.dart';
import 'package:gui/pages/money/fenix.dart';
import 'package:gui/pages/money/historique.dart';
import 'package:gui/pages/money/miles_travel.dart';
import 'package:gui/pages/money/paiement_line.dart';
import 'package:gui/pages/money/paiement_marchant.dart';
import 'package:gui/pages/money/retrait_cash.dart';
import 'package:gui/pages/money/transfert_cpt_bank.dart';
import 'package:gui/pages/money/transfert_cpt_virtuel.dart';
import 'package:gui/pages/money/transfert_gab.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

class Utils {

  static String computePass(String imei,int factor,String secret){
    String codePayment = generateCode();
    String factored = factoreString(imei, factor);
    String md5Codepayment = md5(codePayment);
    String combinated = combinateString(factored, md5Codepayment);
    String md5secret = md5(secret);
    String hash = hashSign(combinated,md5secret);
    String pass = codePayment+hash;
    print(pass);
    return pass;
  }

  static String generateCode(){
    var randomizer = new Random();
    var num = randomizer.nextInt(90000000)+10000000;
    print(num);
    return num.toString();
  }

  static String factoreString(String imei,int factor){
    print("Entree factoreString:"+imei+"-"+factor.toString());
    String factored = "";
    for(int i=0;i<imei.length;i++){
      print("VOULOU:"+imei.codeUnitAt(i).toString());
      int produit = imei.codeUnitAt(i)*factor;
      factored+=produit.toString();
    }
    print("factoreString:"+md5(factored));
    return  md5(factored);
  }

  static String hashSign(String mdstring1,String mdstring2){
    print("Entree hashSign:"+mdstring1+"-"+mdstring2);
    List<String> mixed = mixString(mdstring1,mdstring2);
    String pass = "";
    pass+= addMod(mixed[0]);
    pass+= addMod(mixed[1]);
    pass+= addMod(mixed[2]);
    pass+= addMod(mixed[3]);
    print("hashSign:"+pass.toUpperCase());
    return pass.toUpperCase();
  }

  static String combinateString(String mdstring1,String mdstring2){
    print("Entree combinateString:"+mdstring1+"-"+mdstring2);
    String combination = "";
    for(int i=0;i<mdstring1.length;i++){
      int produit=mdstring1.codeUnitAt(i)*mdstring2.codeUnitAt(i);
      combination+=produit.toString();
    }
    print("combinateString:"+md5(combination));
    return  md5(combination);
  }

  static String addMod(String string){

    print("Entree addMod:"+string);
    int add = 0;
    for(int i=0;i<string.length;i++){
      add+=string.codeUnitAt(i);
    }
    add %= 100;
    print("addMod:"+((add<10)?"0":"")+add.toString());
    return ((add<10)?"0":"")+add.toString();
  }


  static  List<String> mixString(String mdstring1,String mdstring2){
    var mix = ["","","",""];
    for(int i=0;i<mdstring1.length;i++){
      int somme = mdstring1.codeUnitAt(i)+ mdstring2.codeUnitAt(i);
      print(mdstring1[i]+"+"+mdstring2[i]+"="+somme.toString());
      mix[i%4] += somme.toString();

    }
    return  mix;
  }

  static Future<String> getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(Config.TOKEN);
  }

  static Future<String> getLogin(String service) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try{
      return service=='banking'?_prefs.getString(Config.LOGIN_Banking):_prefs.getString(Config.LOGIN_MONEY);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveLogin(String service, String nom) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    service=='banking'?_prefs.setString(Config.LOGIN_Banking, nom):_prefs.setString(Config.LOGIN_MONEY, nom);
  }

  static Future<void> saveCodeClient(String code) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(Config.CODE_CLIENT, code);
  }

  static Future<String> getCodeClient() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try{
      return _prefs.getString(Config.CODE_CLIENT);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveCompteClient(String compte) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print('## compte ## ${compte}');
    _prefs.setString(Config.compte, compte);
  }

  static Future<String> getCompteClient() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try{
      return _prefs.getString(Config.compte);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAgenceClient(String agence) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(Config.agence, agence);
  }

  static Future<String> getAgenceClient() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try{
      return _prefs.getString(Config.agence);
    } catch (_) {
      return null;
    }
  }

  static Future<int> getFactor(String service) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return service==Config.serviceMBanking?_prefs.getInt(Config.serviceMBanking):_prefs.getInt(Config.serviceMMoney);
  }

  static Future<void> removeFactor(String service) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    service==Config.serviceMBanking?_prefs.remove(Config.serviceMBanking):_prefs.remove(Config.serviceMMoney);
  }

  static Future<void> removeLogin(String service) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    service==Config.serviceMBanking?_prefs.remove(Config.LOGIN_Banking):_prefs.remove(Config.LOGIN_MONEY);
  }

  static Future<void> saveFactor(String service, int factor) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    service==Config.serviceMBanking?_prefs.setInt(Config.serviceMBanking, factor):_prefs.setInt(Config.serviceMMoney, factor);
  }

  static Future<String> getImei() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String imei= _prefs.getString(Config.IMEI);
    if(imei==null) {
      imei = new Uuid().v1();
      _prefs.setString(Config.IMEI, imei);
    }
    return imei;
  }

  static Future<String> getInit() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(Config.INIT);
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(Config.TOKEN, token);
  }

  static Future<void> saveInit(String init) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(Config.INIT, init);
  }

  static Future<String> getMoneyState() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.getString(Config.connectedMMoney);
  }

  static Future<void> saveMoneyState(String init) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(Config.connectedMMoney, init);
  }

  static String handleError(DioError error) {
    print('REQUEST HTTP >> ');
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription = "La requete a été annulée";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Le serveur a mis trop de temps pour repondre";
          break;
        case DioErrorType.DEFAULT:
          errorDescription = "Probleme de connexion internet";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Le serveur a mis trop de temps pour repondre";
          break;
        case DioErrorType.RESPONSE:
          if(error.response.statusCode == 500) {
            errorDescription = "une erreur s'est produite";
            print('7777777- '+errorDescription);
            print('7777777- '+error.response.data['message']);
            print('HTTP CODE : '+error.response.statusCode.toString());
            print('REPONSE : '+error.response.data.toString());
          } else {
            print('7777777- '+errorDescription);
            errorDescription = error.response.data['message']==null?"une erreur s'est produite":error.response.data['message'];
          }
          break;
        default:
          errorDescription = "Probleme de connexion.";
      }
    } else {
      errorDescription = "Une erreur est survenue reessayez plutard";
    }
    print('7777777- '+errorDescription);
    print('7777777- '+errorDescription);
    return errorDescription;
  }

  static void redirectToPage(BuildContext context, Widget page){

    WidgetsBinding.instance.addPostFrameCallback((_){
      MaterialPageRoute newRoute = MaterialPageRoute(
          builder: (BuildContext context) => page
      );

      Navigator.of(context).pushAndRemoveUntil(newRoute, ModalRoute.withName('/welcome'));
    });

  }
  
  static void pop(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
       Navigator.pop(context);
    });
  }

  static void showDialogProgress(BuildContext context,  String message){
    WidgetsBinding.instance.addPostFrameCallback((_){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 3.0),
                    child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.blue)),
                  ),
                  new Expanded(child: new Text(message))
                ],
              ),
            );
          },
          barrierDismissible: false
      );
    });
  }

  static void dialog(BuildContext context,  String message, String title, bool dismiss){
    WidgetsBinding.instance.addPostFrameCallback((_){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: new Text(title),
                content: new Text(message),
              actions: <Widget>[
                FlatButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('OK'))
              ],
            );
          },
          barrierDismissible: dismiss
      );
    });
  }
  
  static void aletreDialog(BuildContext context,  String message, String title, bool dismiss){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: new Text(title),
                content: new Text(message),
              actions: <Widget>[
                FlatButton(onPressed: () =>Navigator.pop(context), child: Text('OK'))
              ],
            );
          },
          barrierDismissible: dismiss
      );
  }

  static void alertSecret(BuildContext context,String title,String buttonTitle, Function(String) f) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String codesecret;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: Form (
              key: formKey,
              child:new TextFormField(

                decoration: new InputDecoration(labelText: "CODE SECRET",
                    labelStyle: new TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    )),
                keyboardType: TextInputType.number,
                validator: (val) => val.length!=4 ? 'CODE SECRET INVALIDE' : null,
                onSaved: (val) => codesecret = val,
                obscureText: true,
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
                child: new Text("FERMER", style: new TextStyle(color: Colors.black)),
                onPressed: (){
                  Navigator.of(context).pop();
                }
            ),
            new FlatButton(
                child: new Text(buttonTitle),
                onPressed: (){
                  print("ACTION SUBMIT");
                  final form = formKey.currentState;
                  if (form.validate()) {
                    print("FORM OK ####");
                    form.save();
                    Navigator.of(context).pop();
                    f(codesecret);
                  }
                }
            ),

          ],
        );
      },
    );
  }

  static String md5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static List<ItemMenu> menuMM = [
    new ItemMenu(icon: 'images/icon/mm/icon-h.png', texte: 'Historique', widget: HistoriquePage(), hist: true, image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-pm.png', texte: 'Paiement marchand', widget: PaiementMarchantPage(), index: 0, image: Image.asset("images/icon/mm/ic-tab-pm.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-tgab.png', texte: 'Transfert GAB', widget: TransfertGabPage(), index: 1, image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-ac.png', texte: 'Achat credit', widget: AchatCreditPage(), index: 2, image: Image.asset("images/icon/mm/ic-tab-ac.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-rc.png', texte: 'Retrait Cash', widget: RetraitCashPage(), index: 3, image: Image.asset("images/icon/mm/ic-tab-rc.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-tcb.png', texte: 'Transfert cpte banque', widget: TransfertCompteBanquePage(), index: 4, image: Image.asset("images/icon/mm/ic-tab-cb.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-tcb.png', texte: 'Transfert cpte virtuel', widget: TransfertCompteVirtuelPage(), index: 5,image: Image.asset("images/icon/mm/ic-tab-cv.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-express.png', texte: 'BGFI Express', widget: BgfiExpressPage(), index: 6,image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/ic-canal.png', texte: 'Canal +', widget: CanalPlusPage(), index: 7,image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
    //new ItemMenu(icon: 'images/icon/mm/canal-sol.png', texte: 'Canal SOL', widget: CanalSolPage(), index: 9,image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
    //new ItemMenu(icon: 'images/icon/mm/canal-mas.png', texte: 'Canal Mansando', widget: CanalMassandoPage(), index: 10, image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
    //new ItemMenu(icon: 'images/icon/mm/miles1.png', texte: 'Miles Travel', widget: MilesTravelPage(), index: 11, image: Image.asset("images/icon/mm/ic-tab-miles.png",height: 25.0,width: 25.0,)),
    //new ItemMenu(icon: 'images/icon/mm/fenix01.png', texte: 'Facture Fenix', widget: FenixPage(), index: 12, image: Image.asset("images/icon/mm/ic-tab-fenix.png",height: 25.0,width: 25.0,)),
  ];

  static List<ItemMenu> menuMB = [
    new ItemMenu(icon: 'images/icon/mm/icon-pm.png', texte: 'Compte Banque', widget: CompteBanquePage(), compte: true, image: Image.asset("images/icon/mm/ic-tab-pm.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-tgab.png', texte: 'Virements bancaires', widget: VirementsBanquePage(), index: 0, image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-ac.png', texte: 'Virements compte virtuel', widget: VirementsVirtuelsPage(), index: 1, image: Image.asset("images/icon/mm/ic-tab-ac.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-rc.png', texte: 'Demande de RV', widget: DmdRvPage(), index: 2, image: Image.asset("images/icon/mm/ic-tab-rc.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-tcb.png', texte: 'Commandes chéquier', widget: ChequierPage(), index: 3, image: Image.asset("images/icon/mm/ic-tab-cb.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-pl.png', texte: 'Taux de change', widget: TauxChangePage(), index: 4, image: Image.asset("images/icon/mm/ic-tab-pl.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-tcb.png', texte: 'Messagerie', widget: MessageriePage(), index: 5,image: Image.asset("images/icon/mm/ic-tab-cv.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-express.png', texte: 'Point de vente', widget: PointVentePage(), index: 6,image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
    new ItemMenu(icon: 'images/icon/mm/icon-h.png', texte: 'Réseau de GABs', widget: ReseauGabPage(), gab: true, image: Image.asset("images/icon/mm/ic-tab-gab.png",height: 25.0,width: 25.0,)),
  ];

  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void alerteInfo(BuildContext context, List<NFDetailsInfo> nfs) {
    String message = "";
    for (NFDetailsInfo item in nfs ){
      if(item.label!=null && item.value != null){
        message +="- " +  item.label+" : "+item.value+"\n";
      }
    }
    Utils.dialog(context, message, 'INFOS', false);

  }

  static void alertConfirm(BuildContext context,String title,List<NFDetailsInfo> nfs,String buttonTitle,Function() confirm, Function() annuler, {isfermer: true, isvalid: true}) {
    // flutter defined function
    String message = "";
    for (NFDetailsInfo item in nfs ){
      if(item.label!=null && item.value != null){
        message +="- " +  item.label+" : "+item.value+"\n";
      }
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            isfermer?new FlatButton(
                child: new Text("ANNULER"),
                onPressed: (){
                  Navigator.pop(context);
                  annuler();
                }
            ):Container(),
            isvalid? new FlatButton(
                child: new Text(buttonTitle),
                onPressed: (){
                  Navigator.pop(context);
                  confirm();
                }
            ):Container(),

          ],
        );
      },
    );
  }

  static void alertDialog(BuildContext context, String title,List<NFDetailsInfo> nfs,Function() confirm, Function() annuler, bool dismiss){
//    YYAlertDialogWithDivider(context);
    String message = "";
    for (NFDetailsInfo item in nfs ){
      if(item.label!=null && item.value != null){
        message +="- " +  item.label+" : "+item.value+"\n";
      }
    }
//    nfs.forEach((k)=>message +="- " +  k.label+" : "+k.value+"\n");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title, style: TextStyle(color: Colors.black.withOpacity(0.9),fontWeight: FontWeight.w500)),
            content: new Text(message, style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14.0)),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.pop(context);
                annuler();
              }, child: Text('ANNULER', style: TextStyle(color: Colors.black.withOpacity(0.6),),),),

              FlatButton(onPressed: (){
                Navigator.pop(context);
                confirm();
              }, child: Text('VALIDER', style: TextStyle(color: Colors.blue)))
            ],
          );
        },
        barrierDismissible: dismiss
    );
  }

  static void alertInfoOne(BuildContext context, List<NFDetailsInfo> nfs){
//    YYAlertDialogWithDivider(context);
    String message = "";
    for (NFDetailsInfo item in nfs ){
      if(item.label!=null && item.value != null){
        message +="- " +  item.label+" : "+item.value+"\n";
      }
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("INFOS", style: TextStyle(color: Colors.black.withOpacity(0.9),fontWeight: FontWeight.w500)),
            content: new Text(message, style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14.0)),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('OK', style: TextStyle(color: Colors.blue)))
            ],
          );
        },
        barrierDismissible: false
    );
  }

  static YYDialog YYAlertDialogWithDivider(BuildContext context, YYDialog yyDialog, String title,List<NFDetailsInfo> nfs,Function() confirm, Function() annuler, bool dismiss) {
    String message = "";
    for (NFDetailsInfo item in nfs ){
      if(item.label!=null && item.value != null){
        message +="- " +  item.label+" : "+item.value+"\n";
      }
    }
    yyDialog = YYDialog();
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 4.0
      ..barrierDismissible = dismiss
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: title,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: message,
        color: Colors.black,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
      )
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "ANNULER",
        color1: Colors.black,
        fontSize1: 14.0,
        fontWeight1: FontWeight.w500,
        onTap1: () {
          annuler();
          yyDialog.dismiss();
          yyDialog.dismiss();
        },
        text2: "VALIDER",
        color2: ColorApp.blue,
        fontSize2: 12.0,
        fontWeight2: FontWeight.w500,
        onTap2: () {
          confirm();
          yyDialog.dismiss();
          yyDialog.dismiss();
        },
      )
      ..show();
  }

  static YYDialog YYAlertInfoDialogWithDivider(BuildContext context, String title, YYDialog yyDialog,List<NFDetailsInfo> nfs) {
    String message = "";
    for (NFDetailsInfo item in nfs ){
      if(item.label!=null && item.value != null){
        message +="- " +  item.label+" : "+item.value+"\n";
      }
    }
    yyDialog = YYDialog();
    return YYDialog().build(context)
      ..width = 220
      ..borderRadius = 4.0
      ..barrierDismissible = false
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: title,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: message,
        color: Colors.black,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
      )
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "",
        color1: Colors.black,
        fontSize1: 14.0,
        fontWeight1: FontWeight.w500,
        onTap1: () {
          yyDialog.dismiss();
        },
        text2: "OK",
        color2: ColorApp.blue,
        fontSize2: 12.0,
        fontWeight2: FontWeight.w500,
        onTap2: () {
          yyDialog.dismiss();
        },
      )
      ..show();
  }

  static String encodeBase64(String str){
    var Bcodec = Base64Codec();
    var Lcodec = Latin1Codec();
    var bytes = Lcodec.encode(str);
    return Bcodec.encode(bytes);
  }

  static String decodeBase64(String str){
    var Bcodec = Base64Codec();
    var Lcodec = Latin1Codec();
    var bytes = Bcodec.decode(str);
    return Lcodec.decode(bytes);
  }

}