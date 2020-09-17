import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/compte_banque/compte_banque_bloc.dart';
import 'package:gui/blocs/compte_banque/compte_banque_form_bloc.dart';
import 'package:gui/blocs/compte_banque/compte_banque_state.dart';
import 'package:gui/blocs/compte_banque/compte_banque_event.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/pages/banking/journal_compte.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/banking_standard_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';

class CompteBanquePage extends StatefulWidget {
  @override
  _CompteBanqueState createState() => _CompteBanqueState();
}

class _CompteBanqueState extends State<CompteBanquePage> with BankingStandardAppBar, ErrorWideget {
  String _value = '';

  CompteBanqueBloc _compteBanqueBloc = CompteBanqueBloc();

  CompteBanqueFormBloc _compteBanqueFormBloc = CompteBanqueFormBloc();

  LoginBloc _loginBloc;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<NFDetailsInfo> operateurs = [
    NFDetailsInfo(label: 'GET', value: 'GETESA'),
    NFDetailsInfo(label: 'MUN', value: 'MUNI'),
  ];

  List<Compte> comptes;

  Compte compte;

  String nroSelectedCompte;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _compteBanqueBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    getComptes();
//    getAccount();
  }

  @override
  void dispose() {
    _compteBanqueFormBloc?.dispose();
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
              primaryColor: ColorApp.blue,
              hintColor: ColorApp.blue,
              highlightColor: ColorApp.blue,
              accentColor: Colors.black,
              primaryColorDark: ColorApp.blue,
              cursorColor: ColorApp.blue,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<String>(
                      stream: _compteBanqueFormBloc.carrier,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: new InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'COMPTE',
                              labelStyle: new TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: ColorApp.blue,
                              ),
                            ),
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                /*value: (comptes != null && comptes.isNotEmpty)
                                    ? comptes[0]?.numeroCompte
                                    : '',*/
                                value: nroSelectedCompte,
                                isDense: true,
                                //onChanged: _compteBanqueFormBloc.onCarrierChanged,
                                onChanged: (String changedValue) {
                                  setState(() {
                                    nroSelectedCompte = changedValue;
                                    _compteBanqueFormBloc
                                        .onCarrierChanged(nroSelectedCompte);
                                    print(nroSelectedCompte);
                                    compte = comptes.firstWhere((compte) =>
                                        compte.libelleCompte
                                            .startsWith(nroSelectedCompte));
                                  });
                                },
                                items: comptes?.map((compte) {
                                  //this.compte = compte;
                                  return new DropdownMenuItem<String>(
                                    value: compte.libelleCompte,
                                    child: new Text(compte.libelleCompte),
                                  );
                                })?.toList(),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(bottom: 15.0),
                        );
                      }),
                  StreamBuilder<String>(
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Center(
                          child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                verticalDirection: VerticalDirection.down,
                                children: [
                                  Text(
                                    'Titulaire:',
                                    style: TextStyle(
                                        fontSize: 15.0, fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      (compte != null) ? compte.titulaire : '',
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.right,
                                      minFontSize: 12.0,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              )));
                    },
                  ),
                  Divider(),
                  StreamBuilder<String>(
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Center(
                          child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                verticalDirection: VerticalDirection.down,
                                children: [
                                  Text(
                                    'Agence:',
                                    style: TextStyle(
                                        fontSize: 15.0, fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      (compte != null) ? compte.libelleAgence : '',
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.right,
                                      minFontSize: 12.0,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              )));
                    },
                  ),
                  Divider(),
                  StreamBuilder<String>(
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Center(
                          child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                verticalDirection: VerticalDirection.down,
                                children: [
                                  Text(
                                    'Solde:',
                                    style: TextStyle(
                                        fontSize: 15.0, fontWeight: FontWeight.bold),
                                  ),
                                  //Spacer(),
                                  Expanded(
                                    child: AutoSizeText(
                                      (compte != null) ? compte.solde : '',
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.right,
                                      minFontSize: 12.0,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              )));
                    },
                  ),
                  Divider(),
//                  StreamBuilder<String>(
//                    builder:
//                        (BuildContext context, AsyncSnapshot<String> snapshot) {
//                      return Center(
//                          child: Container(
//                              child: Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        verticalDirection: VerticalDirection.down,
//                        children: [
//                          Text(
//                            'Gestionnaire:',
//                            style: TextStyle(
//                                fontSize: 15.0, fontWeight: FontWeight.bold),
//                          ),
//                          Expanded(
//                            child: AutoSizeText(
//                              (compte != null)
//                                  ? compte.nomCompletGestionnaire
//                                  : '',
//                              style: TextStyle(fontSize: 15.0),
//                              textAlign: TextAlign.right,
//                              minFontSize: 12.0,
//                              maxLines: 2,
//                            ),
//                          ),
//                        ],
//                      )));
//                    },
//                  ),
//                  Divider(),
                  StreamBuilder<bool>(
                      stream: _compteBanqueFormBloc.submitValidation,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return StreamBuilder<String>(
                            stream: _compteBanqueFormBloc.carrier,
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapsCarrier) {
                              return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new RaisedButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 30.0),
                                      textColor: Colors.white,
                                      color: ColorApp.blue,
                                      disabledColor: ColorApp.darkblue,
                                      disabledTextColor: Colors.white,
                                      onPressed: (() {
                                        Utils.saveCompteClient(
                                            compte?.numeroCompte);
                                        Utils.saveAgenceClient(
                                            compte?.agence);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  JournalComptePage()),
                                        );
                                      }),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                          new BorderRadius.circular(30.0)),
                                      child: new Text("VOIR DETAILS"),
                                    )
                                  ]);
                            });
                      }),
                ],
              ),
            )),
      );
    }

    return BlocEventStateBuilder<CompteBanqueState>(
      bloc: _compteBanqueBloc,
      builder: (BuildContext context, CompteBanqueState state) {
        if(state is CompteBanqueUninitialized) {
          return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.darkblue)),);
        }
        if(state is CompteBanqueError) {
          return buildError(context, state.error, ColorApp.darkblue);
        }
        if(state is CompteBanqueLoaded) {
          if(state.comptes.length<=0) {
            return Center(child: Text('Aucune donnée à afficher.', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,);
          } else {
            if(state.error != null ){
              Utils.onWidgetDidBuild(() {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.error}'),),);
              });
            }
            this.comptes = state.comptes;
            return Container(
              child: new Scaffold(
                appBar: appBar(
                    context, Config.serviceMBanking, _loginBloc, "Comptes Banque"),
                //appBar: AppBar(title: Text("Comptes"),centerTitle: true,),
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(child: form()),
                    )
                  ],
                  shrinkWrap: true,
                ),
              ),
            );
          }
        }
      },
    );
  }

  confirmer(String transaction, int action, String token) {
    _compteBanqueBloc
        .emitEvent(Confirm(id: transaction, action: action, token: token));
  }

  @override
  Future refresh() async {
    return Future.value();
    // TODO: implement refresh
  }

  void getComptes() async {
    DatabaseClient().allComptes().then((items) {
      setState(() {
        print('*** COMPTE *** ${items.length}');
        this.nroSelectedCompte = items[0].libelleCompte;
        this.compte = items[0];
        print('****** $nroSelectedCompte ******');
        print(compte.libelleCompte);
        print(compte.solde);
        this.comptes = items;
      });
    });
  }

  void getAccount() async{
    setState(() {
      if(comptes != null){
        getComptes();
      }
    });
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2030));
    if (picked != null) setState(() => _value = picked.toString());
  }
}
