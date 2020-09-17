import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/virements_banque/virement_banque_form_bloc.dart';
import 'package:gui/blocs/virements_banque/virements_banque_bloc.dart';
import 'package:gui/blocs/virements_banque/virements_banque_state.dart';
import 'package:gui/blocs/virements_banque/virements_banque_event.dart';
import 'package:gui/models/beneficiaire.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/models/virementbankitem.dart';
import 'package:gui/pages/banking/add_beneficiaire_banque.dart';
import 'package:gui/pages/banking/delete_beneficiaire_banque.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/banking_standard_app_bar.dart';

class NewVirementBanquePage extends StatefulWidget {
  @override
  _NewVirementBanqueState createState() => _NewVirementBanqueState();
}

class _NewVirementBanqueState extends State<NewVirementBanquePage>
    with BankingStandardAppBar {
  VirementsBanqueBloc _newVirementsBanqueBloc;

  VirementBanqueFormBloc _newVirementsBanqueFormBloc;

  LoginBloc _loginBloc;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Compte> comptes;

  Compte compte;

  String source;
  String nroCompte;

  Color colorCompte;

  String benefString = '';
  String benefButton = 'Sélectionner';
  String benefMessage = "Sélectionner au moins un bénéficiaire";
  bool showBenefMessage = false;

  List<VirementBankItem> virementItems = new List();
  List<Beneficiaire> beneficiaires = new List();

  Beneficiaire _value;

  List<NFDetailsInfo> types = [
    NFDetailsInfo(label: 'COURANT', value: 'COURANT'),
    NFDetailsInfo(label: 'EPARGNE', value: 'EPARGNE'),
  ];

  TextEditingController _secretController = TextEditingController();
  TextEditingController _numCompteBeneficiaireController =
      TextEditingController();
  TextEditingController _nomBanqueController = TextEditingController();
  TextEditingController _nomBeneficiaireController = TextEditingController();
  TextEditingController _codeBanqueController = TextEditingController();
  TextEditingController _codeGuichetController = TextEditingController();
  TextEditingController _libelleController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _typeCompteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComptes();
    _newVirementsBanqueBloc = VirementsBanqueBloc();
    _newVirementsBanqueFormBloc = VirementBanqueFormBloc();
  }

  @override
  void dispose() {
    _secretController?.dispose();
    _numCompteBeneficiaireController?.dispose();
    _nomBanqueController?.dispose();
    _nomBeneficiaireController?.dispose();
    _codeBanqueController?.dispose();
    _codeGuichetController?.dispose();
    _libelleController?.dispose();
    _montantController?.dispose();
    _typeCompteController?.dispose();

    _newVirementsBanqueFormBloc?.dispose();
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
                      stream: _newVirementsBanqueFormBloc.compte,
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
                                  //nroCompte = changedValue;
                                  setState(() {
                                    nroCompte = changedValue;
                                    print(nroCompte);
                                    compte = comptes.firstWhere((compte) =>
                                        compte.libelleCompte
                                            .compareTo(nroCompte) ==
                                        0);
                                  });
                                },
                                value: nroCompte,
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
                          padding: EdgeInsets.only(bottom: 5.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _newVirementsBanqueFormBloc.secret,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration:
                                new InputDecoration(labelText: "CODE SECRET"),
                            controller: _secretController,
                            validator: (val) =>
                                val.length != 4 ? 'CODE SECRET INVALIDE' : null,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                          padding: EdgeInsets.only(bottom: 10.0),
                        );
                      }),
                  StreamBuilder<String>(
                      stream: _newVirementsBanqueFormBloc.numCompteBenef,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration:
                                new InputDecoration(labelText: "LIBELLE"),
                            controller: _libelleController,
                            validator: (val) =>
                                val.length < 1 ? 'LIBELLE INVALIDE' : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 10.0),
                        );
                      }),
                  Text('GESTION DES BENEFICIAIRES:', style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),),

                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StreamBuilder<bool>(
                            stream:
                                _newVirementsBanqueFormBloc.submitPreference,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              return new FlatButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 30.0),
                                textColor: Colors.white,
                                color: ColorApp.blue,
                                disabledColor: ColorApp.darkblue,
                                disabledTextColor: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddBeneficiairePage()),
                                  );
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                child: Text(
                                  "Ajouter",
                                  style: TextStyle(fontSize: 10.0),
                                ),
                                //child: new Text("AJOUTER COMPTE", style : new TextStyle(fontSize: 10.0)),
                              );
                            }),
                        Expanded(
                          child: new FlatButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            textColor: Colors.white,
                            color: ColorApp.blue,
                            disabledColor: ColorApp.darkblue,
                            disabledTextColor: Colors.white,
                            onPressed: () => _newVirementsBanqueBloc
                                .emitEvent(GetPreference()),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              benefButton,
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ),
                        ),Expanded(
                          child: new FlatButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            textColor: Colors.white,
                            color: ColorApp.blue,
                            disabledColor: ColorApp.darkblue,
                            disabledTextColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DeleteBeneficiairePage()),
                                );
                              },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: Text(
                              "Supprimer",
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: StreamBuilder<String>(builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (beneficiaires.length <= 0 && showBenefMessage) {
                        return Center(
                            child: Text(
                          benefMessage,
                          style: TextStyle(color: Colors.redAccent),
                        ));
                      } else {
                        return Column(
                          children: listBeneficiaires(),
                        );
                      }
                    }),
                  ),
                  StreamBuilder<String>(
                      stream: _newVirementsBanqueFormBloc.montant,
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
                      stream: _newVirementsBanqueFormBloc.submitValidation,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return StreamBuilder<String>(
                            stream: _newVirementsBanqueFormBloc.compte,
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

    return BlocEventStateBuilder<VirementsBanqueState>(
      bloc: _newVirementsBanqueBloc,
      builder: (BuildContext context, VirementsBanqueState state) {
        if (state is VirementsBanqueInitialized) {


          if (state.preference){

            benefButton="Chargement en cours";
          } else {
            Utils.showDialogProgress(context, 'Requete en cours ...');
          }
        }
        if (state is VirementsBanqueError) {
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
        if (state is VirementsBanqueSuccess) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            _secretController.text = '';
            _montantController.text = '';
            _nomBeneficiaireController.text = '';
            _montantController.text = '';
            _libelleController.text = '';
            beneficiaires = new List();
            //nroCompte = null ;
            showBenefMessage = false;
          });
//          Navigator.pop(context);
          Utils.dialog(context, state.success, 'VIREMENT BANQUE', false);
        }
        if (state is VirementsBanqueGetPreference) {
          Utils.onWidgetDidBuild(() {
            //Navigator.pop(context);
            benefButton="Choisir";
            dialog('CHOISIR UN COMPTE', state.beneficiaires);
          });
        }
        if (state is VirementsBanquePreference) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
          });
          Utils.dialog(
              context, 'Sauvegardé avec succès.', 'CONFIRMATION', false);
        }
        return new Scaffold(
          appBar: appBar(
              context, Config.serviceMBanking, _loginBloc, "Virement banque"),
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

  Future<Null> dialog(String title, List<Beneficiaire> nfPrefItems,
      {bool items: true}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: new Text(title),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: nfPrefItems.map((Beneficiaire value) {
                  return new SimpleDialogOption(
                      child:
                      new Text(value.nombeneficiaire+"/"+value.numerocompte),
                      onPressed: () {
                        //Navigator.of(context).pop();
                        //this._value = value;
                        items ? setState(() => choice(value)) : null;
                      });
                }).toList(),
              ),
              SizedBox(
                height: 20.0,
              ),
              new FlatButton(
                  child: new Text(
                    "OK",
                    textAlign: TextAlign.right,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
            ],
          );
        });
  }

  //@override
  void choice(Beneficiaire beneficiaire) {
    bool _add = true;
    if (beneficiaires.isNotEmpty) {
      for (var i = 0; i < beneficiaires.length; i++) {
        if (beneficiaires[i].id == beneficiaire.id) {
          _add = false;
          break;
        }
      }
      if (_add) beneficiaires.add(beneficiaire);
    } else
      beneficiaires.add(beneficiaire);
    print("**********${beneficiaires.length}**********");
  }

  /* @override
  void choiceString(String carte) {
    // TODO: implement choiceString
  }*/

  errorSave(BuildContext context) {
    String message =
        "Veuillez specifier un libelle pour enregistrer les elements suivants :\n";

    print(message);
  }

  bool formValidate() {
    if (nroCompte == null) {
      //Utils.dialog(context, "Vous devez choisir un compte !", "ERREUR", true);
      setState(() {
        colorCompte = Colors.redAccent;
      });
      return false;
    }
    if (beneficiaires.isEmpty) {
      /*Utils.dialog(
          context,
          "Vous devez choisir un beneficiaire ! Ajoutez un bénéficiaire si vous n'en avez pas.",
          "ERREUR",
          true);*/
      setState(() {
        showBenefMessage = true;
      });
      //showBenefMessage = true ;
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
                          'Libellé :',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            compte.numeroCompte,
                            style: TextStyle(fontSize: 10.0),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        Text(
                          'Bénéficiaire(s) :',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            "${beneficiaires.length}",
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

                    for (var i = 0; i < beneficiaires.length; i++) {
                      VirementBankItem item = VirementBankItem(
                          compte.numeroCompte,
                          compte.agence,
                          beneficiaires[i].nombanque,
                          beneficiaires[i].nombeneficiaire,
                          beneficiaires[i].codeBanque,
                          beneficiaires[i].codeGuichet,
                          beneficiaires[i].numerocompte,
                          _libelleController.text,
                          _montantController.text);
                      virementItems.add(item);
                    }
                    /*VirementBankItem item1 = VirementBankItem(
                        compte.numeroCompte,
                        "bgfi bank",
                        "test",
                        "11111",
                        "11111",
                        "11111111111",
                        _libelleController.text,
                        _montantController.text);
                    virementItems.add(item1);*/

                    _newVirementsBanqueBloc.emitEvent(Post(
                        secret: _secretController.text,
                        beneficiaires: virementItems));
                  }),
            ],
          );
        });
  }

  List<Row> listBeneficiaires() {
    return beneficiaires
        .map(
          (beneficiaire) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: AutoSizeText(
                        beneficiaire.nombeneficiaire+" / "+beneficiaire.numerocompte,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                        maxFontSize: 12.0,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  IconButton(
                    //label: Text("Supp."),
                    icon: Icon(
                      Icons.cancel,
                      size: 20.0,
                    ),
                    onPressed: () {
                      setState(() {
                        beneficiaires.remove(beneficiaire);
                        if (beneficiaires.isNotEmpty) {
                          print("********* Liste benef ***********");
                          print(beneficiaires);
                        } else {
                          print("*******LISTE VIDE *********");
                          beneficiaires = new List();
                          showBenefMessage = true;
                        }
                      });
                    },
                  )
                ],
              ),
        )
        .toList();
  }
}
