import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/splash/splash_bloc.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/pages/activation/activation.dart';
import 'package:gui/pages/banking/banking_settings.dart';
import 'package:gui/pages/banking/menuMB.dart';
import 'package:gui/pages/home.dart';
import 'package:gui/pages/intro.dart';
import 'package:gui/pages/login/login.dart';
import 'package:gui/pages/money/menu.dart';
import 'package:gui/pages/money/money_settings.dart';
import 'package:gui/pages/welcome.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';

void main() async {
  InjectorApp.configure(FLAVOR.MOCK);


//  await SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown
//  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      bloc: SplashBloc(),
      child: BlocProvider<AuthenticationBloc>(
        bloc: AuthenticationBloc(),
        child: MaterialApp(
          title: 'BGFIMobile',
          theme: ThemeData(
              primaryColor: ColorApp.blue,
              backgroundColor: ColorApp.bg,
              accentColor: Colors.redAccent,
              hintColor: ColorApp.blue,
              highlightColor: ColorApp.blue,
              buttonColor: ColorApp.blue,
              primaryColorDark: ColorApp.blue,
              inputDecorationTheme:new InputDecorationTheme(
                labelStyle:  new TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
          home: Welcome(),
          routes:  <String, WidgetBuilder> {
            "/welcome": (BuildContext context) => new Welcome(),
            "/intro": (BuildContext context) => new IntroPage(),
            "/home": (BuildContext context) => new HomePage(),
            "/loginmoney": (BuildContext context) => new LoginPage(service: 'money'),
            "/loginbanking": (BuildContext context) => new LoginPage(service: 'banking'),
            "/activationbanking": (BuildContext context) => new ActivationPage(service: 'banking'),
            "/activationmoney": (BuildContext context) => new ActivationPage(service: 'money'),
            "/menumoney": (BuildContext context) => new MenuMMPage(""),
            "/menubanking": (BuildContext context) => new MenuMBPage(),
//            "/bankingsettings": (BuildContext context) => new BankingSettingsPage(),
//            "/moneysettings": (BuildContext context) => new MoneySettingsPage(),
          },
          debugShowCheckedModeBanner: false,
        ),
      )
    );

  }
}