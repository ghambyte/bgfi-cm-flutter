
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/fenix/fenix_bloc.dart';
import 'package:gui/blocs/fenix/fenix_event.dart';
import 'package:gui/blocs/fenix/fenix_form_bloc.dart';
import 'package:gui/blocs/fenix/fenix_state.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/utils.dart';

class FenixPage extends StatefulWidget {
  @override
  _FenixPageState createState() => _FenixPageState();
}

class _FenixPageState extends State<FenixPage> {

  FenixBloc _fenixBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _secretController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();

  FenixFormBloc _fenixFormBloc ;

  String ok ='';

  @override
  void initState() {
    // TODO: implement initState
    _fenixBloc = FenixBloc();
    _fenixFormBloc = FenixFormBloc();
    super.initState();
  }

  @override
  void dispose() {
    _fenixFormBloc?.dispose();
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
                    stream: _fenixFormBloc.secret,
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
                    stream: _fenixFormBloc.reference,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Container(
                        child: TextFormField(
                          decoration: new InputDecoration(labelText: "REFERENCE"),
                          controller: _referenceController,
                          validator: (val) => val.length<1 ? 'REFERENCE INVALIDE' : null,
                          keyboardType: TextInputType.number,
                        ),
                        padding: EdgeInsets.only(bottom: 15.0),
                      );
                    }
                ),
                StreamBuilder<bool>(
                    stream: _fenixFormBloc.submitValidation,
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
//                                    _fenixBloc.emitEvent(Post(secret: _secretController.text, reference: _referenceController.text));
//                                print(_referenceController.text);
//                                print(_secretController.text);
//                                    print("ACTION SUBMIT");
//                                  } :null,
                              onPressed: ((){
                                final form = formKey.currentState;
                                if (form.validate()) {
                                  form.save();
                                  _fenixBloc.emitEvent(Post(secret: _secretController.text, reference: _referenceController.text));
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

    return BlocEventStateBuilder<FenixState>(
      bloc: _fenixBloc,
      builder: (BuildContext context, FenixState state) {
        if(state is FenixInitialized) {
          if(state.confirm) {
            Utils.onWidgetDidBuild(() {
              Navigator.pop(context);
            });
          }
          Utils.showDialogProgress(context, 'Requete en cours ...');
        }
        if(state is FenixLoaded) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            Utils.alertConfirm(context, "CONFIRMATION", state.nfConfirmResponse.recaps, "VALIDER", ()=> confirmer(state.nfConfirmResponse.idtransaction,1, state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction,0, state.nfConfirmResponse.token));
          });
        }
        if(state is FenixConfirm) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            Utils.alertConfirm(context, "FELICITATION", state.nfConfirmResponse.recaps, "Fermer", ()=> Navigator.pop(context), () => Navigator.pop(context), isfermer: false);
            setState(() {
              _secretController.text= '';
            });
          });
        }
        if(state is FenixError) {
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

  confirmer(String transaction, int action,  String token) {
    _fenixBloc.emitEvent(Confirm(id: transaction, token: token, action: action));
  }

}
