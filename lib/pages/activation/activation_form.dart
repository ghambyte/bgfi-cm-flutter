
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/blocs/login/login_form_bloc.dart';
import 'package:gui/blocs/login/login_state.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/pages/activation/activation.dart';
import 'package:gui/pages/banking/menuMB.dart';
import 'package:gui/pages/money/menu.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';

class ActivationFormPage extends StatefulWidget {

  ActivationFormPage({ @required this.service});

  final String service;

  @override
  _ActivationFormPageState createState() => _ActivationFormPageState();
}

class _ActivationFormPageState extends State<ActivationFormPage>{

  TextEditingController _activationController;
  LoginFormBloc _loginFormBloc;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  bool load = false;

  @override
  void initState() {
    _activationController = TextEditingController();
    _loginFormBloc = LoginFormBloc();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc= LoginBloc(authenticationBloc: _authenticationBloc);
    super.initState();
  }

  @override
  void dispose() {
    _loginFormBloc?.dispose();
    _loginBloc?.dispose();
    _activationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget _buildForm() {

      final theme = Theme.of(context);

      double width = MediaQuery.of(context).size.width;
      double heightScreen = MediaQuery.of(context).size.height;


      double formWidth = width * 0.82;
      double formHeight = heightScreen*4/6;

      return Form(
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
                      child:  Text('Activation',
                        style: TextStyle(
                          fontWeight: FontWeight.normal, // light
                          fontSize: 20.0,
                          color:widget.service=='banking'?ColorApp.green:ColorApp.darkblue,
                        ),
                      )
                  ),
                  StreamBuilder<String>(
                      stream: _loginFormBloc.activation,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container (
                          child: new TextField(
                            decoration: new InputDecoration(labelText: "CODE D'ACTIVATION",
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            controller: _activationController,
                            onChanged: _loginFormBloc.onActivationChanged,
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
                      stream: _loginFormBloc.registerValidActivation,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return Container(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            child: new RaisedButton(
                              padding: const EdgeInsets.all(50.0),
                              textColor: widget.service=='banking'?ColorApp.blue:ColorApp.white,
                              color: widget.service=='banking'?ColorApp.green:ColorApp.blue,
                              onPressed:(snapshot.hasData && snapshot.data == true && load == false)
                                  ?() {
                                    // Utils.showDialogProgress(context, 'Connexion en cours ....');
                                    _loginBloc.emitEvent(LoginEvent(
                                        event: LoginEventType.activation,
                                        activation: int.parse(_activationController.text),
                                        service: widget.service));
                                  }
                                  : null,
                              shape: new CircleBorder(),
                              child: new Text("ACTIVATION >",
                                  style : new TextStyle(
                                      fontSize: 10.0)
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  Container()
                ],
              ),
            ),
          ),
        ),
      );
    }
    return BlocEventStateBuilder<LoginState>(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          if(state.isBusy) {
            load = true;
//            Utils.showDialogProgress(context, 'Connexion en cours');
          }
          if(state.isSuccess) {
//            Utils.saveMoneyState(true);
            load = false;
            if(widget.service=='banking'){
              Utils.redirectToPage(context, MenuMBPage());
            }else{
              getLogin();
            }
          }
          if(state.isFailure) {
            load = false;
            Fluttertoast.showToast(
                msg: state.errorMessage,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 5,
                backgroundColor: Colors.white,
                textColor: Colors.red,
                fontSize: 16.0
            );
            print('ERREUR');
//            Utils.redirectToPage(context, ActivationPage(service: widget.service,));
//            Utils.dialog(context, 'Code incorrect', 'Erreur', true);
          }
          return _buildForm();
        }
    );
  }

  getLogin() async{
    await Utils.getLogin(Config.serviceMMoney).then((login){
      if(login != null){
        Utils.redirectToPage(context, MenuMMPage(login));
      }
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le login n'existe pas !", reponse: null)));
  }
}
