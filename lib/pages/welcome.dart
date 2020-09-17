import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/splash/splash_bloc.dart';
import 'package:gui/blocs/splash/splash_event.dart';
import 'package:gui/blocs/splash/splash_state.dart';


class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => new _WelcomeState();
}

class _WelcomeState extends State<Welcome>{
  SplashBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<SplashBloc>(context);
    _bloc.emitEvent(SplashEventLogin(name: 'get'));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocEventStateBuilder<SplashState>(
      bloc: _bloc,
      builder: (BuildContext context, SplashState state) {
        Timer(Duration(seconds: 4), (){
          if(state.isInit) {
            Navigator.pushReplacementNamed(context,"/home");
          }
          if(state.notInit) {
            Navigator.pushReplacementNamed(context,"/intro");
          }
        });

        return new Scaffold(
            body: new Center(
              child: new Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("images/splash.png"),
                      fit: BoxFit.cover,
                    ),
                  )
              ),
            )
        );
      }
    );
  }


}