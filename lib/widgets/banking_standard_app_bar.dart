
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

abstract class BankingStandardAppBar {

  Widget appBar(BuildContext context, String service, LoginBloc loginBloc, String title, {bool sousTitle: false, bool tab: false}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(sousTitle?140.0:70.0),
      child: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, false),
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
      ),
    );
  }
}
