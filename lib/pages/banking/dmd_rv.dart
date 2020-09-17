import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gui/blocs/dmd_rv/dmd_rv_event.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/dmd_rv/dmd_rv_bloc.dart';
import 'package:gui/blocs/dmd_rv/dmd_rv_form_bloc.dart';
import 'package:gui/blocs/dmd_rv/dmd_rv_state.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';
import 'package:intl/intl.dart';

class DmdRvPage extends StatefulWidget {
  @override
  _DmdRvPageState createState() => _DmdRvPageState();
}

class _DmdRvPageState extends State<DmdRvPage> {
  String _value = '';

  String _valueDate = '';
  String _valueHeure = '';
  bool load = false;

  DmdRvBloc _dmdRvBloc;

  DmdRvFormBloc _dmdRvFormBloc;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NFDetailsInfo> operateurs = [
    NFDetailsInfo(label: 'GET', value: 'GETESA'),
    NFDetailsInfo(label: 'MUN', value: 'MUNI'),
  ];

  List<Compte> comptes;

  Compte compte;
  //String nroCompte;
  //String agence;
  String nroSelectedCompte;

  TextEditingController _secretController = TextEditingController();
  TextEditingController _objetController = TextEditingController();
  TextEditingController _compteController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComptes();
    //nroSelectedCompte = comptes[0].numeroCompte ;
    _dmdRvBloc = DmdRvBloc();
    _dmdRvFormBloc = DmdRvFormBloc();
  }

  @override
  void dispose() {
    _secretController?.dispose();
    _objetController?.dispose();
    _dmdRvFormBloc?.dispose();
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
                      stream: _dmdRvFormBloc.compte,
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
                                /*value: (comptes != null && comptes.isNotEmpty)
                                    ? comptes[0]?.numeroCompte
                                    : '',*/
                                value: nroSelectedCompte,
                                isDense: true,
                                //onChanged: _dmdRvFormBloc.onCompteChanged,
                                onChanged: (String changedValue) {
                                  setState(() {
                                    nroSelectedCompte = changedValue;
                                    _dmdRvFormBloc
                                        .onCompteChanged(nroSelectedCompte);
                                    print(nroSelectedCompte);
                                    compte = comptes.firstWhere( (compte) => compte.libelleCompte.startsWith(nroSelectedCompte));
                                  });
                                },
                                items: comptes?.map((compte) {
                                  /*this.compte = compte;
                                  this.currentCompte = compte ;
                                  this.nroCompte = compte.numeroCompte;
                                  this.agence = compte.agence;*/
                                  /*print("---------------------------------------");
                                  print("**** $nroCompte ****");
                                  print("**** $agence ****");
                                  print("----------------------------------------");*/
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
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Center(
                          child: Container(
                              child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            'Titulaire:',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              (compte != null) ? compte.titulaire : '',
                              style: TextStyle(fontSize: 15.0),
                              textAlign: TextAlign.right,
                              minFontSize: 12.0,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      )));
                    },
                  ),
                  Divider(),
                  StreamBuilder<String>(
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Center(
                          child: Container(
                              child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            'Agence:',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              (compte != null) ? compte.libelleAgence : '',
                              style: TextStyle(fontSize: 15.0),
                              textAlign: TextAlign.right,
                              minFontSize: 12.0,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      )));
                    },
                  ),
                  Divider(),
                  /*StreamBuilder<String>(
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Center(
                          child: Container(
                              child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            'Solde:',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              (compte != null) ? compte.solde : '',
                              style: TextStyle(fontSize: 15.0),
                              textAlign: TextAlign.right,
                              minFontSize: 12.0,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      )));
                    },
                  ),
                  Divider(),*/
                  StreamBuilder<String>(
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Center(
                          child: Container(
                              child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            'Gestionnaire:',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              (compte != null)
                                  ? compte.nomCompletGestionnaire
                                  : '',
                              style: TextStyle(fontSize: 15.0),
                              textAlign: TextAlign.right,
                              minFontSize: 12.0,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      )));
                    },
                  ),
                  Divider(),
                  StreamBuilder<String>(
                      stream: _dmdRvFormBloc.objet,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          /*child: TextField(
                            decoration: new InputDecoration(labelText: "OBJET"),
                            controller: _objetController,
                            onChanged: _dmdRvFormBloc.onObjetChanged,
                            keyboardType: TextInputType.text,
                          ),*/
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "OBJET",
                            ),
                            controller: _objetController,
                            validator: (val) =>
                                val.length < 1 ? "Saisir l'objet" : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _dmdRvFormBloc.date,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: new Center(
                            child: new Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        new Text(_valueDate),
                                        new RaisedButton(
                                          onPressed: _selectDate,
                                          child: new Text(
                                            'DATE',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        new Text(_valueHeure),
                                        new RaisedButton(
                                          onPressed: _selectHeure,
                                          child: new Text(
                                            'HEURE',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
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
                  StreamBuilder<bool>(
                      stream: _dmdRvFormBloc.submitValidation,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return StreamBuilder<String>(
                            stream: _dmdRvFormBloc.compte,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> compte) {
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
                                        if (form.validate()) {
                                          form.save();
                                          if (_valueDate != '' &&
                                              _valueHeure != '') {
                                            _confirmRV();
                                          } else
                                            setState(() => _value =
                                            "DATE OU HEURE INVALIDE");
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

    return BlocEventStateBuilder<DmdRvState>(
      bloc: _dmdRvBloc,
      builder: (BuildContext context, DmdRvState state) {
        if (state is DmdRvInitialized) {
          load = true;
        }
        if (state is DmdRvLoaded) {
          print('BABACAR------- ${state.nfConfirmResponse.idtransaction}');
        }
        if (state is DmdRvError) {
          load = false;
          Utils.dialog(context, state.error, 'ERREUR', false);
        }

        if (state is DmdRvSuccess) {
          Utils.onWidgetDidBuild(() {
            _objetController.text = '';
            _valueDate = '';
            _valueHeure = '';
          });
          load = false;
          Utils.dialog(context, state.success, 'DEMANDE RV', false);
        }
        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Center(child: form()),
            )
          ],
          shrinkWrap: true,
        );
      },
    );
  }

  void getComptes() async {
    DatabaseClient().allComptes().then((items) {
      setState(() {
        this.nroSelectedCompte= items[0].libelleCompte;
        this.compte = items[0];
        this.comptes = items;
      });
    });
  }

  Future _selectDate() async {
    _value = "";
    final f = new DateFormat('dd-MM-yyyy');

    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2030));
    if (picked != null)
      setState(() => _valueDate = f.format(picked).toString());
    //else setState(() => _value = "DATE OU HEURE INVALIDE");
  }

  Future _selectHeure() async {
    _value = "";

    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 00),
    );
    if (picked != null)
      setState(() => _valueHeure = picked.format(context)); //.toString());
    //else setState(() => _value = "DATE OU HEURE INVALIDE");
  }

  void _confirmRV() {
    
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Confirmation du RV"),
            content: new Container(
              width: MediaQuery.of(context).size.width - 100.0,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
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
                          (compte != null) ? compte.libelleCompte : '',
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.right,
                          minFontSize: 12.0,
                          maxLines: 2,
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
                          (compte != null) ? compte.libelleAgence : '',
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.right,
                          minFontSize: 12.0,
                          maxLines: 2,
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
                          maxLines: 2,
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
                        'Date :',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          _valueDate,
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.right,
                          minFontSize: 12.0,
                          maxLines: 2,
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
                        'Heure :',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          _valueHeure,
                          style: TextStyle(fontSize: 15.0),
                          textAlign: TextAlign.right,
                          minFontSize: 12.0,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("ANNULER"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              new FlatButton(
                  child: new Text("Valider"),
                  onPressed: () {
                    Navigator.of(context).pop();

                    _dmdRvBloc.emitEvent(Post(
                        //secret: _secretController.text,
                        compte: compte.numeroCompte, //nroCompte,
                        objet: _objetController.text,
                        date: _valueDate + " " + _valueHeure,
                        agence: compte.agence//agence,
                        ));
                    print("ACTION SUBMIT");
                    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                  }),
            ],
          );
        });
  }
}
