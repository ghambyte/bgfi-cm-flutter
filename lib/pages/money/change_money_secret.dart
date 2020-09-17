
import 'package:flutter/material.dart';
import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/change_secret_form_bloc.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/blocs/login/login_state.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/money_standard_app_bar.dart';

class ChangeSecretPage extends StatefulWidget {

  ChangeSecretPage({Key key, @required this.service}): super(key: key);

  final String service;

  @override
  _ChangeSecretState createState() => _ChangeSecretState();
}

class _ChangeSecretState extends State<ChangeSecretPage> with MoneyStandardAppBar{

  TextEditingController _passwordController;
  TextEditingController _nouveauSecretController;
  TextEditingController _confirmSecretController;
  ChangeSecretFormBloc _changeSecretFormBloc;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  GlobalKey globalKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _passwordController = TextEditingController();
    _nouveauSecretController = TextEditingController();
    _confirmSecretController = TextEditingController();
    _changeSecretFormBloc = ChangeSecretFormBloc();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc= LoginBloc(authenticationBloc: _authenticationBloc);
    super.initState();
  }

  @override
  void dispose() {
    _changeSecretFormBloc?.dispose();
    _loginBloc?.dispose();
    _passwordController?.dispose();
    _confirmSecretController?.dispose();
    _nouveauSecretController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    Widget _buildForm() {
      return Form(
        key: formKey,
        child: Theme(
            data: theme.copyWith(
              primaryColor: ColorApp.darkblue,
              hintColor: ColorApp.darkblue,
              highlightColor: ColorApp.darkblue,
              accentColor: Colors.black,
              primaryColorDark: ColorApp.darkblue,
              cursorColor: ColorApp.darkblue,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<String>(
                      stream: _changeSecretFormBloc.secret,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "CODE SECRET",),
                            controller: _passwordController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val.length!=4 ? 'CODE SECRET INVALIDE' : null,
                            obscureText: true,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _changeSecretFormBloc.secret,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "NOUVEAU SECRET",),
                            controller: _nouveauSecretController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val.length!=4 ? 'NOUVEAU SECRET INVALIDE' : null,
                            obscureText: true,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _changeSecretFormBloc.secret,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "CONFIRMATION SECRET",),
                            controller: _confirmSecretController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val.length!=4 ? 'CONFIRMATION SECRET INVALIDE' : null,
                            obscureText: true,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<bool>(
                      stream: _changeSecretFormBloc.submitValidation,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return StreamBuilder<String>(
                            stream: _changeSecretFormBloc.secret,
                            builder: (BuildContext context, AsyncSnapshot<String> mobile){
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new RaisedButton(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                                      textColor: Colors.white,
                                      color: ColorApp.darkGreen,
                                      disabledColor: ColorApp.darkGreen,
                                      disabledTextColor: Colors.white,
                                      onPressed: ((){
                                        final form = formKey.currentState;
                                        if (form.validate()) {
                                          form.save();
                                          _loginBloc.emitEvent(LoginEvent(
                                              event: LoginEventType.changeSecret,
                                              password: _passwordController.text,
                                              nouveauSecret: _nouveauSecretController.text,
                                              confirmSecret: _confirmSecretController.text,
                                              service: widget.service));
                                        }
                                      }),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(
                                              30.0)),
                                      child: new Text("VALIDER"),
                                    )
                                  ]
                              );
                            }
                        );

                      }
                  ),
                ],
              ),
            )
        ),
      );
    }

    return BlocEventStateBuilder<LoginState>(
      bloc: _loginBloc,
      builder: (BuildContext context, LoginState state) {
        if(state.isBusy) {
          Utils.showDialogProgress(context, 'Connexion en cours');
        }
        if(state.isSuccess) {
          Navigator.pop(context);
          _passwordController.text = '';
          _confirmSecretController.text = '';
          _nouveauSecretController.text = '';
          Utils.dialog(context, state.successMessage, 'Changement code secret', true);
        }
        if(state.isFailure) {
          Navigator.pop(context);
          Utils.dialog(context, state.errorMessage, 'Erreur', true);
        }
        return new Scaffold(
          appBar: appBar(
              context, Config.serviceMBanking, _loginBloc, "Changement code secret"),
          backgroundColor: ColorApp.background,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(child: _buildForm()),
              )
            ],
            shrinkWrap: true,
          ),
        );
      }
    );

  }

}
