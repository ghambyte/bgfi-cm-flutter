import 'package:flutter/material.dart';
import 'package:gui/pages/login/login_form.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key key, @required this.service}): super(key: key);

  final String service;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _homeScaffoldKey = new GlobalKey<ScaffoldState>();



    double homeBtnWidth = width /4;
    double tbHeight = heightScreen/6;




    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Center(
        child: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: widget.service=='banking'?new AssetImage("images/f.jpg"):new AssetImage("images/f3.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                child:Container(
                  height: tbHeight,
                  alignment: widget.service=='banking'?Alignment.bottomLeft:Alignment.bottomRight,
                  child: new Image.asset(
                    widget.service=='banking'?'images/icon-home.png':'images/iconhome2.png',
                    width: homeBtnWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              new LoginFormPage(service: widget.service)

            ],
          ),
        ),
      ),
    );
  }
}
