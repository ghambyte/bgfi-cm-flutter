import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/cmd_chequier/cmd_chequier_bloc.dart';
import 'package:gui/blocs/cmd_chequier/cmd_chequier_form_bloc.dart';
import 'package:gui/blocs/cmd_chequier/cmd_chequier_state.dart';
import 'package:gui/blocs/cmd_chequier/cmd_chequier_event.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/models/typeChequier.dart';
import 'package:gui/models/volume_chequier.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';

class ChequierPage extends StatefulWidget {
  @override
  _ChequierPageState createState() => _ChequierPageState();
}

class _ChequierPageState extends State<ChequierPage> {
  CmdChequierBloc _cmdChequierBloc;

  CmdChequierFormBloc _cmdChequierFormBloc;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<VolumeChequier> volumes = [
    VolumeChequier(volume: '25'),
    VolumeChequier(volume: '50'),
  ];

  List<Compte> comptes;

  List<TypeChequier> typesChequiers;

  Compte compte;

  TypeChequier typeChequier;

  //String nroCompte;
  String nroSelectedCompte;

  //String typeChequier;
  String typeSelectedChequier;

  String volumeChequier;

  String _hintType = "Type de chéquier";
  Color _colorType;
  String _hintVolume = "Volume de chéquier";
  bool load = false;
  Color _colorVolume;

  @override
  void initState() {
    // TODO: implement initState
    //super.initState();
    //volumeChequier= volumes.first.volume ;
    getComptes();
    getTypesChequiers();
    _cmdChequierBloc = CmdChequierBloc();
    _cmdChequierFormBloc = CmdChequierFormBloc();
    super.initState();
  }

  @override
  void dispose() {
    _cmdChequierFormBloc?.dispose();
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
              accentColor: Colors.blue,
              primaryColorDark: ColorApp.blue,
              cursorColor: ColorApp.blue,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<String>(
                      stream: _cmdChequierFormBloc.compte,
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
                                //onChanged: _cmdChequierFormBloc.onCompteCheque,
                                onChanged: (String changedValue) {
                                  setState(() {
                                    nroSelectedCompte = changedValue;
                                    _cmdChequierFormBloc
                                        .onCompteCheque(nroSelectedCompte);
                                    print(nroSelectedCompte);
                                    compte = comptes.firstWhere((compte) =>
                                        compte.libelleCompte
                                            .compareTo(nroSelectedCompte) ==
                                        0);
                                  });
                                },
                                items: comptes?.map((compte) {
                                  /*this.compte = compte;
                                  this.nroCompte = compte.numeroCompte;*/
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
                      stream: _cmdChequierFormBloc.type,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              //labelText: 'TYPE CHEQUIER',
                              //helperText: null,
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.blue,
                              ),
                            ),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                /*value: (typesChequiers != null &&
                                        typesChequiers.isNotEmpty)
                                    ? typesChequiers[0]?.codeType
                                    : '',*/
                                hint: Text(
                                  _hintType,
                                  style: TextStyle(color: _colorType),
                                ),
                                value: typeSelectedChequier,
                                isDense: true,
                                //onChanged: _cmdChequierFormBloc.onCompteCheque,
                                onChanged: (String changedValue) {
                                  setState(() {
                                    typeSelectedChequier = changedValue;
                                    _cmdChequierFormBloc
                                        .onTypeCheque(typeSelectedChequier);
                                    print(
                                        "**** SELECTED TYPE CHEQUIER **** : $typeSelectedChequier");
                                  });
                                  typeChequier = typesChequiers.firstWhere(
                                      (typeChequier) =>
                                          typeChequier.codeType.compareTo(
                                              typeSelectedChequier) ==
                                          0);
                                },
                                items: typesChequiers?.map((type) {
                                  //this.typeChequier = type.codeType;
                                  return new DropdownMenuItem<String>(
                                    value: type.codeType,
                                    child: new Text(type.libelleType),
                                  );
                                })?.toList(),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _cmdChequierFormBloc.volume,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              //labelText: 'VOLUME CHEQUIER',
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.blue,
                              ),
                            ),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton(
                                hint: Text(
                                  _hintVolume,
                                  style: TextStyle(color: _colorVolume),
                                ),
                                value: volumeChequier,
                                isDense: true,
                                //onChanged: _dmdRvFormBloc.onCompteChanged,
                                onChanged: (String changedValue) {
                                  // = changedValue;
                                  setState(() {
                                    volumeChequier = changedValue;
                                    _cmdChequierFormBloc
                                        .onVolumeCheque(volumeChequier);
                                    print(volumeChequier);
                                  });
                                },
                                items: volumes.map((volume) {
                                  //this.volumeChequier = volume.volume;
                                  return new DropdownMenuItem<String>(
                                      value: volume.volume,
                                      //child: new Text(volume.volume),
                                      child: new SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              105,
                                          child: new Text(volume.volume)));
                                })?.toList(),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<bool>(
                      stream: _cmdChequierFormBloc.submitValidation,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return StreamBuilder<String>(
                            stream: _cmdChequierFormBloc.compte,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> volume) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new RaisedButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 30.0),
                                      textColor: Colors.white,
                                      color: ColorApp.darkblue,
                                      disabledColor: ColorApp.darkblue,
                                      disabledTextColor: Colors.white,
                                      onPressed:(load == false)
                                          ? () {
                                        if (typeChequier == null ||
                                            volumeChequier == null) {
                                          if (typeChequier == null) {
                                            setState(() {
                                              _hintType =
                                              "Choisir le type du chéquier";
                                              _colorType = Colors.redAccent;
                                            });
                                          } else {
                                            setState(() {
                                              _hintVolume =
                                              "Choisir le volume du chéquier";
                                              _colorVolume = Colors.redAccent;
                                            });
                                          }
                                        } else {
                                          _confirmCmd();
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

    return BlocEventStateBuilder<CmdChequierState>(
      bloc: _cmdChequierBloc,
      builder: (BuildContext context, CmdChequierState state) {
        if (state is CmdChequierInitialized) {
          load = true;
        }
        if (state is CmdChequierError) {
          load = false;
          Utils.dialog(context, state.error, 'ERREUR', false);
        }

        if (state is CmdChequierSuccess) {
          load = false;
          Utils.dialog(context, state.success, 'COMMANDE CHEQUIER', false);
          typeSelectedChequier = null ;
          volumeChequier = null ;
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

  void getComptes() {
    DatabaseClient().allComptes().then((items) {
      setState(() {
        this.nroSelectedCompte = items[0].libelleCompte;
        this.compte = items[0];
        this.comptes = items;
      });
    });
  }

  void getTypesChequiers() {
    DatabaseClient().allChequiers().then((items) {
      setState(() {
        this.typesChequiers = items;
      });
    });
  }

  void _confirmCmd() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Confirmation de la commande"),
            content: new Container(
              width: MediaQuery.of(context).size.width - 100.0,
              height: MediaQuery.of(context).size.height / 4,
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
                        'Type de chéquier:',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          (compte != null) ? typeChequier.libelleType : '',
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
                        'Volume de chéquier :',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          volumeChequier,
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

                    _cmdChequierBloc.emitEvent(Post(
                      typeChequier: typeChequier.codeType,
                      volumeChequier: volumeChequier,
                      compte: compte.numeroCompte, //nroCompte,
                    ));
                    print("ACTION SUBMIT");
                    print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
                    
                  }),
            ],
          );
        });
  }
}
