
import 'package:flutter/material.dart';
import 'package:gui/pages/activation/activation_form.dart';

class ActivationPage extends StatefulWidget {

  ActivationPage({ @required this.service});

  final String service;

  @override
  _ActivationPageState createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

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
              new ActivationFormPage(service: widget.service,)

            ],
          ),
        ),
      ),
    );
  }

}
