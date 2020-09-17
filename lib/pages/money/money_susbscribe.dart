
import 'package:flutter/material.dart';
import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/change_secret_form_bloc.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/blocs/login/login_state.dart';
import 'package:gui/blocs/login/subscribe_form_bloc.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/pages/activation/activation.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/money_standard_app_bar.dart';
import 'package:intl/intl.dart';

class MoneySubscribePage extends StatefulWidget {

  MoneySubscribePage({Key key, @required this.service}): super(key: key);

  final String service;

  @override
  _MoneySubscribeState createState() => _MoneySubscribeState();
}

class _MoneySubscribeState extends State<MoneySubscribePage> with MoneyStandardAppBar{

  List<NFDetailsInfo> _typespieces = [
    NFDetailsInfo(label: 'PS', value: 'PASSPORT'),
    NFDetailsInfo(label: 'CI', value: 'CARTE DINDENTITE NATIONALE'),
    NFDetailsInfo(label: 'PC', value: 'PERMIS DE CONDUIRE'),
    NFDetailsInfo(label: 'CE', value: 'CARTE ETUDIANT'),
    NFDetailsInfo(label: 'AU', value: 'AUTRES'),
  ];

  List<NFDetailsInfo> _sexe = [
    NFDetailsInfo(label: 'M', value: 'MASCULIN'),
    NFDetailsInfo(label: 'F', value: 'FEMININ'),
  ];

  List<NFDetailsInfo> _paysList = [
    NFDetailsInfo(label: '0CM', value: 'CAMEROUN'),
    NFDetailsInfo(label: '0CF', value: 'CENTRAFRIQUE'),
    NFDetailsInfo(label: '0CG', value: 'CONGO (BRAZZAVILLE)'),
    NFDetailsInfo(label: '0GA', value: 'GABON'),
    NFDetailsInfo(label: '0GQ', value: 'GUINEE EQUATORIALE'),
    NFDetailsInfo(label: '0TD', value: 'TCHAD'),
  ];

  TextEditingController _prenomController;
  TextEditingController _nomController;
  TextEditingController _dateNaissanceController;
  TextEditingController _lieuNaissanceController;
  TextEditingController _emailController;
  TextEditingController _nropieceController;
  TextEditingController _mobileController;
  TextEditingController _questionController;
  TextEditingController _reponseController;
  TextEditingController _secretController;
  ChangeSecretFormBloc _changeSecretFormBloc;
  SubscribeFormBloc _subscribeFormBloc;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  String _paysval;
  String _typepieceVal;
  String _sexeVal;
  String _value = '';
  String _valueDate = '';

  GlobalKey globalKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _prenomController = TextEditingController();
    _nomController = TextEditingController();
    _dateNaissanceController = TextEditingController();
    _lieuNaissanceController = TextEditingController();
    _emailController = TextEditingController();
    _nropieceController = TextEditingController();
    _mobileController = TextEditingController();
    _reponseController = TextEditingController();
    _questionController = TextEditingController();
    _secretController = TextEditingController();
    _changeSecretFormBloc = ChangeSecretFormBloc();
    _subscribeFormBloc = SubscribeFormBloc();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc= LoginBloc(authenticationBloc: _authenticationBloc);
    super.initState();
  }

  @override
  void dispose() {
    _changeSecretFormBloc?.dispose();
    _loginBloc?.dispose();
    _prenomController?.dispose();
    _nomController?.dispose();
    _dateNaissanceController?.dispose();
    _emailController?.dispose();
    _nropieceController?.dispose();
    _mobileController?.dispose();
    _reponseController?.dispose();
    _questionController?.dispose();
    _secretController?.dispose();
    _changeSecretFormBloc?.dispose();
    _subscribeFormBloc?.dispose();
    super.dispose();
  }

  Future _selectDate() async {
    _value = "";
    final f = new DateFormat('dd-MM-yyyy');

    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime(2030));
    if (picked != null)
      setState(() => _valueDate = f.format(picked).toString());
    //else setState(() => _value = "DATE OU HEURE INVALIDE");
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
                      stream: _subscribeFormBloc.prenom,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Prenom",),
                            controller: _prenomController,
                            keyboardType: TextInputType.text,
                            validator: (val) => val.length<1 ? 'PRENOM INVALIDE' : null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.nom,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "Nom",),
                            controller: _nomController,
                            keyboardType: TextInputType.text,
                            validator: (val) => val.length<1 ? 'NOM INVALIDE' : null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.sexe,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container (
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'SEXE',
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.green,
                              ),
                              border: InputBorder.none,
                            ),
                            child: new DropdownButton<String>(
                                hint: Text('Choisir un sexe'),
                                onChanged: (String changedValue) {
                                  _sexeVal=changedValue;
                                  setState(() {
                                    _sexeVal;
                                    print(_sexeVal);
                                  });
                                },
                                value: _sexeVal,
                                items: _sexe.map((operateur) {
                                  return new DropdownMenuItem<String>(
                                    value: operateur.label,
//                                  child: new Text(operateur.value),
                                    child:  new SizedBox(
                                        width: MediaQuery.of(context).size.width-105,
                                        child: new Text(operateur.value)
                                    ),
                                  );
                                }).toList()),
                          ),
                          padding: EdgeInsets.only(bottom: 5.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.date,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: new Container(
                            child: new Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        new Text(
                                          _valueDate,
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                        new RaisedButton(
                                          onPressed: _selectDate,
                                          child: new Text(
                                            'DATE DE NAISSANCE',
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                new Text(
                                  _value,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 10.0),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.lieu,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "LIEU DE NAISSANCE",),
                            controller: _lieuNaissanceController,
                            keyboardType: TextInputType.text,
                            validator: (val) => val.length<1 ? 'LIEU DE NAISSANCE INVALIDE' : null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.lieu,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "EMAIL",),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val.length<1 ? 'EMAIL INVALIDE' : null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.lieu,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container (
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'TYPE PIECE',
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.green,
                              ),
                              border: InputBorder.none,
                            ),
                            child: new DropdownButton<String>(
                                hint: Text('Choisir un TYPE PIECE'),
                                onChanged: (String changedValue) {
                                  _typepieceVal=changedValue;
                                  setState(() {
                                    _typepieceVal;
                                    print(_typepieceVal);
                                  });
                                },
                                value: _typepieceVal,
                                items: _typespieces.map((operateur) {
                                  return new DropdownMenuItem<String>(
                                    value: operateur.label,
//                                  child: new Text(operateur.value),
                                    child:  new SizedBox(
                                        width: MediaQuery.of(context).size.width-105,
                                        child: new Text(operateur.value)
                                    ),
                                  );
                                }).toList()),
                          ),
                          padding: EdgeInsets.only(bottom: 5.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.lieu,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "NUMERO PIECE",),
                            controller: _nropieceController,
                            keyboardType: TextInputType.text,
                            validator: (val) => val.length<1 ? 'NUMERO PIECE INVALIDE' : null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.pays,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container (
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'PAYS',
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.green,
                              ),
                              border: InputBorder.none,
                            ),
//                            child: new DropdownButtonHideUnderline(
//                              child: new DropdownButton<String>(
//                                value: _val,
//                                isDense: true,
//                                onChanged: (value) {
//                                  setState(() {
//                                    _val = value;
//                                  });
//                                  _bgfiExpressFormBloc.onPaysChanged(value);
//                                },
//                                items: _paysList.map((NFDetailsInfo pays) {
//                                  return new DropdownMenuItem<String>(
//                                    value: pays.label,
//                                    child: new Text(pays.value),
//                                  );
//                                }).toList(),
//                              ),
//                            ),
                            child: new DropdownButton<String>(
                                hint: Text('Choisir un pays'),
                                onChanged: (String changedValue) {
                                  _paysval=changedValue;
                                  setState(() {
                                    _paysval;
                                    print(_paysval);
                                  });
                                },
                                value: _paysval,
                                items: _paysList.map((pays) {
                                  return new DropdownMenuItem<String>(
                                    value: pays.label,
//                                  child: new Text(operateur.value),
                                    child:  new SizedBox(
                                        width: MediaQuery.of(context).size.width-105,
                                        child: new Text(pays.value)
                                    ),
                                  );
                                }).toList()),
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.lieu,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "NUMERO TELEPHONE",
                              fillColor: ColorApp.green,
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                              prefixText: "237",
                            ),
                            controller: _mobileController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val.length!=9 ? 'MOBILE INVALIDE' : null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.question,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "QUESTION SECRETE",),
                            controller: _questionController,
                            keyboardType: TextInputType.text,
                            validator: (val) => val.length<1 ? 'QUESTION SECRETE INVALIDE' : null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.reponse,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "REPONSE SECRETE",),
                            controller: _reponseController,
                            keyboardType: TextInputType.text,
                            validator: (val) => val.length<1 ? 'REPONSE SECRETE INVALIDE' : null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _subscribeFormBloc.numeropiece,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "CODE SECRET",),
                            controller: _secretController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val.length!=4 ? 'CODE SECRET INVALIDE' : null,
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
                                          print(form.validate());
                                          _loginBloc.emitEvent(LoginEvent(
                                              event: LoginEventType.subscribe,
                                              datenaissance: _valueDate,
                                              lieunaissance: _lieuNaissanceController.text,
                                              secret: _secretController.text,
                                              mobile: _mobileController.text,
                                              prenom: _prenomController.text,
                                              nom: _nomController.text,
                                              email: _emailController.text,
                                              reponse: _reponseController.text,
                                              question: _questionController.text,
                                              numeropiece: _nropieceController.text,
                                              typepiece: _typepieceVal,
                                              sexe: _sexeVal,
                                              pays: _paysval,
                                              service: widget.service));
                                        }else{
                                          print(form.validate());
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
            Utils.redirectToPage(context, ActivationPage(service: widget.service,));
          }
          if(state.isFailure) {
            Navigator.pop(context);
            Utils.dialog(context, state.errorMessage, 'Erreur', true);
          }
          return new Scaffold(
            appBar: appBar(
                context, Config.serviceMBanking, _loginBloc, "INSCRIPTION"),
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
