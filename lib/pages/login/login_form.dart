
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/blocs/login/login_form_bloc.dart';
import 'package:gui/blocs/login/login_state.dart';
import 'package:gui/pages/activation/activation.dart';
import 'package:gui/pages/login/login.dart';
import 'package:gui/pages/money/money_susbscribe.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';

class LoginFormPage extends StatefulWidget {

  LoginFormPage({Key key, @required this.service}): super(key: key);

  final String service;

  @override
  _LoginFormPageState createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage>{

  TextEditingController _mobileController;
  TextEditingController _passwordController;
  LoginFormBloc _loginFormBloc;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  bool load = false;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    _mobileController = TextEditingController();
    _passwordController = TextEditingController();
    _loginFormBloc = LoginFormBloc();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc= LoginBloc(authenticationBloc: _authenticationBloc);
    super.initState();
  }

  @override
  void dispose() {
    _loginFormBloc?.dispose();
    _loginBloc?.dispose();
    _mobileController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    double width = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;


    double formWidth = width * 0.82;
    double formHeight = heightScreen*4/6;

    Widget _buildForm() {


      return Stack(
        children: <Widget>[
          Form(
            child: Theme(
              data: theme.copyWith(
                primaryColor: widget.service=='banking'?ColorApp.darkblue:ColorApp.green,
                hintColor: widget.service=='banking'?ColorApp.darkblue:ColorApp.green,
                highlightColor: widget.service=='banking'?ColorApp.darkblue:ColorApp.green,
                accentColor: Colors.white,
                primaryColorDark: widget.service=='banking'?ColorApp.darkblue:ColorApp.green,
              ),
              child: Container(
                height: formHeight,
                alignment: widget.service=='banking'?Alignment.topRight:Alignment.topLeft,
                child: Container(
                  width: formWidth,
                  padding: EdgeInsets.only(top: 50.0,bottom: 50.0,left: 40.0,right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          alignment: widget.service=='banking'?Alignment.topRight:Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 20.0),
                          child:  Text('Connexion',
                            style: TextStyle(
                              fontWeight: FontWeight.normal, // light
                              fontSize: 20.0,
                              color:widget.service=='banking'?ColorApp.green:ColorApp.darkblue,
                            ),
                          )
                      ),
                      StreamBuilder<String>(
                        stream: widget.service=='banking'?_loginFormBloc.mobileMB:_loginFormBloc.mobileMM,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          return Container(
                            child: new TextField(
                              decoration: new InputDecoration(
                                labelText: widget.service=='banking'?"CODE CLIENT":"NUMERO TELEPHONE",
                                fillColor: widget.service=='banking'?ColorApp.darkblue:ColorApp.green,
                                labelStyle: new TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                prefixText: widget.service=='banking'?null:"237",
                              ),
                              style: TextStyle(color: Colors.white, fontSize: 15.0),
                              keyboardType: TextInputType.number,
                              controller: _mobileController,
                              onChanged: widget.service=='banking'?_loginFormBloc.onMobileMBChanged:_loginFormBloc.onMobileMMChanged,
                            ),
                          );
                        }
                      ),
                      StreamBuilder<String>(
                        stream: _loginFormBloc.password,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          return Container(
                            child: TextField(
                              decoration: new InputDecoration(
                                labelText: "CODE SECRET",
                                labelStyle: new TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              style: TextStyle(color: Colors.white, fontSize: 15.0),
                              controller: _passwordController,
                              onChanged: _loginFormBloc.onPasswordChanged,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                            ),
                          );
                        }
                      ),

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

                      StreamBuilder<bool>(
                        stream: widget.service=='banking'?_loginFormBloc.registerValidMB:_loginFormBloc.registerValidMM,
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          return Container(
                            alignment: Alignment.center,
                            child: new RaisedButton(
                              padding: widget.service=='banking'?const EdgeInsets.all(50.0):const EdgeInsets.all(30.0),
                              textColor: widget.service=='banking'?ColorApp.blue:ColorApp.blue,
                              color: widget.service=='banking'?ColorApp.green:ColorApp.green,
                              onPressed:(snapshot.hasData && snapshot.data == true && load == false)
                                  ? () {
                                      // Utils.showDialogProgress(context, 'Connexion en cours ....');
                                      _loginBloc.emitEvent(LoginEvent(
                                          event: LoginEventType.working,
                                          email: _mobileController.text,
                                          service: widget.service,
                                          password: _passwordController.text));
                                    }
                                  : null,
//                                  (){
//                                        if(snapshot.error == null){
//                                          Utils.aletreDialog(context, "Vous devez remplir tous les champs.", "ERREUR", true);
//                                        }else{
//                                          Utils.aletreDialog(context, snapshot.error, "ERREUR", true);
//                                        }
//                                        print(snapshot.error);
//                                      },
                              shape: new CircleBorder(),
                              child: new Text("CONNEXION >",
                                  style : new TextStyle(
                                      fontSize: 10.0)
                              ),
                            ),
                          );
                        }
                      ),
                      Visibility(
                        child: Container(
                          alignment: Alignment.center,
                          child: new FlatButton(
                            padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                            textColor: widget.service=='banking'?ColorApp.white:ColorApp.blue,
                            color: widget.service=='banking'?ColorApp.darkblue:ColorApp.green,
                            onPressed:(){
                              Utils.redirectToPage(context, MoneySubscribePage(service: widget.service,));
                            } ,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                            child: new Text("INSCRIPTION",
                                style : new TextStyle(
                                    fontSize: 10.0)
                            ),
                          ),
                        ),
                        visible: widget.service=='banking'?false:true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return BlocEventStateBuilder<LoginState>(
      bloc: _loginBloc,
      builder: (BuildContext context, LoginState state) {
        if(state.isBusy) {
          load = true;
//          Utils.showDialogProgress(context, 'Connexion en cours');
        }
        if(state.isSuccess) {
          load = false;
          Utils.redirectToPage(context, ActivationPage(service: widget.service,));
        }
        if(state.isFailure) {
          load = false;
//          print('ERREUR');
//          Utils.redirectToPage(context, LoginPage(service: widget.service,));
//          Utils.dialog(context, state.errorMessage, 'Erreur', true);
          Fluttertoast.showToast(
              msg: state.errorMessage,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 5,
              backgroundColor: Colors.white,
              textColor: Colors.red,
              fontSize: 16.0
          );
        }
        return _buildForm();
      }
    );

  }

}
