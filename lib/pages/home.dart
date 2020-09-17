import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/authentication/authentication_event.dart';
import 'package:gui/blocs/authentication/authentication_state.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/blocs/security_bloc.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/navigation/slide_right_transition.dart';
import 'package:gui/pages/banking/menuMB.dart';
import 'package:gui/pages/login/login.dart';
import 'package:gui/pages/money/menu.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  SecurityBloc securityBloc = SecurityBloc();
  String _login;
  bool click = false;
  bool load = false;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc= LoginBloc(authenticationBloc: _authenticationBloc);
    _authenticationBloc.emitEvent(AppStarted());
    _loginBloc.emitEvent(LoginEvent(event: LoginEventType.token,));
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    double heightImage = heightScreen * 0.40;
    double heightOptionBtn = heightImage * 0.33;
    double heightStarBtn = heightImage * 0.16;
    double heightSpace = heightImage * 0.09;
    double heightSideSpace = heightScreen * 0.30;
    double heightSideBtn = heightImage * 0.10;
    double heightLogoBtn = heightImage * 0.20;
    double widthLogoBtn = heightLogoBtn * 2;
    double textWidth = width/3;

    double heightTrans = 55.0;
    double divPi = 4;


    Widget itemScale(int position, String image) {
      return Transform.translate(
        offset: Offset(heightTrans * cos(position * pi/divPi), heightTrans * sin(position * pi/divPi)),
        child: Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: new Image.asset(
            image,
            width: heightSideBtn,
            height: heightSideBtn,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    Widget _buildForm(AuthenticationState state) {
      return Center (
        child : Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/f1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child : Column (

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child : new Image.asset(
                    'images/logo1.png',
                    fit: BoxFit.contain,
                  ),
                  height: 50,
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: load,
                  child: SpinKitThreeBounce(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? ColorApp.blue : ColorApp.green,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("images/ficon1.png"),
                        fit: BoxFit.fitHeight,
                      )
                  ),
                  height: heightImage,
                  child: Column(
                    children: <Widget>[

                      GestureDetector(
                          onTap: (load == false)
                              ?() async{
                            setState(() {
                              load = true;
                            });
                            await securityBloc.getStatus(Config.serviceMBanking).then((status){
                              if(status){
                                load = false;
                                Navigator.push(context, SlideRightRoute(widget: MenuMBPage()));
                              }else{
                                load = false;
                                Navigator.push(context, SlideRightRoute(widget: LoginPage(service: Config.serviceMBanking)));
                              }
                            });
                          } : null,
                          child:
                          Row (
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: textWidth,
                              ),
                              new Image.asset(
                                'images/iconmb.png',
                                width: heightOptionBtn,
                                height: heightOptionBtn,
                                fit: BoxFit.cover,
                              ),
                              Container (
                                  width: textWidth,
                                  child: Text(
                                    'Mobile Banking',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300, // light
                                      color:ColorApp.green,
                                    ),
                                  )
                              )
                            ],
                          )
                      ),
                      Container(
                        height: heightSpace,
                      ),
                      Stack(
                        children: <Widget>[
                          GestureDetector(
                            child: new Image.asset(
                              'images/iconplus.png',
                              width: heightStarBtn,
                              height: heightStarBtn,
                              fit: BoxFit.cover,
                            ),
                            onTap: (){
                              setState(() {
//                                click = !click;
                              });
                            },
                          ),
                          click?Stack(
                            children: <Widget>[
                              itemScale(3, 'images/icon-info.png'),
                              itemScale(4, 'images/iconfaq.png'),
                              itemScale(5, 'images/icondemo.png'),
                            ],
                          ):Text(''),
                        ],
                      ),
                      Container(
                        height: heightSpace,
                      ),
                      GestureDetector(
                        onTap: (load == false)
                            ?() async {
                          setState(() {
                            load = true;
                          });
                          await securityBloc.getStatus(Config.serviceMMoney).then((status){
                            if(status){
                              load = false;
                              getLoginMoney();
                            }else{
                              load = false;
                              Navigator.push(context, SlideRightRoute(widget: LoginPage(service: Config.serviceMMoney)));
                            }
                          });
                        } : null,
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container (
                                width: textWidth,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Mobile Money',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300, // light
                                    color:ColorApp.green,
                                  ),
                                )
                            ),
                            new Image.asset(
                              'images/iconmm.png',
                              width: heightOptionBtn,
                              height: heightOptionBtn,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: textWidth,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child : Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Image.asset(
                          'images/iconserviceclient.png',
                          width: heightStarBtn,
                          height: heightStarBtn,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    height: heightSideSpace,
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),
                  onTap: () {
                    launch("tel://8888");
                  },
                ),
              ]
          ),
        ),
      );
    }

    return BlocEventStateBuilder<AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (BuildContext context, AuthenticationState state) {
        return new Scaffold(
          body: _buildForm(state),
        );
      },
    );

  }

  @override
  void dispose() {
    _loginBloc?.dispose();
    super.dispose();
  }

  Future getLoginMoney() async {
    await Utils.getLogin(Config.serviceMMoney).then((login){
      if(login == null){
        Navigator.push(context, SlideRightRoute(widget: LoginPage(service: Config.serviceMMoney)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuMMPage(login),
            ));
      }
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le login n'existe pas!", reponse: null)));
  }
}
