
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gui/blocs/bgfi_express/bgfi_express_bloc.dart';
import 'package:gui/blocs/bgfi_express/bgfi_express_event.dart';
import 'package:gui/blocs/bgfi_express/bgfi_express_form_bloc.dart';
import 'package:gui/blocs/bgfi_express/bgfi_express_state.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/tools/chasingdots.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';

class BgfiExpressPage extends StatefulWidget {
  @override
  _BgfiExpressPageState createState() => _BgfiExpressPageState();
}

class _BgfiExpressPageState extends State<BgfiExpressPage> {

  BgfiExpressBloc _bgfiExpressBloc ;

  BgfiExpressFormBloc _bgfiExpressFormBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NFDetailsInfo> _paysList = [
    NFDetailsInfo(label: '0CM', value: 'CAMEROUN'),
    NFDetailsInfo(label: '0CF', value: 'CENTRAFRIQUE'),
    NFDetailsInfo(label: '0CG', value: 'CONGO (BRAZZAVILLE)'),
    NFDetailsInfo(label: '0GA', value: 'GABON'),
    NFDetailsInfo(label: '0GQ', value: 'GUINEE EQUATORIALE'),
    NFDetailsInfo(label: '0TD', value: 'TCHAD'),
  ];
  String _val;
  bool load = false;
  var yyDialog = YYDialog();

  TextEditingController _secretController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _paysController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _reponseController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _bgfiExpressBloc = BgfiExpressBloc();
    _bgfiExpressFormBloc = BgfiExpressFormBloc();
    super.initState();
  }

  @override
  void dispose() {
    _bgfiExpressFormBloc?.dispose();
    _secretController?.dispose();
    _montantController?.dispose();
    _mobileController?.dispose();
    _paysController?.dispose();
    _nomController?.dispose();
    _prenomController?.dispose();
    _questionController?.dispose();
    _reponseController?.dispose();
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
                      stream: _bgfiExpressFormBloc.secret,
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
                      stream: _bgfiExpressFormBloc.pays,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container (
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
//                            child: new DropdownButtonHideUnderline(
//                              child: new DropdownButton<String>(
//                                value: _val,
//                                isDense: true,
//                                onChanged: (value) {
//                                  setState(() {
//                                    _val = value;
//                                  });
//                                  _bgfiExpressFormBloc.onPaysChanged(value);
//                                },
//                                items: _paysList.map((NFDetailsInfo pays) {
//                                  return new DropdownMenuItem<String>(
//                                    value: pays.label,
//                                    child: new Text(pays.value),
//                                  );
//                                }).toList(),
//                              ),
//                            ),
                            child: new DropdownButton<String>(
                                hint: Text('Choisir un pays'),
                                onChanged: (String changedValue) {
                                  _val=changedValue;
                                  setState(() {
                                    _val;
                                    print(_val);
                                  });
                                },
                                value: _val,
                                items: _paysList.map((pays) {
                                  return new DropdownMenuItem<String>(
                                    value: pays.label,
//                                  child: new Text(operateur.value),
                                    child:  new SizedBox(
                                        width: MediaQuery.of(context).size.width-105,
                                        child: new Text(pays.value)
                                    ),
                                  );
                                }).toList()),
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),
                  StreamBuilder<String>(
                      stream: _bgfiExpressFormBloc.prenom,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "PRENOM BENEFICIAIRE"),
                            controller: _prenomController,
                            validator: (val) => val.length<1 ? 'PRENOM BENEFICIAIRE INVALIDE' : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),
                  StreamBuilder<String>(
                      stream: _bgfiExpressFormBloc.nom,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "NOM BENEFICIAIRE"),
                            controller: _nomController,
                            validator: (val) => val.length<1 ? 'NOM BENEFICIAIRE INVALIDE' : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),
                  StreamBuilder<String>(
                      stream: _bgfiExpressFormBloc.mobile,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "MOBILE", prefixText: "237",),
                            controller: _mobileController,
                            validator: (val) => val.length!=9 ? 'MOBILE INVALIDE' : null,
                            keyboardType: TextInputType.number,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),
                  StreamBuilder<String>(
                      stream: _bgfiExpressFormBloc.montant,
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
                  StreamBuilder<String>(
                      stream: _bgfiExpressFormBloc.question,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "QUESTION SECRETE"),
                            controller: _questionController,
                            validator: (val) => val.length<1 ? 'QUESTION SECRETE' : null,
                            keyboardType: TextInputType.text,
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }
                  ),
                  StreamBuilder<String>(
                      stream: _bgfiExpressFormBloc.reponse,
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: TextFormField(
                            decoration: new InputDecoration(labelText: "REPONSE"),
                            controller: _reponseController,
                            validator: (val) => val.length<1 ? 'REPONSE INVALIDE' : null,
                            keyboardType: TextInputType.text,
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
                      stream: _bgfiExpressFormBloc.submitValidation,
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
//                                onPressed: ((){
//                                  final form = formKey.currentState;
//                                  if (form.validate() && formValidate()) {
//                                    form.save();
//                                    _bgfiExpressBloc.emitEvent(Post(secret: _secretController.text, montant: double.parse(_montantController.text,), mobile: _mobileController.text, pays: _val, nom: _nomController.text, prenom: _prenomController.text, question: _questionController.text, reponse: _reponseController.text));
//                                  }
//                                }),
                                onPressed:(load == false)
                                    ? () {
                                  final form = formKey.currentState;
                                  if (form.validate() && formValidate()) {
                                    form.save();
                                    _bgfiExpressBloc.emitEvent(Post(secret: _secretController.text, montant: double.parse(_montantController.text,), mobile: _mobileController.text, pays: _val, nom: _nomController.text, prenom: _prenomController.text, question: _questionController.text, reponse: _reponseController.text));
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

    return BlocEventStateBuilder<BgfiExpressState>(
      bloc: _bgfiExpressBloc,
      builder: (BuildContext context, BgfiExpressState state) {
        if(state is BgfiExpressInitialized) {
          load = true;
        }
        if(state is BgfiExpressLoaded) {
          load = false;
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertDialogWithDivider(context, yyDialog, "CONFIRMATION", state.nfConfirmResponse.recaps, ()=> confirmer(state.nfConfirmResponse.idtransaction, 1,state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token), false);
          });
        }
        if(state is BgfiExpressConfirm) {
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertInfoDialogWithDivider(context, "INFOS", yyDialog, state.nfConfirmResponse.recaps);
          });
          _secretController.text= '';
          load = false;
        }
        if(state is BgfiExpressError) {
          load = false;
//          Utils.dialog(context, state.error, 'ERREUR', false);
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
        return ListView(children: <Widget>[Center(child: form())], shrinkWrap: true,);
      },
    );
  }

  confirmer(String transaction, int action, String token) {
    load = true;
    _bgfiExpressBloc.emitEvent(Confirm(id: transaction, action: action, token: token));
  }

  bool formValidate(){
    if(_val == null){
      Utils.dialog(context, "Vous devez choisir un pays !", "ERREUR", true);
      return false;
    }
    return true;
  }
}
