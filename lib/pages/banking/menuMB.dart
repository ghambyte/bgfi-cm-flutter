import 'package:flutter/material.dart';
import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/compte_banque/compte_banque_bloc.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/blocs/login/login_state.dart';
import 'package:gui/blocs/security_bloc.dart';
import 'package:gui/models/databaseClient.dart';
import 'package:gui/navigation/slide_right_transition.dart';
import 'package:gui/pages/banking/comptes_banque.dart';
import 'package:gui/pages/banking/reseau_gab.dart';
import 'package:gui/pages/login/login.dart';
import 'package:gui/pages/money/tab_manager_banking.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/double_bounce.dart';
import 'package:gui/tools/three_bounce.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/item_menu_widget.dart';

class MenuMBPage extends StatefulWidget {
  @override
  _MenuMBPageState createState() => _MenuMBPageState();
}

class _MenuMBPageState extends State<MenuMBPage> with BankingAppBar{

  final double _appBarHeight = 80.0;

  bool isShown =false;

  bool initSecret = false;

  SecurityBloc securityBloc = SecurityBloc();

  CompteBanqueBloc _compteBanqueBloc = CompteBanqueBloc();

  AuthenticationBloc _bloc ;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    _bloc = BlocProvider.of<AuthenticationBloc>(context);
    securityBloc.getStatus(Config.serviceMBanking);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc= LoginBloc(authenticationBloc: _authenticationBloc);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    double heightInfos = heightScreen/4;
    double heightItemMenu = widthScreen/6;
    double widthItemText = widthScreen/4;
    double heightItemText = heightItemMenu*0.6;

    Widget _builContent() {
      return Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/f1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: GridView.builder(
                    itemCount: Utils.menuMB.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: ItemMenuWidget(itemMenu: Utils.menuMB[index], width: widthItemText, height: heightItemMenu, heightText: heightItemText,),
//                        onTap: (){
//                          isShown=false ;
//                          if(Utils.menuMB[index].compte){
//                            _showDialog();
//                          }else if(Utils.menuMB[index].gab){
//                            Navigator.push(context, SlideRightRoute(widget: ReseauGabPage()));
//                          }else{
//                            Navigator.push(context, SlideRightRoute(widget: TabManagerPageBanking(menuchosen: Utils.menuMB[index].index,)));
//                          }},
                        onTap:(load == false)
                            ? () {
                              isShown=false ;
                              if(Utils.menuMB[index].compte){
                                _showDialog();
                              }else if(Utils.menuMB[index].gab){
                                Navigator.push(context, SlideRightRoute(widget: ReseauGabPage()));
                              }else{
                                Navigator.push(context, SlideRightRoute(widget: TabManagerPageBanking(menuchosen: Utils.menuMB[index].index,)));
                              }
                        }: null,
                      );
                    }
                )
            ),
            Container(
              child: Visibility(
                visible: load,
                child: SpinKitDoubleBounce(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? ColorApp.blue : ColorApp.green,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    /*return BlocEventStateBuilder<AuthenticationState>(
      bloc: _bloc,
      builder: (BuildContext context, AuthenticationState state) {
        return new Scaffold(
            appBar: appBar(context, Config.serviceMBanking, _loginBloc, "Mobile Banking"),
            body: _builContent(state)
        );
      },
    );*/

    return BlocEventStateBuilder<LoginState> (
      bloc: _loginBloc,
      builder: (BuildContext context, LoginState state) {
        if(state.isBusy && state.service == 'disconnect') {
          Utils.showDialogProgress(context, 'Requête en cours');
        }
        if(state.isBusy && state.service != 'disconnect') {
          load = true;
        }
        if(state.isSuccess) {
          load = false;
          if(state.successMessage ==  "verified"){
            _loginBloc.emitEvent(LoginEvent(
                event: LoginEventType.getComptes,
                password: "",
                service: 'banking'));

          }else if(state.successMessage == "comptes"){
            return CompteBanquePage();
          } else{
            deleteCompte();
            Utils.redirectToPage(context, LoginPage(service: Config.serviceMBanking,));
          }
        }
        if(state.isFailure && isShown) {
          load = false;
          Utils.dialog(context, state.errorMessage, 'Erreur', true);
        }else{
          print("MESSAGE #### ${state.service}");
        }
        return new Scaffold(
            appBar: appBar(context, Config.serviceMBanking, _loginBloc, "Mobile Banking"),
            body: _builContent()
        );
      },
    );

  }

  validerSecret(String secret){
    initSecret = true;
    _loginBloc.emitEvent(LoginEvent(
        event: LoginEventType.verify,
        password: secret,
        service: 'banking'));
  }

  void deleteCompte() async{
    DatabaseClient().delete().then((val){
      print('Database deleted ###');
    });
  }

  void _showDialog() {
    String codesecret="";
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("VÉRIFICATION"),
          content: Form (
              key: formKey,
              child:new TextFormField(

                decoration: new InputDecoration(labelText: "CODE SECRET",
                    labelStyle: new TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    )),
                keyboardType: TextInputType.number,
                validator: (val) => val.length!=4 ? 'CODE SECRET INVALIDE' : null,
                onSaved: (val) => codesecret = val,
                obscureText: true,
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
                child: new Text("ANNULER", style: new TextStyle(color: Colors.black)),
                onPressed: (){
                  Navigator.of(context).pop();
                }
            ),
            new FlatButton(
                child: new Text("VALIDER"),
                onPressed: (){
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    Navigator.of(context).pop();
                    validerSecret(codesecret);
                    isShown=true ;
                  }
                }
            ),

          ],
        );
      },
    );
  }

}
