import 'package:flutter/material.dart';
import 'package:gui/navigation/slide_right_transition.dart';
import 'package:gui/pages/banking/change_banking_secret.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/widgets/banking_standard_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class BankingSettingsPage extends StatefulWidget {
  @override
  _BankingSettingsPageState createState() => _BankingSettingsPageState();
}

class _BankingSettingsPageState extends State<BankingSettingsPage> with BankingStandardAppBar {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Paramètres"),
        ),
        body: new Container(
          padding: new EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: const Card(child: Text('Mobile Banking')),
              ),
              Divider(),
              new InkWell(
                child: new Text("Changer code secret", style : new TextStyle(color: ColorApp.darkblue,fontWeight: FontWeight.normal,fontSize:20.0)),
                onTap: () {
                  print("SERVICE  : "+Config.serviceMBanking);
                  Navigator.push(context, SlideRightRoute(widget: ChangeSecretPage(service: Config.serviceMBanking)));
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
