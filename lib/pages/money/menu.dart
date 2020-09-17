import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gui/blocs/authentication/authentication_bloc.dart';
import 'package:gui/blocs/authentication/authentication_state.dart';
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/login/login_event.dart';
import 'package:gui/blocs/login/login_state.dart';
import 'package:gui/blocs/security_bloc.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/navigation/slide_right_transition.dart';
import 'package:gui/pages/login/login.dart';
import 'package:gui/pages/money/historique.dart';
import 'package:gui/pages/money/tab_manager.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/item_menu_widget.dart';

class MenuMMPage extends StatefulWidget {

  var loginMoney;

  MenuMMPage(this.loginMoney, {Key key}): super(key: key);

  @override
  _MenuMMPageState createState() => _MenuMMPageState();
}

class _MenuMMPageState extends State<MenuMMPage> with MAppBar{

  final double _appBarHeight = 80.0;


  bool isShown = false;

  bool initSecret = false;

  String verification = 'AFFICHER SOLDE';

  SecurityBloc securityBloc = SecurityBloc();

  AuthenticationBloc _bloc ;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    // TODO: implement initState
    _bloc = BlocProvider.of<AuthenticationBloc>(context);
    securityBloc.getStatus(Config.serviceMMoney);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc= LoginBloc(authenticationBloc: _authenticationBloc);

    super.initState();

//    getLogin();

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
            image: new AssetImage("images/f4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(
            bottom: 20.0
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: heightInfos,
              width: widthScreen,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/forme.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('COMPTE VIRTUEL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // light
                      fontSize: 16.0,
                      color:ColorApp.darkGreen,
                    ),
                  ),
                  isShown ?
                  StreamBuilder<Reponse>(
                      stream: securityBloc.response.stream,
                      builder: (BuildContext context, AsyncSnapshot<Reponse> snapshot) {
                        return Text(snapshot.hasData?snapshot.data.statutcode == Config.codeSuccess?snapshot.data.reponse['soldedisponible']+" XAF":'':'',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // light
                            fontSize: 25.0,
                            color:ColorApp.green,
                          ),
                        );
                      }
                  )
                      : new FlatButton(
                    padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 30.0),
                    textColor: ColorApp.white,
                    color: ColorApp.darkGreen,
                    onPressed: (){
                      _showDialog();
//                      Utils.alertSecret(context, "Secret", "Valider", validerSecret );
//                      setState(() {
//                        isShown = ! isShown;
//                      });
                    },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: new Text(verification,
                        style : new TextStyle(
                            fontSize: 10.0)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('TITULAIRE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // light
                            fontSize: 14.0,
                            color:ColorApp.darkGreen,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(widget.loginMoney,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal, // light
                              fontSize: 14.0,
                              color:ColorApp.green,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: GridView.builder(
                    itemCount: Utils.menuMM.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: ItemMenuWidget(itemMenu: Utils.menuMM[index], width: widthItemText, height: heightItemMenu, heightText: heightItemText,),
                        onTap: (){
                          isShown = false;
                          if(Utils.menuMM[index].hist) {
                            Navigator.push(context, SlideRightRoute(widget: HistoriquePage()));
                          } else {
                            Navigator.push(context, SlideRightRoute(widget: TabManagerPage(menuchosen: Utils.menuMM[index].index,)));
                          }
                        },
                      );
                    }
                )
            )
          ],
        ),
      );
    }

    return BlocEventStateBuilder<LoginState>(
      bloc: _loginBloc,
      builder: (BuildContext context, LoginState state) {
        if(state.isBusy && state.service == 'disconnect') {
          Utils.showDialogProgress(context, 'Requête en cours');
        }
        if(state.isSuccess) {
          if(state.successMessage ==  "verified"){
            isShown = true;
          }else{
            Utils.redirectToPage(context, LoginPage(service: Config.serviceMMoney,));
          }
        }
        if(state.isFailure) {
          Navigator.pop(context);
          Utils.dialog(context, state.errorMessage, 'Erreur', true);
        }
        return new Scaffold(
            appBar: appBar(context, Config.serviceMMoney, _loginBloc, "Mobile Money"),
            body: _builContent()
        );
      },
    );
  }

  validerSecret(String secret){
    setState(() {
      verification = 'Verification en cours';
    });
    initSecret = true;
    _loginBloc.emitEvent(LoginEvent(
        event: LoginEventType.verify,
        password: secret,
        service: 'money'));
  }

  void _showDialog() {
    String codesecret;
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
                child: new Text("FERMER", style: TextStyle(color: Colors.black),),
                onPressed: (){
                  Navigator.of(context).pop();
                }
            ),
            new FlatButton(
                child: new Text("VALIDER"),
                onPressed: (){
                  print("ACTION SUBMIT");
                  final form = formKey.currentState;
                  if (form.validate()) {
                    print("FORM OK ####");
                    form.save();
                    Navigator.of(context).pop();
                    validerSecret(codesecret);
                  }
                }
            ),

          ],
        );
      },
    );
  }
}
