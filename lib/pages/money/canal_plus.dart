
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/canal_plus/canal_plus_bloc.dart';
import 'package:gui/blocs/canal_plus/canal_plus_event.dart';
import 'package:gui/blocs/canal_plus/canal_plus_state.dart';
import 'package:gui/models/nf_pref_bank_account.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/choice_canal_popup.dart';
import 'package:gui/widgets/choice_popup.dart';

class CanalPlusPage extends StatefulWidget {
  @override
  _CanalPlusPageState createState() => _CanalPlusPageState();
}

class _CanalPlusPageState extends State<CanalPlusPage> with ChoiceCanalPopup{

  CanalPlusBloc _canalPlusBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String typeabo = "1";
  String options = "";
  String carte;
  String secret;
  int montant;
  String libelle;

  List<String> formules = <String>['ACCESS', 'EVASION', 'ESSENTIEL +', 'ACCESS +', 'EVASION +', 'TOUT CANAL+'];
  List<String> formules_value = <String>['35M1AC|ACDD', '35M2EV|EVDD', '35M3CP|CPDD', '35M4ACP|ACPDD', '35M5EVP|EVPDD', '35M6TCA|TCADD'];
  String formule_str = 'ACCESS';
  String formule = "35M1AC|ACDD";


  List<String> durees = <String>['1 mois','2 mois', '3 mois', '6 mois', '12 mois', '24 mois'];
  List<String> durees_value = <String>['1', '2', '3', '6' , '12', '24'];
  String duree_str = '1 mois';
  String duree = "1";

  var carteController = new TextEditingController();
  var libelleController = new TextEditingController();
  var changeFormuleEnabled = false;
  var charmeEnabled = false;


  @override
  void initState() {
    _canalPlusBloc = CanalPlusBloc();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget form() {
      return Form (
          key: formKey,
          child: Container (
              margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container (
                    child: new TextFormField(
                      decoration: new InputDecoration(labelText: "CODE SECRET"),
                      keyboardType: TextInputType.number,
                      validator: (val) => val.length!=4 ? 'CODE SECRET INVALIDE' : null,
                      onSaved: (val) => secret = val,
                      obscureText: true,
                    ),
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),

                  Container (
                      child: new TextFormField(

                        decoration: new InputDecoration(labelText: "LIBELLE CARTE"),
                        keyboardType: TextInputType.text,
                        validator: (val) => val.length<0 ? 'LIBELLE CARTE INVALIDE' : null,
                        onSaved: (val) => libelle = val,
                        controller: libelleController,
                      ),
                      padding: EdgeInsets.only(bottom: 15.0)
                  ),

                  Container (
                      child: new TextFormField(

                        decoration: new InputDecoration(labelText: "NUMERO CARTE"),
                        keyboardType: TextInputType.number,
                        validator: (val) => val.length!=14 ? 'NUMERO CARTE INVALIDE' : null,
                        onSaved: (val) => carte = val,
                        controller: carteController,
                      ),
                      padding: EdgeInsets.only(bottom: 15.0)
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[ new FlatButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
                        textColor: Colors.white,
                        color: ColorApp.blue,
                        disabledColor:ColorApp.darkblue,
                        disabledTextColor: Colors.white,
                        onPressed: (){
                          print("ACTION SAVE PREF");
                          final form = formKey.currentState;
                          form.save();
                          if(carteController.text.length==14 && libelleController.text.length > 1) {
                            savePref(context);
                          }else{
                            Utils.aletreDialog(context, "Vous devez reseingner un libellé et une longueur de carte corrects", "AJOUT CARTE CANAL", true);
                          }
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Icon(Icons.save),
                        //child: new Text("AJOUTER COMPTE", style : new TextStyle(fontSize: 10.0)),
                      ),
                      new FlatButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
                        textColor: Colors.white,
                        color: ColorApp.blue,
                        disabledColor:ColorApp.darkblue,
                        disabledTextColor: Colors.white,
                        onPressed: ()=> _canalPlusBloc.emitEvent(GetPreference()),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Icon(Icons.list),
                        //child: new Text("SELECTIONNER COMPTE", style : new TextStyle(fontSize: 10.0)),
                      ),
//                      new FlatButton(
//                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
//                        textColor: Colors.white,
//                        color: ColorApp.blue,
//                        disabledColor:ColorApp.darkblue,
//                        disabledTextColor: Colors.white,
//                        onPressed: (){
//
//                        },
//                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
//                        child: Icon(Icons.delete),
//                        //child: new Text("GERER COMPTE", style : new TextStyle(fontSize: 10.0)),
//                      )

                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RadioListTile<String>(
                          title: new Text(
                            'Reabonnement Automatique',
                            style: new TextStyle(fontSize: 14.0),
                          ),
                          value: "1",
                          groupValue: typeabo,
                          activeColor : ColorApp.darkGreen,
                          onChanged: handleTypeAboChange,
                        )
                        ,
                        RadioListTile<String>(
                          title: new Text(
                            'Changement de formule',
                            style: new TextStyle(fontSize: 14.0),
                          ),
                          value: "3",
                          groupValue: typeabo,
                          activeColor : ColorApp.darkGreen,
                          onChanged: handleTypeAboChange,
                        )

                      ],
                    ),
                  ),
                  Container (
                    child: new InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'FORMULE',
                        labelStyle: new TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: ColorApp.green,
                        ),
                      ),
                      isEmpty: formule_str == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton<String>(
                          value: formule_str,
                          isDense: true,
                          isExpanded: true,
                          onChanged: changeFormuleEnabled?formuleChanged:null,
                          items: formules.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),
                  Container (
                    child: new InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'DUREE',
                        labelStyle: new TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: ColorApp.green,
                        ),
                      ),
                      isEmpty: duree_str == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton<String>(
                          value: duree_str,
                          isDense: true,
                          isExpanded: true,
                          onChanged: changeFormuleEnabled?dureeChanged:null,
                          items: durees.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              new Checkbox(
                                value: charmeEnabled,
                                activeColor: ColorApp.darkGreen,
                                onChanged:changeFormuleEnabled? handleCHRChange:null,
                              ),
                              new Text(
                                'Option Charme',
                                style: new TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new RaisedButton(
                          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
                          textColor: Colors.white,
                          color: ColorApp.green,
                          disabledColor:ColorApp.darkGreen,
                          disabledTextColor: Colors.white,
                          onPressed: (){
                            print("ACTION SUBMIT");
                            final form = formKey.currentState;
                            if (form.validate()) {
                              form.save();
                              _canalPlusBloc.emitEvent(Post(secret: secret, carte: carteController.text, formule: formule, duree: duree, charme: charmeEnabled?"CHR1":"", ecran: typeabo));
                            }
                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          child: new Text("VALIDER"),
                        )])

                ],
              )
          )
      );
    }

    return BlocEventStateBuilder<CanalPlusState>(
      bloc: _canalPlusBloc,
      builder: (BuildContext context, CanalPlusState state) {
        if(state is CanalPlusInitialized) {
          print("CanalPlusInitialized");
          if(state.confirm) {
            Utils.onWidgetDidBuild(() {
              Navigator.pop(context);
            });
          }
          Utils.showDialogProgress(context, 'Requete en cours ...');
        }
        if(state is CanalPlusLoaded) {
          print("CanalPlusLoaded");
          Utils.onWidgetDidBuild(() {
            Utils.alertDialog(context, "CONFIRMATION", state.nfConfirmResponse.recaps, ()=> confirmer(state.nfConfirmResponse.idtransaction, 1,state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token), false);
          });
        }
        if(state is CanalPlusConfirm) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            Utils.alertInfoOne(context, state.nfConfirmResponse.recaps);
          });
        }
        if(state is CanalPlusError) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
          });
          Utils.dialog(context, state.error, 'CONFIRMATION', false);
        }

        if(state is CanalPlusGetPreference) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            dialogChoice(context, 'CHOISIR UN COMPTE', state.nfPrefItems, items: false);
          });
        }
        if(state is CanalPlusPreference) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
          });
          Utils.dialog(context, 'Sauvegardé avec succès.', 'CONFIRMATION', false);
        }
        return ListView(children: <Widget>[Center(child: form())], shrinkWrap: true,);
      },
    );
  }

  confirmer(String transaction, int action, String token) {
    _canalPlusBloc.emitEvent(Confirm(id: transaction, action: action, token: token));
  }

  @override
  void choice(NFPrefBankAccount nfPrefBankAccount) {
    setState(() {
    });
  }

  @override
  void formuleChanged(String value) {
    setState(() {
      int index = formules.indexOf(value);
      formule = formules_value[index];
      formule_str = value;
    });
  }

  void dureeChanged(String value) {
    setState(() {
      int index = durees.indexOf(value);
      duree = durees_value[index];
      duree_str = value;
    });
  }

  void handleTypeAboChange(Object value) {
    setState(() {
      typeabo = value;
      changeFormuleEnabled = typeabo=="3"?true:false;
    });
  }


  void handleCHRChange(Object value) {
    setState(() {
      charmeEnabled = value;
      options = charmeEnabled?"CHR":"";
    });
  }

  void savePref(BuildContext context) {
    // TODO: implement savePref
    String message = "Veuillez specifier un libelle pour enregistrer la carte suivante :\n";

    if(carte.length!=0) {
      message += "- NUMERO CARTE :" + carte + "\n";
    } else {
      Utils.dialog(context, "NUMERO CARTE NON-SPECIFIE", "ERREUR", true);
      return;
    }

    _canalPlusBloc.emitEvent(Preference(libelle: libelle, valeur: carte));

  }

  @override
  void choiceString(String carte, String libelle) {
    carteController.text = carte;
    libelleController.text = libelle;
    // TODO: implement choiceString
  }
}
