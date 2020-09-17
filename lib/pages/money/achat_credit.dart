
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gui/blocs/achat_credit/achat_credit_bloc.dart';
import 'package:gui/blocs/achat_credit/achat_credit_event.dart';
import 'package:gui/blocs/achat_credit/achat_credit_form_bloc.dart';
import 'package:gui/blocs/achat_credit/achat_credit_state.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/models/nf_tcv_info.dart';
import 'package:gui/tools/chasingdots.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';

class AchatCreditPage extends StatefulWidget {
  @override
  _AchatCreditPageState createState() => _AchatCreditPageState();
}

class _AchatCreditPageState extends State<AchatCreditPage> {

  AchatCreditBloc _achatCreditBloc ;

  AchatCreditFormBloc _achatCreditFormBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  List<NFDetailsInfo> operateurs = [
    NFDetailsInfo(label: 'ORG', value: 'ORANGE'),
    NFDetailsInfo(label: 'MTN', value: 'MTN'),
  ];

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
    NFDetailsInfo(label: 'ORG', value: 'ORANGE'),
    NFDetailsInfo(label: 'MTN', value: 'MTN'),
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

  List<NFTCVInfo> pays = [
    NFTCVInfo(label: 'GABON', value: 'GAB', code: "241"),
    NFTCVInfo(label: 'CONGO', value: 'CON', code: "242"),
    NFTCVInfo(label: 'CAMEROUN', value: 'CAM', code: "237"),
    NFTCVInfo(label: 'GUINEE EQUATORIALE', value: 'GUE', code: "240"),
  ];

  TextEditingController _secretController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _carrierController = TextEditingController();

  var yyDialog = YYDialog();

  @override
  void initState() {
    // TODO: implement initState
    _achatCreditBloc = AchatCreditBloc();
    _achatCreditFormBloc = AchatCreditFormBloc();
    super.initState();
  }

  @override
  void dispose() {
    _secretController?.dispose();
    _montantController?.dispose();
    _mobileController?.dispose();
    _carrierController?.dispose();
    _achatCreditFormBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    YYDialog.init(context);

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
              margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<String>(
                      stream: _achatCreditFormBloc.secret,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: "CODE SECRET",),
                            controller: _secretController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val.length!=4 ? 'CODE SECRET INVALIDE' : null,
                            obscureText: true,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),
//                  StreamBuilder<String>(
//                      stream: _achatCreditFormBloc.mobile,
//                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                        return Container (
//                          child: new InputDecorator(
//                            decoration: InputDecoration(
//                              labelText: 'DESTINATAIRE',
//                              labelStyle: new TextStyle(
//                                fontSize: 13.0,
//                                fontWeight: FontWeight.bold,
//                                color: ColorApp.green,
//                              ),
//                              border: InputBorder.none,
//                            ),
//                            child: new DropdownButton<String>(
//                                hint: Text('Choisir un destinataire'),
//                                onChanged: (String changedValue) {
//                                  newValue=changedValue;
//                                  setState(() {
//                                    newValue;
//                                    if(newValue == 'GIMAC'){
//                                      isgimac = "yes";
//                                      gimacVisibility = true;
//                                    }else{
//                                      isgimac = "no";
//                                      indicatifPays = "241";
//                                      gimacVisibility = false;
//                                    }
//                                    print(newValue);
//                                  });
//                                },
//                                value: newValue,
//                                items: destinataires.map((operateur) {
//                                  return new DropdownMenuItem<String>(
//                                    value: operateur.label,
////                                  child: new Text(operateur.value),
//                                    child:  new SizedBox(
//                                        width: MediaQuery.of(context).size.width-105,
//                                        child: new Text(operateur.value)
//                                    ),
//                                  );
//                                }).toList()),
//                          ),
//                          padding: EdgeInsets.only(bottom: 5.0),
//                        );
//                      }
//                  ),
//                  Visibility(
//                    child: Container (
//                      child: new InputDecorator(
//                        decoration: InputDecoration(
//                          labelText: 'PAYS',
//                          labelStyle: new TextStyle(
//                            fontSize: 13.0,
//                            fontWeight: FontWeight.bold,
//                            color: ColorApp.green,
//                          ),
//                          border: InputBorder.none,
//                        ),
//                        child: new DropdownButton<String>(
//                            hint: Text('Choisir un pays'),
//                            onChanged: (String changedValue) {
//                              paysValue=changedValue;
//                              setState(() {
//                                switch (paysValue) {
//                                  case "GABON":
//                                    {
//                                      indicatifPays = "241";
//                                      operateurList = operateurGabon;
//                                      camerounVisibility = false;
//                                      gabonVisibility = true;
//                                      congoVisibility = false;
//                                      guiVisibility = false;
//                                    }
//                                    break;
//
//                                  case "CONGO":
//                                    {
//                                      indicatifPays = "242";
//                                      operateurList = operateurCongo;
//                                      camerounVisibility = false;
//                                      gabonVisibility = false;
//                                      congoVisibility = true;
//                                      guiVisibility = false;
//                                    }
//                                    break;
//
//                                  case "CAMEROUN":
//                                    {
//                                      indicatifPays = "237";
//                                      operateurList = operateurCameroun;
//                                      camerounVisibility = true;
//                                      gabonVisibility = false;
//                                      congoVisibility = false;
//                                      guiVisibility = false;
//                                    }
//                                    break;
//
//                                  case "GUINEE EQUATORIALE":
//                                    {
//                                      indicatifPays = "240";
//                                      operateurList = operateurGui;
//                                      camerounVisibility = false;
//                                      gabonVisibility = false;
//                                      congoVisibility = false;
//                                      guiVisibility = true;
//                                    }
//                                    break;
//
//                                  default:
//                                    {
//                                      indicatifPays = "241";
//                                    }
//                                }
//                              });
//                            },
//                            value: paysValue,
//                            items: paysList.map((item) {
//                              return new DropdownMenuItem<String>(
//                                value: item.label,
////                                  child: new Text(operateur.value),
//                                child:  new SizedBox(
//                                    width: MediaQuery.of(context).size.width-105,
//                                    child: new Text(item.label)
//                                ),
//                              );
//                            }).toList()),
//                      ),
//                      padding: EdgeInsets.only(bottom: 5.0),
//                    ),
//                    visible: gimacVisibility,
//                  ),
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
                    visible: congoVisibility,
                  ),
                  StreamBuilder<String>(
                      stream: _achatCreditFormBloc.carrier,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container (
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
                                  newValue=changedValue;
                                  setState(() {
                                    newValue;
                                    print(newValue);
                                  });
                                },
                                value: newValue,
                                items: operateurs.map((operateur) {
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
                        stream: _achatCreditFormBloc.mobile,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          return Container(
                            child: TextFormField(
                              decoration: new InputDecoration(
                                labelText: "NUMERO TELEPHONE",
                                fillColor: ColorApp.green,
                                labelStyle: new TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                prefixText: indicatifPays,
                              ),
                              controller: _mobileController,
                              keyboardType: TextInputType.number,
                              validator: (val) => val.length!=9 ? 'MOBILE INVALIDE' : null,
                            ),
                            padding: EdgeInsets.only(bottom: 15.0),
                          );
                        }
                    ),
                    visible: true,
                  ),
                  StreamBuilder<String>(
                      stream: _achatCreditFormBloc.montant,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "MONTANT"),
                            controller: _montantController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val.length<1 ? 'MONTANT INVALIDE' : null,
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
                      stream: _achatCreditFormBloc.submitValidation,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return StreamBuilder<String>(
                            stream: _achatCreditFormBloc.mobile,
                            builder: (BuildContext context, AsyncSnapshot<String> mobile){
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new RaisedButton(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                                      textColor: Colors.white,
                                      color: ColorApp.green,
                                      disabledColor: ColorApp.darkGreen,
                                      disabledTextColor: Colors.white,
//                                      onPressed: ((){
//                                        final form = formKey.currentState;
//                                        if (form.validate() && formValidate()) {
//                                          form.save();
//                                          _achatCreditBloc.emitEvent(Post(
//                                              secret: _secretController.text,
//                                              montant: double.parse(_montantController.text,),
//                                              carrier: newValue,
//                                              mobile: _mobileController.text));
//                                        }
//                                      }),
                                      onPressed:(load == false)
                                          ? () {
                                        final form = formKey.currentState;
                                        if (form.validate() && formValidate()) {
                                          form.save();
                                          _achatCreditBloc.emitEvent(Post(
                                              secret: _secretController.text,
                                              montant: double.parse(_montantController.text,),
                                              carrier: newValue,
                                              mobile: _mobileController.text));
                                        }
                                      }
                                          : null,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(
                                              30.0)),
                                      child: new Text("VALIDER"),
                                    )
                                  ]
                              );
                            }
                        );
                      }
                  ),
                ],
              ),
            )
        ),
      );
    }

    return BlocEventStateBuilder<AchatCreditState>(
      bloc: _achatCreditBloc,
      builder: (BuildContext context, AchatCreditState state) {
        if (state is AchatCreditInitialized) {
          load = true;
        }
        if (state is AchatCreditLoaded) {
          load = false;
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertDialogWithDivider(context, yyDialog, "CONFIRMATION", state.nfConfirmResponse.recaps, ()=> confirmer(state.nfConfirmResponse.idtransaction, 1,state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token), false);
          });
        }
        if (state is AchatCreditConfirm) {
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertInfoDialogWithDivider(context, "INFOS", yyDialog, state.nfConfirmResponse.recaps);
          });
          load = false;
          _secretController.text = '';
          _montantController.text = '';
        }
        if (state is AchatCreditError) {
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
        )
        ], shrinkWrap: true,);
      },
    );
  }

  confirmer(String transaction, int action, String token) {
    load = true;
    _achatCreditBloc.emitEvent(Confirm(id: transaction, action: action, token: token));
  }

  void handleTypeAboChange(Object value) {
    setState(() {
      typeabo = value;
      if(typeabo == '1'){
        gimacVisibility = true;
      }else{
        gimacVisibility = false;
      }
    });
  }

  bool formValidate(){
    if(newValue == null){
      Utils.dialog(context, "Vous devez choisir un opérateur !", "ERREUR", true);
      return false;
    }
    return true;
  }
}
