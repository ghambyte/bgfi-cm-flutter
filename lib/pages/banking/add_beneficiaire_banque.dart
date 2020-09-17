
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
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/banking_standard_app_bar.dart';

class AddBeneficiairePage extends StatefulWidget {
  @override
  _AddBeneficiaireState createState() => _AddBeneficiaireState();
}

class _AddBeneficiaireState extends State<AddBeneficiairePage> with BankingStandardAppBar{

  VirementsBanqueBloc _newVirementsBanqueBloc ;

  VirementBanqueFormBloc _newVirementsBanqueFormBloc ;

  LoginBloc _loginBloc;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Compte> comptes;

  Compte compte;

  String source;
  String nroCompte;
  String newValue;

  List<NFDetailsInfo> types = [
    NFDetailsInfo(label: 'COURANT', value: 'COURANT'),
    NFDetailsInfo(label: 'EPARGNE', value: 'EPARGNE'),
  ];

  TextEditingController _secretController = TextEditingController();
  TextEditingController _numCompteBeneficiaireController = TextEditingController();
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
                      stream: _newVirementsBanqueFormBloc.nomBanque,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "NOM BENEFICIAIRE"),
                            controller: _nomBeneficiaireController,
                            validator: (val) => val.length<1 ? 'NOM BENEFICIAIRE INVALIDE' : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _newVirementsBanqueFormBloc.nomBanque,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "NOM BANQUE"),
                            controller: _nomBanqueController,
                            validator: (val) => val.length<1 ? 'NOM BANQUE INVALIDE' : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _newVirementsBanqueFormBloc.codeBanque,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "CODE BANQUE"),
                            controller: _codeBanqueController,
                            validator: (val) => val.length<1 ? 'CODE BANQUE INVALIDE' : null,
                            keyboardType: TextInputType.text,
                            maxLength: 5,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _newVirementsBanqueFormBloc.codeGuichet,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "CODE GUICHET"),
                            controller: _codeGuichetController,
                            validator: (val) => val.length<1 ? 'CODE GUICHET INVALIDE' : null,
                            keyboardType: TextInputType.text,
                            maxLength: 5,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _newVirementsBanqueFormBloc.numCompteBenef,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "Nro COMPTE BENEF"),
                            controller: _numCompteBeneficiaireController,
                            validator: (val) => val.length<1 ? 'Nro COMPTE BENEF INVALIDE' : null,
                            keyboardType: TextInputType.text,
                            maxLength: 11,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),

                  StreamBuilder<String>(
                      stream: _newVirementsBanqueFormBloc.carrier,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container (
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'TYPE COMPTE',
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.darkblue,
                              ),
                              border: InputBorder.none,
                            ),
                            child: new DropdownButton<String>(
                                hint: Text('CHOISIR UN TYPE DE COMPTE'),
                                onChanged: (String changedValue) {
                                  newValue=changedValue;
                                  setState(() {
                                    newValue;
                                    print(newValue);
                                  });
                                },
                                value: newValue,
                                items: types.map((operateur) {
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

                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        StreamBuilder<bool>(
                            stream: _newVirementsBanqueFormBloc.submitPreference,
                            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                              return new FlatButton(
                                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
                                textColor: Colors.white,
                                color: ColorApp.blue,
                                disabledColor:ColorApp.darkblue,
                                disabledTextColor: Colors.white,
                                onPressed: ((){
                                  final form = formKey.currentState;
                                  if (form.validate() && formValidate()) {
                                    form.save();
                                    _newVirementsBanqueBloc.emitEvent(
                                        Preference(
                                          numCpt: _numCompteBeneficiaireController.text,
                                          nomTitulaire: _nomBeneficiaireController.text,
                                          codeBanque: _codeBanqueController.text,
                                          codeGuichet: _codeGuichetController.text,
                                          nomBanque: _nomBanqueController.text,
                                          typeCompte: newValue,
                                        )
                                    );
                                  }
                                }),
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                child: Icon(Icons.save),
                                //child: new Text("AJOUTER COMPTE", style : new TextStyle(fontSize: 10.0)),
                              );
                            }),

                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      );
    }

    return BlocEventStateBuilder<VirementsBanqueState>(
      bloc: _newVirementsBanqueBloc,
      builder: (BuildContext context, VirementsBanqueState state) {
        if (state is VirementsBanqueInitialized) {
          Utils.showDialogProgress(context, 'Requete en cours ...');
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
            _numCompteBeneficiaireController.text = '';
            _nomBeneficiaireController.text = '';
            _codeBanqueController.text = '';
            _codeGuichetController.text = '';
            _nomBanqueController.text = '';
          });
          Navigator.pop(context);
          Utils.dialog(context, state.success, 'VIREMENT BANQUE', false);
        }
        if(state is VirementsBanqueGetPreference) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            dialog('CHOISIR UN COMPTE', state.beneficiaires);
          });
        }
        if(state is VirementsBanquePreference) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            _numCompteBeneficiaireController.text = '';
            _nomBeneficiaireController.text = '';
            _codeBanqueController.text = '';
            _codeGuichetController.text = '';
            _nomBanqueController.text = '';
          });
          Utils.dialog(context, 'Sauvegardé avec succès.', 'CONFIRMATION', false);
        }
        return new Scaffold(
          appBar: appBar(context, Config.serviceMBanking, _loginBloc, "Virement banque"),
          backgroundColor: ColorApp.background,
          body: ListView(children: <Widget>[Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(child: form()),
          )
          ], shrinkWrap: true,),
        );
      },
    );
  }

  void getComptes() async{
    DatabaseClient().allComptes().then((items){
      setState(() {
        this.comptes = items;
      });
    });
  }

  Future<Null> dialog(String title, List<Beneficiaire> nfPrefItems, {bool items: true}) async{
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return new SimpleDialog(
            title: new Text(title),
            children: nfPrefItems.map((Beneficiaire value) {
              return new SimpleDialogOption(
                  child: new Text(value.nombeneficiaire),
                  onPressed: () {
                    Navigator.pop(context);
                    items?choice(value): choiceString(value.codeGuichet);
                  }
              );
            }).toList(),
          );
        });

  }

  @override
  void choice(Beneficiaire beneficiaire) {
    _nomBeneficiaireController.text = beneficiaire.nombeneficiaire;
    _nomBanqueController.text = beneficiaire.nombanque;
    _codeBanqueController.text = beneficiaire.codeBanque;
    _codeGuichetController.text = beneficiaire.codeGuichet;
    _numCompteBeneficiaireController.text = beneficiaire.numerocompte;
  }

  @override
  void choiceString(String carte) {
    // TODO: implement choiceString
  }

  errorSave(BuildContext context) {
    String message = "Veuillez specifier un libelle pour enregistrer les elements suivants :\n";

    print(message);

  }

  bool formValidate(){
    if(newValue == null){
      Utils.dialog(context, "Vous devez choisir un type de compte !", "ERREUR", true);
      return false;
    }
    return true;
  }

}
