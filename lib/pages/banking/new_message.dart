import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/messagerie/messagerie_bloc.dart';
import 'package:gui/blocs/messagerie/messagerie_form_bloc.dart';
import 'package:gui/blocs/messagerie/messagerie_state.dart';
import 'package:gui/blocs/messagerie/messagerie_event.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/banking_app_bar.dart';

class NewMessagePage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessagePage> with BankingAppBar {
  MessagerieBloc _newMessageBloc;

  MessagerieFormBloc _newMessageFormBloc;

  LoginBloc _loginBloc;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Compte> comptes;

  Compte compte;
  String libelleCompte;

  Color colorCompte;
  bool load = false;

  TextEditingController _objetController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComptes();
    _newMessageBloc = MessagerieBloc();
    _newMessageFormBloc = MessagerieFormBloc();
  }

  @override
  void dispose() {
    _objetController?.dispose();
    _messageController?.dispose();
    _newMessageFormBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget form() {
      return Form(
        key: formKey,
        child: Theme(
            data: theme.copyWith(
              primaryColor: ColorApp.blue,
              hintColor: ColorApp.blue,
              highlightColor: ColorApp.blue,
              accentColor: Colors.black,
              primaryColorDark: ColorApp.blue,
              cursorColor: ColorApp.blue,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<String>(
                      stream: _newMessageFormBloc.objet,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'COMPTE',
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.blue,
                              ),
                            ),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                hint: Text("Choisir un compte",
                                    style: TextStyle(color: colorCompte)),
                                value: libelleCompte,
                                isDense: true,
                                //onChanged: _newMessageFormBloc.onObjetChanged,
                                onChanged: (String changedValue) {
                                  setState(() {
                                    libelleCompte = changedValue;
                                    print(libelleCompte);
                                    compte = comptes.firstWhere((compte) =>
                                        compte.libelleCompte
                                            .compareTo(libelleCompte) ==
                                        0);
                                  });
                                },
                                items: comptes?.map((compte) {
                                  //this.compte = compte;
                                  //this.nroCompte = compte.numeroCompte;
                                  return new DropdownMenuItem<String>(
                                    value: compte.libelleCompte,
                                    child: new Text(compte.libelleCompte),
                                  );
                                })?.toList(),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _newMessageFormBloc.objet,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "OBJET"),
                            controller: _objetController,
                            validator: (val) =>
                                val.length < 1 ? "SAISIR L'OBJET" : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _newMessageFormBloc.message,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration:
                                new InputDecoration(labelText: "MESSAGE"),
                            controller: _messageController,
                            validator: (val) =>
                                val.length < 1 ? "SAISIR LE MESSAGE" : null,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<bool>(
                      stream: _newMessageFormBloc.submitValidation,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return StreamBuilder<String>(
                            stream: _newMessageFormBloc.message,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapsCarrier) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new RaisedButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 30.0),
                                      textColor: Colors.white,
                                      color: ColorApp.blue,
                                      disabledColor: ColorApp.darkblue,
                                      disabledTextColor: Colors.white,
                                      onPressed:(load == false)
                                          ? () {
                                        final form = formKey.currentState;
                                        if (libelleCompte == null) {
                                          setState(() {
                                            colorCompte = Colors.redAccent;
                                          });
                                        }
                                        if (form.validate() &&
                                            libelleCompte != null) {
                                          form.save();
                                          _confirmMessage();
                                        }
                                      }
                                      : null,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      child: new Text("VALIDER"),
                                    )
                                  ]);
                            });
                      }),
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
                ],
              ),
            )),
      );
    }

    return BlocEventStateBuilder<MessagerieState>(
      bloc: _newMessageBloc,
      builder: (BuildContext context, MessagerieState state) {
        if (state is MessagerieInitialized) {
          load = true;
        }
        if (state is MessagerieError) {
          load = false;
          Utils.dialog(context, state.error, 'ERREUR', false);
        }
        if (state is MessagerieSuccess) {
          Utils.onWidgetDidBuild(() {
            _objetController.text = '';
            _messageController.text = '';
          });
          load = false;
          Utils.dialog(context, state.success, 'Messagerie', false);
        }
        return new Scaffold(
          appBar: appBar(
              context, Config.serviceMBanking, _loginBloc, "Ecrire un message"),
          backgroundColor: ColorApp.background,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(child: form()),
              )
            ],
            shrinkWrap: true,
          ),
        );
      },
    );
  }

  void getComptes() async {
    DatabaseClient().allComptes().then((items) {
      setState(() {
        this.comptes = items;
      });
    });
  }

  void _confirmMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Confirmation du message"),
            content: new Container(
                width: MediaQuery.of(context).size.width - 100.0,
                height: MediaQuery.of(context).size.height / 3,
                child: ListView(children: <Widget>[Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            'Compte :',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              compte.libelleCompte,
                              style: TextStyle(fontSize: 15.0),
                              textAlign: TextAlign.right,
                              minFontSize: 12.0,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            'Agence :',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              compte.agence,
                              style: TextStyle(fontSize: 15.0),
                              textAlign: TextAlign.right,
                              minFontSize: 12.0,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            'Objet :',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              _objetController.text,
                              style: TextStyle(fontSize: 15.0),
                              textAlign: TextAlign.right,
                              minFontSize: 12.0,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),),
                )
                ], shrinkWrap: true,)
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text(
                    "ANNULER",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              new FlatButton(
                  child: new Text("VALIDER"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _newMessageBloc.emitEvent(Post(
                      compte: compte.numeroCompte,
                      agence: compte.agence,
                      objet: _objetController.text,
                      message: _messageController.text,
                    ));
                  }),
            ],
          );
        });
  }
}
