
import 'package:flutter/material.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/models/choice.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/navigation/slide_right_transition.dart';
import 'package:gui/pages/banking/banking_settings.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';

abstract class BankingAppBar {

  Widget appBar(BuildContext context, String service, LoginBloc loginBloc, String title, {bool sousTitle: false, bool tab: false}) {
    void _select(Choice choice) {
      if(choice.title == 'Paramètres'){
        Navigator.push(context, SlideRightRoute(widget: BankingSettingsPage()));
      }else if(choice.title == 'Se déconnecter'){
        alertDialog(context, "Vous souhaitez vous déconnecter?", "Déconnexion", loginBloc, service, true);
      }
    }
    return PreferredSize(
      preferredSize: Size.fromHeight(sousTitle?140.0:70.0),
      child: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pushReplacementNamed(context, '/home'),
        ),
        backgroundColor: ColorApp.blue,
        elevation: 0.0,
        title: Center(child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: service == Config.serviceMBanking ? Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),) : Text("Mobile Money", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
        ),),
        flexibleSpace:  new Stack(
          fit: StackFit.expand,

        ),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
//        actions: <Widget>[
//          GestureDetector(
//            child: Padding(
//              padding: const EdgeInsets.only(right: 5.0),
//              child: Container(
//                width: 25.0,
//                child: Center(child: Image.asset('images/mb-icon.png', fit: BoxFit.contain,)),
//              ),
//            ),
//            onTap: (){
//              alertDialog(context, "Vous souhaitez vous déconnecter?", "Déconnexion", loginBloc, service, true);
//            },
//
//          ),
//        ],
        //automaticallyImplyLeading: false,
      ),
    );
  }

  void alertDialog(BuildContext context,  String message, String title, LoginBloc loginBloc, String service, bool dismiss){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: <Widget>[

              FlatButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Non', style: TextStyle(color: Colors.black.withOpacity(0.6)),),),

              FlatButton(onPressed: (){
                // ignore: unnecessary_statements
                service == 'banking'?{
                  loginBloc.emitEvent(
                      LoginEvent(
                          event: LoginEventType.disconnect,
                          service: service)
                  )
                // ignore: unnecessary_statements
                }:{
                  loginBloc.emitEvent(
                      LoginEvent(
                      event: LoginEventType.disconnect,
                      service: service)
                  ),
                };
              }, child: Text('Oui')),
            ],
          );
        },
        barrierDismissible: dismiss
    );
  }

  void deleteCompte() async{
    DatabaseClient().delete().then((val){
      print('Database deleted ###');
    });
  }
}
