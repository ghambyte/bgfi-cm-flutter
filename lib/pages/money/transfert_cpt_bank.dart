
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/transfert_cpt_bank/transfert_cpt_bank_bloc.dart';
import 'package:gui/blocs/transfert_cpt_bank/transfert_cpt_bank_event.dart';
import 'package:gui/blocs/transfert_cpt_bank/transfert_cpt_bank_form_bloc.dart';
import 'package:gui/blocs/transfert_cpt_bank/transfert_cpt_bank_state.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/models/nf_pref_bank_account.dart';
import 'package:gui/models/nf_pref_item.dart';
import 'package:gui/tools/chasingdots.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/double_bounce.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/choice_popup.dart';

class TransfertCompteBanquePage extends StatefulWidget {
  @override
  _TransfertCompteBanquePageState createState() => _TransfertCompteBanquePageState();
}

class _TransfertCompteBanquePageState extends State<TransfertCompteBanquePage> with ChoicePopup{

  TransfertCompteBanqueBloc _transfertCompteBanqueBloc ;

  TransfertCompteBanqueFormBloc _transfertCompteBanqueFormBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NFDetailsInfo> _paysList = [
    NFDetailsInfo(label: '', value: 'Choisir un pays'),
    NFDetailsInfo(label: '0CM', value: 'CAMEROUN'),
    NFDetailsInfo(label: '0CF', value: 'CENTRAFRIQUE'),
    NFDetailsInfo(label: '0CG', value: 'CONGO (BRAZZAVILLE)'),
    NFDetailsInfo(label: '0GA', value: 'GABON'),
    NFDetailsInfo(label: '0GQ', value: 'GUINEE EQUATORIALE'),
    NFDetailsInfo(label: '0TD', value: 'TCHAD'),
  ];
  String _val;
  String isgimac = "";
  bool load = false;
  var yyDialog = YYDialog();

  TextEditingController _secretController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _banqueController = TextEditingController();
  TextEditingController _paysController = TextEditingController();
  TextEditingController _titnomController = TextEditingController();
  TextEditingController _titprenomController = TextEditingController();
  TextEditingController _compteController = TextEditingController();
  TextEditingController _agenceController = TextEditingController();
  TextEditingController _codeBanqueController = TextEditingController();

  @override
  void initState() {
    _transfertCompteBanqueFormBloc = TransfertCompteBanqueFormBloc();
    _transfertCompteBanqueBloc = TransfertCompteBanqueBloc();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _transfertCompteBanqueFormBloc?.dispose();
    _secretController?.dispose();
    _montantController?.dispose();
    _banqueController?.dispose();
    _paysController?.dispose();
    _titnomController?.dispose();
    _titprenomController?.dispose();
    _compteController?.dispose();
    _agenceController?.dispose();
    _codeBanqueController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    double widthUnit = (widthScreen-80.0)/25;

    Widget form() {
      return Form(
        key: formKey,
        child: Theme(
            data: theme.copyWith(
              primaryColor: ColorApp.green,
              hintColor: ColorApp.green,
              highlightColor: ColorApp.green,
              accentColor: Colors.black,
              primaryColorDark: ColorApp.green,
              cursorColor: ColorApp.green,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<String>(
                      stream: _transfertCompteBanqueFormBloc.secret,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "CODE SECRET",  ),
                            controller: _secretController,
                            validator: (val) => val.length!=4 ? 'CODE SECRET INVALIDE' : null,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: StreamBuilder<String>(
                                stream: _transfertCompteBanqueFormBloc.codeBanque,
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  return Container(
                                    child: TextFormField(
                                      decoration: new InputDecoration(labelText: "C.BANQUE"),
                                      controller: _codeBanqueController,
                                      validator: (val) => val.length<1 ? 'CODE BANQUE INVALIDE' : null,
                                      keyboardType: TextInputType.text,
                                      maxLength: 5
                                    ),
                                    padding: EdgeInsets.only(right: widthUnit),
                                  );
                                }
                            ),
                        ),
                        Expanded(
                            child: StreamBuilder<String>(
                                stream: _transfertCompteBanqueFormBloc.agence,
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  return Container(
                                    child: TextFormField(
                                      decoration: new InputDecoration(labelText: "C.AGENCE"),
                                      controller: _agenceController,
                                      validator: (val) => val.length<1 ? 'CODE AGENCE INVALIDE' : null,
                                      keyboardType: TextInputType.text,
                                      maxLength: 5
                                    ),
                                    padding: EdgeInsets.only(right: widthUnit),
                                  );
                                }
                            ),
                        ),
                        Expanded(
                            child: StreamBuilder<String>(
                                stream: _transfertCompteBanqueFormBloc.compte,
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  return Container(
                                    child: TextFormField(
                                      decoration: new InputDecoration(labelText: "N.COMPTE"),
                                      controller: _compteController,
                                      validator: (val) => val.length<1 ? 'NUMERO COMPTE INVALIDE' : null,
                                      keyboardType: TextInputType.text,
                                        maxLength: 11
                                    ),
                                    padding: EdgeInsets.only(right: widthUnit),
                                  );
                                }
                            ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),
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
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                      new FlatButton(
                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
                        textColor: Colors.white,
                        color: ColorApp.blue,
                        disabledColor:ColorApp.darkblue,
                        disabledTextColor: Colors.white,
                        onPressed: () => _transfertCompteBanqueBloc.emitEvent(GetPreference()),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Icon(Icons.list),
                      ),
                      ],
                    ),
                  ),
                  StreamBuilder<String>(
                      stream: _transfertCompteBanqueFormBloc.montant,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "MONTANT"),
                            controller: _montantController,
                            validator: (val) => val.length<1 ? 'MONTANT INVALIDE' : null,
                            keyboardType: TextInputType.number,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),
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
                  StreamBuilder<bool>(
                      stream: _transfertCompteBanqueFormBloc.submitValidation,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new RaisedButton(
                                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
                                textColor: Colors.white,
                                color: ColorApp.green,
                                disabledColor:ColorApp.darkGreen,
                                disabledTextColor: Colors.white,
                                onPressed: ((){
                                  final form = formKey.currentState;
                                  if (form.validate()) {
                                    form.save();
                                    _transfertCompteBanqueBloc.emitEvent(
                                        Post(
                                            secret: _secretController.text,
                                            pays: "0CM",
                                            montant: double.parse(_montantController.text),
                                            banque: "xxx",
                                            titnom: "xxx",
                                            titprenom: "xxx",
                                            compte: '${_codeBanqueController.text}${_agenceController.text}${_compteController.text}'
                                        )
                                    );
                                  }
                                }),
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                child: new Text("VALIDER"),
                              )]);
                      }
                  ),
                ],
              ),
            )
        ),
      );
    }

    return BlocEventStateBuilder<TransfertCompteBanqueState>(
      bloc: _transfertCompteBanqueBloc,
      builder: (BuildContext context, TransfertCompteBanqueState state) {
        if(state is TransfertCompteBanqueInitialized) {
          load = true;
        }
        if(state is TransfertCompteBanqueLoaded) {
          load = false;
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertDialogWithDivider(context, yyDialog, "CONFIRMATION", state.nfConfirmResponse.recaps, ()=> confirmer(state.nfConfirmResponse.idtransaction, 1,state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token), false);
          });
        }
        if(state is TransfertCompteBanqueConfirm) {
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertInfoDialogWithDivider(context, "INFOS", yyDialog, state.nfConfirmResponse.recaps);
          });
          load = false;
        }
        if(state is TransfertCompteBanqueError) {
          load = false;
          Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 5,
              backgroundColor: Colors.white,
              textColor: Colors.red,
              fontSize: 16.0
          );
        }

        if(state is TransfertCompteBanqueGetPreference) {
          load = false;
          Utils.onWidgetDidBuild(() {
            dialog('CHOISIR UN COMPTE', state.nfPrefItems);
          });
        }
        if(state is TransfertCompteBanquePreference) {
          load = false;
          Utils.dialog(context, 'Sauvegardé avec succès.', 'CONFIRMATION', false);
        }
        return ListView(children: <Widget>[Center(child: form())], shrinkWrap: true,);
      },
    );
  }

  confirmer(String transaction, int action, String token) {
    _transfertCompteBanqueBloc.emitEvent(Confirm(id: transaction, action: action, token: token));
  }

  errorSave(BuildContext context) {
    String message = "Enregistrer les elements suivants :\n";

    if(_titprenomController.text.length!=0) {
      message += '- PRENOM : ${_titprenomController.text} \n';
    } else {
      Utils.aletreDialog(context, "PRENOM NON SPECIFIE", "ERREUR", true);
      return;
    }
    if(_titnomController.text.length!=0) {
      message += '- NOM : ${_titnomController.text} \n';
    } else {
      Utils.aletreDialog(context, "NOM NON SPECIFIE", "ERREUR", true);
      return;
    }

    if(_banqueController.text.length!=0) {
      message += '- BANQUE : ${_banqueController.text} \n';
    } else {
      Utils.aletreDialog(context, "BANQUE NON SPECIFIEE", "ERREUR", true);
      return;
    }

    if(_codeBanqueController.text.length!=0) {
      message += '- CODE BANQUE : ${_codeBanqueController.text} \n';
    } else {
      Utils.aletreDialog(context, "CODE BANQUE NON SPECIFIE", "ERREUR", true);
      return;
    }

    if(_agenceController.text.length!=0) {
      message += '- CODE AGENCE : ${_agenceController.text} \n';
    } else {
      Utils.aletreDialog(context, "CODE AGENCE NON SPECIFIE", "ERREUR", true);
      return;
    }

    if(_compteController.text.length!=0) {
      message += '- COMPTE : ${_compteController.text} \n';
    } else {
      Utils.aletreDialog(context, "COMPTE NON SPECIFIE", "ERREUR", true);
      return;
    }
    print(message);

  }

  @override
  void choice(NFPrefBankAccount nfPrefBankAccount) {

  }

  @override
  void choiceString(String valeur) {
    _codeBanqueController.text = valeur.substring(0, 5);
    _agenceController.text = valeur.substring(5, 10);
    _compteController.text = valeur.substring(10);
  }

  Future<Null> dialog(String title, List<NfPrefItem> nfPrefItems, {bool items: true}) async{
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return new SimpleDialog(
            title: new Text(title),
            children: nfPrefItems.map((NfPrefItem value) {
              return new SimpleDialogOption(
                  child: new Text(value.libelle),
                  onPressed: () {
                    Navigator.pop(context);
                    items?choiceString(value.valeur): choiceString(value.valeur);
                  }
              );
            }).toList(),
          );
        });

  }

  bool formValidate(){
    if(_val == null){
      Utils.dialog(context, "Vous devez choisir un pays !", "ERREUR", true);
      return false;
    }
    return true;
  }

  bool prefValidator(BuildContext context) {
    String message = "Enregistrer les elements suivants :\n";

    if(_codeBanqueController.text.length==5) {
      message += '- CODE BANQUE : ${_codeBanqueController.text} \n';
    } else {
      Utils.aletreDialog(context, "LONGUEUR CODE BANQUE INCORRECTE", "ERREUR", true);
      return false;
    }

    if(_agenceController.text.length==5) {
      message += '- CODE AGENCE : ${_agenceController.text} \n';
    } else {
      Utils.aletreDialog(context, "LONGUEUR CODE AGENCE INCORRECTE", "ERREUR", true);
      return false;
    }

    if(_compteController.text.length==11) {
      message += '- COMPTE : ${_compteController.text} \n';
    } else {
      Utils.aletreDialog(context, "LONGUEUR COMPTE INCORRECTE", "ERREUR", true);
      return false;
    }
    print(message);
    return true;

  }
}
