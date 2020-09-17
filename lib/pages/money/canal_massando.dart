
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/canal_massando/canal_massando_bloc.dart';
import 'package:gui/blocs/canal_massando/canal_massando_event.dart';
import 'package:gui/blocs/canal_massando/canal_massando_state.dart';
import 'package:gui/models/nf_pref_bank_account.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/choice_popup.dart';

class CanalMassandoPage extends StatefulWidget {
  @override
  _CanalMassandoPageState createState() => _CanalMassandoPageState();
}

class _CanalMassandoPageState extends State<CanalMassandoPage> with ChoicePopup{

  CanalMassandoBloc _canalMassandoBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String agence = "BATA";
  int adulte = 0;
  String carte;
  String secret;

  List<String> formules = <String>['BASICO'];
  List<String> formules_value = <String>['BAS'];
  String formule_str = 'BASICO';
  String formule = "BAS";


  List<String> durees = <String>['1 mois','2 mois', '3 mois', '4 mois', '5 mois','6 mois','7 mois', '8 mois', '9 mois', '10 mois', '11 mois', '12 mois'];
  List<int> durees_value = <int>[1, 2,3, 4 , 5,6, 7, 8, 9 , 10, 11 , 12];
  String duree_str = '1 mois';
  int duree = 1;

  var carteController = new TextEditingController();
  var adulteEnabled = false;


  @override
  void initState() {
    _canalMassandoBloc = CanalMassandoBloc();
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

                        decoration: new InputDecoration(labelText: "NUMERO CARTE"),
                        keyboardType: TextInputType.number,
                        validator: (val) => val.length==0 ? 'NUMERO CARTE INVALIDE' : null,
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
                          if(carteController.text.length==14) {
                            savePref(context);
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
                        onPressed: () => _canalMassandoBloc.emitEvent(GetPreference()),
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
                            'Agence BATA',
                            style: new TextStyle(fontSize: 14.0),
                          ),
                          value: "BATA",
                          groupValue: agence,
                          activeColor : ColorApp.darkGreen,
                          onChanged: handleTypeAboChange,
                        )
                        ,
                        RadioListTile<String>(
                          title: new Text(
                            'Agence MALABO',
                            style: new TextStyle(fontSize: 14.0),
                          ),
                          value: "MALABO",
                          groupValue: agence,
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
                          onChanged: formuleChanged,
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
                          onChanged: dureeChanged,
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
                                value: adulteEnabled,
                                activeColor: ColorApp.darkGreen,
                                onChanged: handleCHRChange,
                              ),
                              new Text(
                                'Option Adulte',
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
                            final form = formKey.currentState;
                            if (form.validate()) {
                              form.save();
                              _canalMassandoBloc.emitEvent(Post(secret: secret, carte: carteController.text, formule: formule, duree: '$duree', adulte: '$adulte', agence: agence));
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

    return BlocEventStateBuilder<CanalMassandoState>(
      bloc: _canalMassandoBloc,
      builder: (BuildContext context, CanalMassandoState state) {
        if(state is CanalMassandoInitialized) {
          if(state.confirm) {
            Utils.onWidgetDidBuild(() {
              Navigator.pop(context);
            });
          }
          Utils.showDialogProgress(context, 'Requete en cours ...');
        }
        if(state is CanalMassandoLoaded) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            Utils.alertConfirm(context, "CONFIRMATION", state.nfConfirmResponse.recaps, "VALIDER", ()=> confirmer(state.nfConfirmResponse.idtransaction, 1,state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token));
          });
        }
        if(state is CanalMassandoConfirm) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            Utils.alertConfirm(context, "FELICITATION", state.nfConfirmResponse.recaps, "Fermer", ()=> Navigator.pop(context), () => Navigator.pop(context), isfermer: false);
            setState(() {
              // _secretController.text= '';
            });
          });
        }
        if(state is CanalMassandoError) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
          });
          Utils.dialog(context, state.error, 'CONFIRMATION', false);
        }

        if(state is CanalMassandoGetPreference) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            dialogChoice(context, 'CHOISIR UN COMPTE', state.nfPrefItems, items: false);
          });
        }
        if(state is CanalMassandoPreference) {
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
    _canalMassandoBloc.emitEvent(Confirm(id: transaction, action: action, token: token));
  }

  @override
  void choice(NFPrefBankAccount nfPrefBankAccount) {
    setState(() {
    });
  }

  void formuleChanged(String value) {
    // TODO: implement formuleChanged
    setState(() {
      int index = formules.indexOf(value);
      formule = formules_value[index];
      formule_str = value;
    });
  }

  void dureeChanged(String value) {
    // TODO: implement formuleChanged
    setState(() {
      int index = durees.indexOf(value);
      duree = durees_value[index];
      duree_str = value;
    });
  }

  void handleTypeAboChange(Object value) {
    // TODO: implement handleTypeAboChange
    setState(() {
      agence = value;
      //changeFormuleEnabled = typeabo=="3"?true:false;
    });
  }

  void handleCHRChange(Object value) {
    // TODO: implement handleCHRChange
    setState(() {
      adulteEnabled = value;
      adulte = adulteEnabled?1:0;
    });
  }

  void savePref(BuildContext context) {
    // TODO: implement savePref
    print("SAVING");
    String message = "Veuillez specifier un libelle pour enregistrer la carte suivante :\n";

    if(carte.length!=0) {
      message += "- NUMERO CARTE :" + carte + "\n";
    } else {
      Utils.dialog(context, "NUMERO CARTE NON-SPECIFIE", "ERREUR", true);
      return;
    }

    _canalMassandoBloc.emitEvent(Preference(libelle: carte, valeur: carte));

  }

  @override
  void choiceString(String carte) {
      carteController.text = carte;
  }
}
