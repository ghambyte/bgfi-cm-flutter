
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/transfert_cpt_virtuel/transfert_cpt_virtuel_bloc.dart';
import 'package:gui/blocs/transfert_cpt_virtuel/transfert_cpt_virtuel_form_bloc.dart';
import 'package:gui/blocs/transfert_cpt_virtuel/transfert_cpt_virtuel_event.dart';
import 'package:gui/blocs/transfert_cpt_virtuel/transfert_cpt_virtuel_state.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/tools/chasingdots.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';

class TransfertCompteVirtuelPage extends StatefulWidget {
  @override
  _TransfertCompteVirtuelPageState createState() => _TransfertCompteVirtuelPageState();
}

class _TransfertCompteVirtuelPageState extends State<TransfertCompteVirtuelPage> {

  TransfertCompteVirtuelBloc _transfertCompteVirtuelBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _secretController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _mobileGimacController = TextEditingController();

  TransfertCompteVirtuelFormBloc _transfertCompteVirtuelFormBloc ;


  String ok ='';
  String newValue;
  String paysValue;
  String operatorValue;
  String gabonValue;
  String camerouValue;
  String guiValue;
  String congoValue;
  String idenValue = "xxx";
  String typeabo = "0";
  String indicatifPays = "237";
  String isgimac = "";
  bool gimacVisibility = false;
  bool bgfiVisibility = false;
  bool camerounVisibility = false;
  bool gabonVisibility = false;
  bool congoVisibility = false;
  bool guiVisibility = false;
  bool load = false;
  var yyDialog = YYDialog();

  List<NFDetailsInfo> operateurList = [
    NFDetailsInfo(label: 'CAMEROUN', value: '237'),
    NFDetailsInfo(label: 'GABON', value: '241'),
    NFDetailsInfo(label: 'CONGO', value: '242'),
    NFDetailsInfo(label: 'GUINEE EQUATORIALE', value: '240'),
  ];

  List<NFDetailsInfo> destinataires = [
    NFDetailsInfo(label: 'BGFI', value: 'BGFI'),
    NFDetailsInfo(label: 'GIMAC', value: 'GIMAC'),
  ];

  List<NFDetailsInfo> paysList = [
    NFDetailsInfo(label: 'CAMEROUN', value: '237'),
    NFDetailsInfo(label: 'GABON', value: '241'),
    NFDetailsInfo(label: 'CONGO', value: '242'),
    NFDetailsInfo(label: 'GUINEE EQUATORIALE', value: '240'),
  ];

  List<NFDetailsInfo> operateurCameroun = [
    NFDetailsInfo(label: '10025', value: 'NFC'),
    NFDetailsInfo(label: '11001', value: 'CECEC'),
    NFDetailsInfo(label: '10008', value: 'CBC Cameroun'),
    NFDetailsInfo(label: '10023', value: 'UBC'),
    NFDetailsInfo(label: '10033', value: 'UBA_CM'),
    NFDetailsInfo(label: '10001', value: 'BICEC'),
  ];

  List<NFDetailsInfo> operateurGabon = [
    NFDetailsInfo(label: '40021', value: 'BGFI GABON'),
  ];

  List<NFDetailsInfo> operateurCongo = [
    NFDetailsInfo(label: '30091', value: 'BANQUE POSTALE DU CONGO'),
    NFDetailsInfo(label: '30020', value: 'BSCA'),
  ];

  List<NFDetailsInfo> operateurGui = [
    NFDetailsInfo(label: '50001', value: 'CCEI'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    _transfertCompteVirtuelBloc = TransfertCompteVirtuelBloc();
    _transfertCompteVirtuelFormBloc = TransfertCompteVirtuelFormBloc();
    super.initState();
  }

  @override
  void dispose() {
    _transfertCompteVirtuelFormBloc?.dispose();
    _secretController?.dispose();
    _montantController?.dispose();
    _mobileController?.dispose();
    _mobileGimacController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

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
                      stream: _transfertCompteVirtuelFormBloc.secret,
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
                  StreamBuilder<String>(
                      stream: _transfertCompteVirtuelFormBloc.mobile,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container (
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'DESTINATAIRE',
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.green,
                              ),
                              border: InputBorder.none,
                            ),
                            child: new DropdownButton<String>(
                                hint: Text('Choisir un destinataire'),
                                onChanged: (String changedValue) {
                                  newValue=changedValue;
                                  setState(() {
                                    newValue;
                                    if(newValue == 'GIMAC'){
                                      isgimac = "yes";
                                      gimacVisibility = true;
                                      bgfiVisibility = false;
                                    }else{
                                      isgimac = "no";
                                      indicatifPays = "237";
                                      idenValue = "xxx";
                                      gimacVisibility = false;
                                      camerounVisibility = false;
                                      gabonVisibility = false;
                                      congoVisibility = false;
                                      guiVisibility = false;
                                      bgfiVisibility = true;
                                    }
                                    print(newValue);
                                  });
                                },
                                value: newValue,
                                items: destinataires.map((operateur) {
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
                  Visibility(
                    child: Container (
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
                        child: new DropdownButton<String>(
                            hint: Text('Choisir un pays'),
                            onChanged: (String changedValue) {
                              paysValue=changedValue;
                              setState(() {
                                switch (paysValue) {
                                  case "GABON":
                                    {
                                      indicatifPays = "241";
                                      operateurList = operateurGabon;
                                      camerounVisibility = false;
                                      gabonVisibility = true;
                                      congoVisibility = false;
                                      guiVisibility = false;
                                    }
                                    break;

                                  case "CONGO":
                                    {
                                      indicatifPays = "242";
                                      operateurList = operateurCongo;
                                      camerounVisibility = false;
                                      gabonVisibility = false;
                                      congoVisibility = true;
                                      guiVisibility = false;
                                    }
                                    break;

                                  case "CAMEROUN":
                                    {
                                      indicatifPays = "237";
                                      operateurList = operateurCameroun;
                                      camerounVisibility = true;
                                      gabonVisibility = false;
                                      congoVisibility = false;
                                      guiVisibility = false;
                                    }
                                    break;

                                  case "GUINEE EQUATORIALE":
                                    {
                                      indicatifPays = "240";
                                      operateurList = operateurGui;
                                      camerounVisibility = false;
                                      gabonVisibility = false;
                                      congoVisibility = false;
                                      guiVisibility = true;
                                    }
                                    break;

                                  default:
                                    {
                                      indicatifPays = "241";
                                    }
                                }
                              });
                            },
                            value: paysValue,
                            items: paysList.map((item) {
                              return new DropdownMenuItem<String>(
                                value: item.label,
//                                  child: new Text(operateur.value),
                                child:  new SizedBox(
                                    width: MediaQuery.of(context).size.width-105,
                                    child: new Text(item.label)
                                ),
                              );
                            }).toList()),
                      ),
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                    visible: gimacVisibility,
                  ),
                  Visibility(
                    child: Container (
                      child: new InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'OPERATEUR',
                          labelStyle: new TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: ColorApp.green,
                          ),
                          border: InputBorder.none,
                        ),
                        child: new DropdownButton<String>(
                            hint: Text('Choisir un opérateur'),
                            onChanged: (String changedValue) {
                              guiValue=changedValue;
                              setState(() {
                                idenValue = guiValue;
                              });
                            },
                            value: guiValue,
                            items: operateurGui.map((item) {
                              return new DropdownMenuItem<String>(
                                value: item.value,
//                                  child: new Text(operateur.value),
                                child:  new SizedBox(
                                    width: MediaQuery.of(context).size.width-105,
                                    child: new Text(item.value)
                                ),
                              );
                            }).toList()),
                      ),
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                    visible: guiVisibility,
                  ),
                  Visibility(
                    child: Container (
                      child: new InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'OPERATEUR',
                          labelStyle: new TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: ColorApp.green,
                          ),
                          border: InputBorder.none,
                        ),
                        child: new DropdownButton<String>(
                            hint: Text('Choisir un opérateur'),
                            onChanged: (String changedValue) {
                              congoValue=changedValue;
                              setState(() {
                                idenValue = congoValue;
                              });
                            },
                            value: congoValue,
                            items: operateurCongo.map((item) {
                              return new DropdownMenuItem<String>(
                                value: item.value,
//                                  child: new Text(operateur.value),
                                child:  new SizedBox(
                                    width: MediaQuery.of(context).size.width-105,
                                    child: new Text(item.value)
                                ),
                              );
                            }).toList()),
                      ),
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                    visible: congoVisibility,
                  ),
                  Visibility(
                    child: Container (
                      child: new InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'OPERATEUR',
                          labelStyle: new TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: ColorApp.green,
                          ),
                          border: InputBorder.none,
                        ),
                        child: new DropdownButton<String>(
                            hint: Text('Choisir un opérateur'),
                            onChanged: (String changedValue) {
                              camerouValue=changedValue;
                              setState(() {
                                idenValue = camerouValue;
                              });
                            },
                            value: camerouValue,
                            items: operateurCameroun.map((item) {
                              return new DropdownMenuItem<String>(
                                value: item.value,
//                                  child: new Text(operateur.value),
                                child:  new SizedBox(
                                    width: MediaQuery.of(context).size.width-105,
                                    child: new Text(item.value)
                                ),
                              );
                            }).toList()),
                      ),
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                    visible: camerounVisibility,
                  ),
                  Visibility(
                    child: Container (
                      child: new InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'OPERATEUR',
                          labelStyle: new TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: ColorApp.green,
                          ),
                          border: InputBorder.none,
                        ),
                        child: new DropdownButton<String>(
                            hint: Text('Choisir un opérateur'),
                            onChanged: (String changedValue) {
                              gabonValue=changedValue;
                              setState(() {
                                idenValue = gabonValue;
                                print("### IDEN VALUE ### ${idenValue}");
                              });
                            },
                            value: gabonValue,
                            items: operateurGabon.map((item) {
                              return new DropdownMenuItem<String>(
                                value: item.value,
//                                  child: new Text(operateur.value),
                                child:  new SizedBox(
                                    width: MediaQuery.of(context).size.width-105,
                                    child: new Text(item.value)
                                ),
                              );
                            }).toList()),
                      ),
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                    visible: gabonVisibility,
                  ),
                  Visibility(
                    child: StreamBuilder<String>(
                        stream: _transfertCompteVirtuelFormBloc.mobile,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          return Container(
                            child: TextFormField(
                              decoration: new InputDecoration(labelText: "MOBILE", prefixText: indicatifPays,),
                              controller: _mobileController,
                              validator: (val) => val.length < 0  ? 'MOBILE INVALIDE' : null,
                              keyboardType: TextInputType.number,
                            ),
                            padding: EdgeInsets.only(bottom: 15.0),
                          );
                        }
                    ),
                    visible: bgfiVisibility,
                  ),
                  Visibility(
                    child: StreamBuilder<String>(
                        stream: _transfertCompteVirtuelFormBloc.mobile,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          return Container(
                            child: TextFormField(
                              decoration: new InputDecoration(labelText: "COMPTE DESTINATAIRE",),
                              controller: _mobileGimacController,
                              validator: (val) => val.length < 0  ? 'COMPTE DESTINATAIRE INVALIDE' : null,
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.only(bottom: 15.0),
                          );
                        }
                    ),
                    visible: gimacVisibility,
                  ),
                  StreamBuilder<String>(
                      stream: _transfertCompteVirtuelFormBloc.montant,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                      stream: _transfertCompteVirtuelFormBloc.submitValidation,
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
                                onPressed:(load == false)
                                    ? () {
                                  final form = formKey.currentState;
                                  if (form.validate()) {
                                    form.save();
                                    if(isgimac == "yes"){
                                      if(_mobileGimacController.text.length<1){
                                        Utils.dialog(context, "Longueur mobile incorrecte", 'ERREUR', false);
                                      }else{
                                        _transfertCompteVirtuelBloc.emitEvent(Post(secret: _secretController.text, compteBeneficiaire: _mobileGimacController.text, montant: double.parse(_montantController.text), iden: idenValue));
                                      }
                                    }else{
                                      if(_mobileController.text.length<9){
                                        Utils.dialog(context, "Longueur mobile incorrecte", 'ERREUR', false);
                                      }else{
                                        _transfertCompteVirtuelBloc.emitEvent(Post(secret: _secretController.text, compteBeneficiaire: _mobileController.text, montant: double.parse(_montantController.text), iden: "xxx"));
                                      }
                                    }
                                  }
                                }
                                : null,
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

    return BlocEventStateBuilder<TransfertCompteVirtuelState>(
      bloc: _transfertCompteVirtuelBloc,
      builder: (BuildContext context, TransfertCompteVirtuelState state) {
        if(state is TransfertCompteVirtuelInitialized) {
          load = true;
        }
        if(state is TransfertCompteVirtuelLoaded) {
          load = false;
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertDialogWithDivider(context, yyDialog, "CONFIRMATION", state.nfConfirmResponse.recaps, ()=> confirmer(state.nfConfirmResponse.idtransaction, 1,state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token), false);
          });
        }
        if(state is TransfertCompteVirtuelConfirm) {
          load = false;
          _secretController.text = "";
          _montantController.text = "";
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertInfoDialogWithDivider(context, "INFOS", yyDialog, state.nfConfirmResponse.recaps);
          });
        }
        if(state is TransfertCompteVirtuelError) {
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
        return ListView(children: <Widget>[Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(child: form()),
        )], shrinkWrap: true,);
      },
    );
  }

  confirmer(String transaction, int action, String token) {
    load = true;
    _transfertCompteVirtuelBloc.emitEvent(Confirm(id: transaction, action: action, token: token, isgimac: isgimac));
  }

}
