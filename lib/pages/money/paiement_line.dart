
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/paiement_ligne/paiement_ligne_bloc.dart';
import 'package:gui/blocs/paiement_ligne/paiement_ligne_event.dart';
import 'package:gui/blocs/paiement_ligne/paiement_ligne_form_bloc.dart';
import 'package:gui/blocs/paiement_ligne/paiement_ligne_state.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/utils.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class PaiementLinePage extends StatefulWidget {
  @override
  _PaiementLinePageState createState() => _PaiementLinePageState();
}

class _PaiementLinePageState extends State<PaiementLinePage> {

  PaiementLineBloc _paiementLineBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _secretController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();

  PaiementLineFormBloc _paiementLineFormBloc ;

  String ok ='';

  @override
  void initState() {
    // TODO: implement initState
    _paiementLineBloc = PaiementLineBloc();
    _paiementLineFormBloc = PaiementLineFormBloc();
    super.initState();
  }

  @override
  void dispose() {
    _paiementLineFormBloc?.dispose();
    _secretController?.dispose();
    _referenceController?.dispose();
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
                    stream: _paiementLineFormBloc.secret,
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
                    stream: _paiementLineFormBloc.reference,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Container(
                        child: TextFormField(
                          decoration: new InputDecoration(labelText: "REFERENCE", suffixIcon: IconButton(icon:Icon(Icons.photo_camera, color: ColorApp.blue,), onPressed: ()=> scanQR())),
                          controller: _referenceController,
                          validator: (val) => val.length<1 ? 'REFERENCE INVALIDE' : null,
                          keyboardType: TextInputType.number,
                        ),
                        padding: EdgeInsets.only(bottom: 15.0),
                      );
                    }
                ),
                StreamBuilder<bool>(
                    stream: _paiementLineFormBloc.submitValidation,
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
//                              onPressed: (snapshot.hasData && snapshot.data == true)
//                                ? (){
//                                    _paiementLineBloc.emitEvent(Post(secret: _secretController.text, reference: _referenceController.text));
//                                    print("ACTION SUBMIT");
//                                  } :null,
                              onPressed: ((){
                                final form = formKey.currentState;
                                if (form.validate()) {
                                  form.save();
                                  _paiementLineBloc.emitEvent(Post(secret: _secretController.text, reference: _referenceController.text));
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

    return BlocEventStateBuilder<PaiementLineState>(
      bloc: _paiementLineBloc,
      builder: (BuildContext context, PaiementLineState state) {
        if(state is PaiementLineInitialized) {
          if(state.confirm) {
            Utils.onWidgetDidBuild(() {
              Navigator.pop(context);
            });
          }
          Utils.showDialogProgress(context, 'Requete en cours ...');
        }
        if(state is PaiementLineLoaded) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            Utils.alertConfirm(context, "CONFIRMATION", state.nfConfirmResponse.recaps, "VALIDER", ()=> confirmer(state.nfConfirmResponse.idtransaction,state.nfConfirmResponse.token), () => Navigator.pop(context));
          });
        }
        if(state is PaiementLineConfirm) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            Utils.alertConfirm(context, "FELICITATION", state.nfConfirmResponse.recaps, "Fermer", ()=> Navigator.pop(context), () => Navigator.pop(context), isfermer: false);
            setState(() {
              _secretController.text= '';
            });
          });
        }
        if(state is PaiementLineError) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
          });
          Utils.dialog(context, state.error, 'CONFIRMATION', false);
          Utils.onWidgetDidBuild((){
            setState(() {
              _secretController.text= '';
            });
          });
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
            _referenceController.text = value;
          });
      });
  }

  confirmer(String transaction, String token) {
    _paiementLineBloc.emitEvent(Confirm(id: transaction, token: token));
  }

}
