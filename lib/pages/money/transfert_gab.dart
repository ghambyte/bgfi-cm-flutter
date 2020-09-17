
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/transfert_gab/transfert_gab_bloc.dart';
import 'package:gui/blocs/transfert_gab/transfert_gab_event.dart';
import 'package:gui/blocs/transfert_gab/transfert_gab_form_bloc.dart';
import 'package:gui/blocs/transfert_gab/transfert_gab_state.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/models/nf_tcv_info.dart';
import 'package:gui/tools/chasingdots.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class TransfertGabPage extends StatefulWidget {
  @override
  _TransfertGabPageState createState() => _TransfertGabPageState();
}

class _TransfertGabPageState extends State<TransfertGabPage> with MAppBar {

  TransfertGabBloc _transfertGabBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _secretController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  TransfertGabFormBloc _transfertGabFormBloc ;

  String ok ='';
  String newValue;
  String paysValue;
  String typeabo = "0";
  String indicatifPays = "237";
  String isgimac = "";
  bool load = false;
  var yyDialog = YYDialog();
  bool gimacVisibility = false;
  var changeFormuleEnabled = false;
  List<NFDetailsInfo> operateurs = [
    NFDetailsInfo(label: 'BGFI', value: 'BGFI'),
    NFDetailsInfo(label: 'GIMAC', value: 'GIMAC'),
  ];

  List<NFTCVInfo> pays = [
    NFTCVInfo(label: 'GABON', value: 'GAB', code: "241"),
    NFTCVInfo(label: 'CONGO', value: 'CON', code: "242"),
    NFTCVInfo(label: 'CAMEROUN', value: 'CAM', code: "237"),
    NFTCVInfo(label: 'GUINEE EQUATORIALE', value: 'GUE', code: "240"),
  ];
  List<Widget> v = [];

  @override
  void initState() {
    // TODO: implement initState
    _transfertGabBloc = TransfertGabBloc();
    _transfertGabFormBloc = TransfertGabFormBloc();
//    buildRow();
    super.initState();
  }

  @override
  void dispose() {
    _transfertGabFormBloc?.dispose();
    _secretController?.dispose();
    _montantController?.dispose();
    _mobileController?.dispose();
    _codeController?.dispose();
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
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder<String>(
                          stream: _transfertGabFormBloc.secret,
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
                      StreamBuilder<String>(
                          stream: _transfertGabFormBloc.mobile,
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
                                        }else{
                                          isgimac = "no";
                                          indicatifPays = "237";
                                          gimacVisibility = false;
                                        }
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
                      StreamBuilder<String>(
                          stream: _transfertGabFormBloc.montant,
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
                          stream: _transfertGabFormBloc.submitValidation,
                          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                            return StreamBuilder<String>(
                                stream: _transfertGabFormBloc.mobile,
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
                                          onPressed:(load == false)
                                              ? () {
                                            final form = formKey.currentState;
                                            if (form.validate() && formValidate()) {
                                              form.save();
                                              _transfertGabBloc.emitEvent(Post(secret: _secretController.text, montant: double.parse(_montantController.text,), isgimac: isgimac, numdest: ""));
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
            )
        ),
      );
    }

    return BlocEventStateBuilder<TransfertGabState>(
      bloc: _transfertGabBloc,
      builder: (BuildContext context, TransfertGabState state) {
        if(state is TransfertGabInitialized) {
          load = true;
        }
        if(state is TransfertGabLoaded) {
          load = false;
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertDialogWithDivider(context, yyDialog, "CONFIRMATION", state.nfConfirmResponse.recaps, ()=> confirmer(state.nfConfirmResponse.idtransaction, 1,state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token), false);
          });
        }
        if(state is TransfertGabConfirm) {
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertInfoDialogWithDivider(context, "INFOS", yyDialog, state.nfConfirmResponse.recaps);
          });
          _secretController.text= '';
          load = false;
        }
        if(state is TransfertGabError) {
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

  Future scanQR() async {
    Future<String> futureString = new QRCodeReader().scan();
    futureString.then((value){
      setState(() {
        _codeController.text = value;
      });
    });
  }

  confirmer(String transaction, int action, String token) {
    load = true;
    _transfertGabBloc.emitEvent(Confirm(id: transaction, action: action, isgimac: isgimac, token: token));
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
