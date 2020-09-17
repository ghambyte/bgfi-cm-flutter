
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/virements_banque/virements_banque_bloc.dart';
import 'package:gui/blocs/virements_banque/virements_banque_event.dart';
import 'package:gui/blocs/virements_banque/virements_banque_state.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/utils.dart';

class ItemBankingBeneficiaireToggle extends StatelessWidget {

  final bool leading;
  final String title;
  final String trailing;
  final VirementsBanqueBloc virementsBanqueBloc;

  ItemBankingBeneficiaireToggle({this.leading, this.title, this.trailing, this.virementsBanqueBloc});

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {

    return BlocEventStateBuilder<VirementsBanqueState>(
      bloc: virementsBanqueBloc,
      builder: (BuildContext context, VirementsBanqueState state) {
        if (state is VirementsBanqueInitialized) {
          if (state.delete){
//            Utils.showDialogProgress(context, 'Suppression en cours ...');
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.blue)),);
          } else {
//            Utils.showDialogProgress(context, 'Récupération de la liste des bénéficiaires ...');
          }
        }
        if (state is VirementsBanqueError) {
        }
        if (state is VirementsBanqueSuccess) {

        }
        if (state is VirementsBanqueGetPreference) {

        }
        if (state is VirementsBanquePreference) {
          Utils.onWidgetDidBuild(() {
//            Navigator.pop(context);
          });
          Utils.dialog(context, 'Bénéficiaire', 'Bénéficiaire supprimé!', false);
          virementsBanqueBloc
              .emitEvent(GetPreference());
        }
        return ListTile(
          title: Row(
            children: <Widget>[
              leading
                  ? Icon(Icons.expand_less, color: ColorApp.blue,)
                  : Icon(Icons.expand_more, color: ColorApp.blue,),
              Expanded(child: Text('$title', style : new TextStyle(color: ColorApp.darkblue,fontWeight: FontWeight.bold,fontSize:12.0),)),
            ],
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 15.0),
            margin: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
            child: new Text(trailing,
                style : new TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:12.0)
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          dense: true,
          leading: new IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("Supprimer le bénéficiaire $title ?"),
                    actions: <Widget>[
                      new FlatButton(
                          child: new Text("ANNULER", style: new TextStyle(color: Colors.black)),
                          onPressed: (){
                            Navigator.of(context).pop();
                          }
                      ),
                      new FlatButton(
                          child: new Text("VALIDER"),
                          onPressed: (){
                            Navigator.of(context).pop();
                            virementsBanqueBloc
                                .emitEvent(DeletePreference(id: trailing));
                          }
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
