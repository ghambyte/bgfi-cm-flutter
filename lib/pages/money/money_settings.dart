import 'package:flutter/material.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/navigation/slide_right_transition.dart';
import 'package:gui/pages/money/change_money_secret.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/widgets/money_standard_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class MoneySettingsPage extends StatefulWidget {

  @override
  _MoneySettingsPageState createState() => _MoneySettingsPageState();
}

class _MoneySettingsPageState extends State<MoneySettingsPage> with MoneyStandardAppBar {

  LoginBloc _loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  Future<bool> _onWillPop() async{
//    Navigator.push(context, SlideRightRoute(widget: MenuMMPage(widget.loginMoney)));
////    Navigator.pushReplacementNamed(context, '/menumoney');
//  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
//      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: appBar(context, Config.serviceMMoney, _loginBloc, "Mobile Money", sousTitle: false),
        body: new Container(
          padding: new EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: const Card(child: Text('Mobile Money')),
                ),
                Divider(),
                new InkWell(
                  child: new Text("Changer code secret", style : new TextStyle(color: ColorApp.darkblue,fontWeight: FontWeight.normal,fontSize:20.0)),
                  onTap: () {
                    Navigator.push(context, SlideRightRoute(widget: ChangeSecretPage(service: Config.serviceMMoney)));
                  },
                ),
                Divider(),
                new InkWell(
                  child: new Text("Code secret oublié? ", style : new TextStyle(color: ColorApp.darkblue,fontWeight: FontWeight.normal,fontSize:20.0)),
                  onTap: () {
                    launch("tel://8888");
                  },
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top:20.0, bottom: 10.0),
                  child: const Card(child: Text('A propos')),
                ),
                Divider(),
                new InkWell(
                  child: new Text("Règles d'utilisation", style : new TextStyle(color: ColorApp.darkblue,fontWeight: FontWeight.normal,fontSize:20.0)),
                  onTap: () {
                    _launchURL();
                  },
                ),
                Divider(),
//                new InkWell(
//                  child: new Text("Partager", style : new TextStyle(color: ColorApp.darkblue,fontWeight: FontWeight.normal,fontSize:20.0)),
//                  onTap: () {
//                    Share.share('https://example.com');
//                  },
//                ),
//                Divider(),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://www.chakamobile.com/files/bgfi/cameroun/conditions-dutilisation.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible !';
    }
  }
}
