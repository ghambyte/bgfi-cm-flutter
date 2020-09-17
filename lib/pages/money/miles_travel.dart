
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/miles_travel/miles_travel_bloc.dart';
import 'package:gui/blocs/miles_travel/miles_travel_event.dart';
import 'package:gui/blocs/miles_travel/miles_travel_form_bloc.dart';
import 'package:gui/blocs/miles_travel/miles_travel_state.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/utils.dart';

class MilesTravelPage extends StatefulWidget {
  @override
  _MilesTravelPageState createState() => _MilesTravelPageState();
}

class _MilesTravelPageState extends State<MilesTravelPage> {

  MilesTravelBloc _milesTravelBloc ;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _secretController = TextEditingController();
  TextEditingController _montantController = TextEditingController();

  MilesTravelFormBloc _milesTravelFormBloc ;

  String ok ='';

  @override
  void initState() {
    // TODO: implement initState
    _milesTravelBloc = MilesTravelBloc();
    _milesTravelFormBloc = MilesTravelFormBloc();
    super.initState();
  }

  @override
  void dispose() {
    _milesTravelFormBloc?.dispose();
    _secretController?.dispose();
    _montantController?.dispose();
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
                      stream: _milesTravelFormBloc.secret,
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
                      stream: _milesTravelFormBloc.montant,
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
                  StreamBuilder<bool>(
                      stream: _milesTravelFormBloc.submitValidation,
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
//                                onPressed: (snapshot.hasData && snapshot.data == true)
//                                    ? (){
//                                  _milesTravelBloc.emitEvent(Post(secret: _secretController.text, montant: double.parse(_montantController.text,)));
//                                  print("ACTION SUBMIT");
//                                } :null,
                                onPressed: ((){
                                  final form = formKey.currentState;
                                  if (form.validate()) {
                                    form.save();
                                    _milesTravelBloc.emitEvent(Post(secret: _secretController.text, montant: double.parse(_montantController.text,)));
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

    return BlocEventStateBuilder<MilesTravelState>(
      bloc: _milesTravelBloc,
      builder: (BuildContext context, MilesTravelState state) {
        if(state is MilesTravelInitialized) {
          if(state.confirm) {
            Utils.onWidgetDidBuild(() {
              Navigator.pop(context);
            });
          }
          Utils.showDialogProgress(context, 'Requete en cours ...');
        }
        if(state is MilesTravelLoaded) {
          print('BABACAR------- ${state.nfConfirmResponse.idtransaction}');
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            Utils.alertConfirm(context, "CONFIRMATION", state.nfConfirmResponse.recaps, "VALIDER", ()=> confirmer(state.nfConfirmResponse.idtransaction, 1, state.nfConfirmResponse.token), () => confirmer(state.nfConfirmResponse.idtransaction, 0, state.nfConfirmResponse.token));
          });
        }
        if(state is MilesTravelConfirm) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            setState(() {
              _secretController.text='';
              _montantController.text ='';
            });
            Utils.alertConfirm(context, "FELICITATION", state.nfConfirmResponse.recaps, "Fermer", ()=> Navigator.pop(context), () => Navigator.pop(context), isfermer: false);
          });
        }
        if(state is MilesTravelError) {
          Utils.onWidgetDidBuild(() {
            Navigator.pop(context);
            setState(() {
              _secretController.text='';
              _montantController.text ='';
            });
          });
          Utils.dialog(context, state.error, 'CONFIRMATION', false);
        }
        return ListView(children: <Widget>[Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(child: form()),
        )], shrinkWrap: true,);
      },
    );
  }

  confirmer(String transaction, int action, String token) {
    _milesTravelBloc.emitEvent(Confirm(id: transaction, action: action, token: token));
  }

}
