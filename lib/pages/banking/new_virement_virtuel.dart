import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_bloc.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_form_bloc.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_event.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_state.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/banking_standard_app_bar.dart';

class NewVirementVirtuelPage extends StatefulWidget {
  @override
  _NewVirementVirtuelState createState() => _NewVirementVirtuelState();
}

class _NewVirementVirtuelState extends State<NewVirementVirtuelPage>
    with BankingStandardAppBar {
  VirementsVirtuelsBloc _newVirementsVirtuelsBloc;

  VirementsVirtuelsFormBloc _newVirementsVirtuelsFormBloc;

  LoginBloc _loginBloc;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Compte> comptes;

  Compte compte;

  String libelleCompte;

  String nroCompte;

  String agence;

  Color colorCompte;

  TextEditingController _secretController = TextEditingController();
  TextEditingController _motifController = TextEditingController();
  TextEditingController _nroCptController = TextEditingController();
  TextEditingController _montantController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComptes();
    _newVirementsVirtuelsBloc = VirementsVirtuelsBloc();
    _newVirementsVirtuelsFormBloc = VirementsVirtuelsFormBloc();
  }

  @override
  void dispose() {
    _secretController?.dispose();
    _motifController?.dispose();
    _nroCptController?.dispose();
    _montantController?.dispose();
    _newVirementsVirtuelsFormBloc?.dispose();
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
                      stream: _newVirementsVirtuelsFormBloc.source,
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
                              border: InputBorder.none,
                            ),
                            child: new DropdownButton<String>(
                                hint: Text(
                                  "Choisir un compte",
                                  style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      color: colorCompte),
                                ),
                                onChanged: (String changedValue) {
                                  //newValue=changedValue;
                                  setState(() {
                                    libelleCompte = changedValue;
                                    print(libelleCompte);
                                    compte = comptes.firstWhere((compte) =>
                                        compte.libelleCompte
                                            .compareTo(libelleCompte) ==
                                        0);
                                  });
                                },
                                value: libelleCompte,
                                items: comptes?.map((compte) {
                                  //nroCompte = compte.numeroCompte;
                                  return new DropdownMenuItem<String>(
                                    value: compte.libelleCompte,
//                                  child: new Text(operateur.value),
                                    child: new SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                105,
                                        child: new Text(compte.libelleCompte)),
                                  );
                                })?.toList()),
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _newVirementsVirtuelsFormBloc.secret,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration:
                                new InputDecoration(labelText: "CODE SECRET"),
                            controller: _secretController,
                            validator: (val) =>
                                val.length < 1 ? 'CODE SECRET INVALIDE' : null,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _newVirementsVirtuelsFormBloc.motif,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "MOTIF"),
                            controller: _motifController,
                            validator: (val) =>
                                val.length < 1 ? 'MOTIF INVALIDE' : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _newVirementsVirtuelsFormBloc.nroCompteViruel,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Nro COMPTE VIRTUEL"),
                            controller: _nroCptController,
                            validator: (val) => val.length < 1
                                ? 'Nro COMPTE VIRTUEL INVALIDE'
                                : null,
                            keyboardType: TextInputType.number,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _newVirementsVirtuelsFormBloc.montant,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration:
                                new InputDecoration(labelText: "MONTANT"),
                            controller: _montantController,
                            validator: (val) =>
                                val.length < 1 ? 'MONTANT INVALIDE' : null,
                            keyboardType: TextInputType.number,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<bool>(
                      stream: _newVirementsVirtuelsFormBloc.submitValidation,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return StreamBuilder<String>(
                            stream: _newVirementsVirtuelsFormBloc.source,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> source) {
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
                                      onPressed: (() {
                                        final form = formKey.currentState;
                                        if (form.validate() && formValidate()) {
                                          form.save();
                                          _confirmVirement();
                                        }
                                      }),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      child: new Text("VALIDER"),
                                    )
                                  ]);
                            });
                      }),
                ],
              ),
            )),
      );
    }

    return BlocEventStateBuilder<VirementsVirtuelsState>(
      bloc: _newVirementsVirtuelsBloc,
      builder: (BuildContext context, VirementsVirtuelsState state) {
        if (state is VirementsVirtuelsInitialized) {
          Utils.showDialogProgress(context, 'Requete en cours ...');
        }
        if (state is VirementsVirtuelsError) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
//            setState(() {
//              _secretController.text = '';
//              _motifController.text = '';
//              _nroCptController.text = '';
//              _montantController.text = '';
//            });
          });
          Navigator.pop(context);
          Utils.dialog(context, state.error, 'CONFIRMATION', false);
        }
        if (state is VirementsVirtuelsSuccess) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            _secretController.text = '';
            _motifController.text = '';
            _nroCptController.text = '';
            _montantController.text = '';
          });
          Utils.dialog(context, state.success, 'VIREMENT VIRTUEL', false);
        }
        return new Scaffold(
          appBar: appBar(
              context, Config.serviceMBanking, _loginBloc, "Virement virtuel"),
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

  bool formValidate() {
    if (libelleCompte == null) {
      setState(() {
        colorCompte = Colors.redAccent;
      });
      return false;
    }
    return true;
  }

  void _confirmVirement() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Confirmation du virement"),
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
                        'Source :',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          compte.libelleCompte,
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
                          compte.agence,
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
                        'Motif :',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          _motifController.text,
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
                        'Compte virtuel :',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          _nroCptController.text,
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
                        'Montant :',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          _montantController.text,
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
                  child: new Text("ANNULER", style: TextStyle(color: Colors.black),),
                  onPressed: () => Navigator.of(context).pop()),
              new FlatButton(
                  child: new Text("VALIDER"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _newVirementsVirtuelsBloc.emitEvent(Post(
                      source: compte.numeroCompte,
                      agence: compte.agence,
                      secret: _secretController.text,
                      motif: _motifController.text,
                      compteVirtuel: _nroCptController.text,
                      montant: _montantController.text,
                    ));
                  }),
            ],
          );
        });
  }
}
