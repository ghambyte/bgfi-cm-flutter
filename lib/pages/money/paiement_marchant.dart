
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/paiement_marchant/paiement_marchant_bloc.dart';
import 'package:gui/blocs/paiement_marchant/paiement_marchant_form_bloc.dart';
import 'package:gui/blocs/paiement_marchant/paiement_marchant_state.dart';
import 'package:gui/blocs/paiement_marchant/paiment_marchant_event.dart';
import 'package:gui/tools/chasingdots.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class PaiementMarchantPage extends StatefulWidget {
  @override
  _PaiementMarchantPageState createState() => _PaiementMarchantPageState();
}

class _PaiementMarchantPageState extends State<PaiementMarchantPage> {

  PaiementMarchantBloc _paiementMarchantBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _secretController = TextEditingController();
  TextEditingController _montantController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  PaiementMarchantFormBloc _paiementMarchantFormBloc ;

  String ok ='';
  bool load = false;
  var yyDialog = YYDialog();

  @override
  void initState() {
    // TODO: implement initState
    _paiementMarchantBloc = PaiementMarchantBloc();
    _paiementMarchantFormBloc = PaiementMarchantFormBloc();
    super.initState();
  }

  @override
  void dispose() {
    _paiementMarchantFormBloc?.dispose();
    _secretController?.dispose();
    _montantController?.dispose();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<String>(
                    stream: _paiementMarchantFormBloc.secret,
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
                    stream: _paiementMarchantFormBloc.codeMarchant,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Container(
                        child: TextFormField(
                          decoration: new InputDecoration(labelText: "CODE MARCHAND", suffixIcon: IconButton(icon:Icon(Icons.photo_camera, color: ColorApp.blue,), onPressed: ()=> scanQR())),
                          controller: _codeController,
                          validator: (val) => val.length<1 ? 'CODE MARCHAND' : null,
                          keyboardType: TextInputType.number,
                        ),
                        padding: EdgeInsets.only(bottom: 15.0),
                      );
                    }
                ),
                StreamBuilder<String>(
                    stream: _paiementMarchantFormBloc.montant,
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
                    stream: _paiementMarchantFormBloc.submitValidation,
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
                                  _paiementMarchantBloc.emitEvent(Post(secret: _secretController.text, montant: double.parse(_montantController.text,), code: _codeController.text));
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

    return BlocEventStateBuilder<PaiementMarchantState>(
      bloc: _paiementMarchantBloc,
      builder: (BuildContext context, PaiementMarchantState state) {
        if(state is PaiementMarchantInitialized) {
          load = true;
        }
        if(state is PaiementMarchantLoaded) {
          load = false;
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertDialogWithDivider(context, yyDialog, "CONFIRMATION", state.nfConfirmResponse.recaps, ()=> confirmer(state.nfConfirmResponse.idtransaction, 1,state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token), false);
          });
        }
        if(state is PaiementMarchantConfirm) {
          load = false;
          _secretController.text='';
          _montantController.text ='';
          Utils.onWidgetDidBuild(() {
            yyDialog = YYDialog();
            return Utils.YYAlertInfoDialogWithDivider(context, "INFOS", yyDialog, state.nfConfirmResponse.recaps);
          });
        }
        if(state is PaiementMarchantError) {
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
    _paiementMarchantBloc.emitEvent(Confirm(id: transaction, action: action, token: token));
  }

}
