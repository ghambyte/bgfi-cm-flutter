
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/details_info/details_info_bloc.dart';
import 'package:gui/blocs/details_info/details_info_event.dart';
import 'package:gui/blocs/details_info/details_info_state.dart';
import 'package:gui/blocs/info/info_bloc.dart';
import 'package:gui/blocs/info/info_event.dart';
import 'package:gui/blocs/info/info_state.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/models/nf_operation.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/pages/money/menu.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';
import 'package:gui/widgets/item_details_line.dart';
import 'package:gui/widgets/item_toggle.dart';
import 'package:gui/widgets/money_standard_app_bar.dart';
import 'package:gui/widgets/password_popup.dart';

class HistoriquePage extends StatefulWidget {
  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> with MoneyStandardAppBar, ErrorWideget, PasswodPopup{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final InfoBloc _infoBloc = InfoBloc();
  final DetailsInfoBloc _detailsInfoBloc = DetailsInfoBloc();
  LoginBloc _loginBloc;
  int page = 0;
  List<int> visibility =[];

  @override
  void initState() {
    // TODO: implement initState
    _infoBloc.emitEvent(Fetch(type: Config.serviceMMoney));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content(List<NFOperation> nfOperations) {
      return new ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => toggle(index),
                      child: ItemTogglePage(
                          leading: visibility.contains(index),
                          title: '${nfOperations[index].libelle} ${nfOperations[index].montant}',
                          trailing: nfOperations[index].sens
                      ),
                    ),
                    visibility.contains(index)
                        ? Column(
                      children: <Widget>[
                        Divider(),
                        ItemDetailsLinePage(cle: 'Date', value: nfOperations[index].date.split(' ')[0].replaceAll('-', ' - '),),
                        Divider(),
                        ItemDetailsLinePage(cle: 'Référence', value: nfOperations[index].reference,),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Center(
                            child: RaisedButton(
                              onPressed: () => dialogShow(context, nfOperations[index].reference, 'Information', 'AFFICHER'),
                              child: Text("PLUS D'INFOS", style: TextStyle(fontSize: 10.0, color: Colors.white),),
                              elevation: 0,
                              color: ColorApp.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                            ),
                          ),
                        ),
                      ],
                    ) : Container()
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 0,
            ),
          );
        },
        itemCount: nfOperations.length,
        controller: _scrollController,
      );
    }
    return new WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        getLogin();
      },
      child: new Scaffold(
//        appBar: appBar(context, Config.serviceMMoney, _loginBloc, "Mobile Money", sousTitle: true),
        appBar: new AppBar(
//          title: new Text("data"),
          flexibleSpace:  new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image.asset(
                'images/barS.png',
                fit: BoxFit.cover,
                height: 140.0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("HISTORIQUE", style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.white),),
                    ],
                  ),
                ),
              )
            ],
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => getLogin(),
          ),
        ),
        body: BlocEventStateBuilder<InfoState>(
          bloc: _infoBloc,
          builder: (BuildContext context, InfoState state) {
            if(state is InfoUninitialized) {
              return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.green)),);
            }
            if(state is InfoError) {
              return buildError(context, state.error, ColorApp.green);
            }
            if(state is InfoLoaded) {
              if(state.nfoperations.length<=0) {
                return Center(child: Text('Aucune donnée à afficher.', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,);
              } else {
                if(state.error != null ){
                  Utils.onWidgetDidBuild(() {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.error}'),),);
                  });
                }
                return BlocEventStateBuilder<DetailsInfoState>(
                    bloc: _detailsInfoBloc,
                    builder: (BuildContext context, DetailsInfoState detailsState) {
                      if(detailsState is DetailsInfoInitialized) {
                        Utils.onWidgetDidBuild((){
                          Navigator.pop(context);
                        });
                        Utils.showDialogProgress(context, 'Requete en cours ...');
                      }
                      if(detailsState is DetailsInfoError) {
                        Utils.onWidgetDidBuild((){
                          Navigator.pop(context);
                        });
                        Utils.dialog(context, detailsState.error, 'Information', false);
                      }
                      if(detailsState is DetailsInfoLoaded) {
                        Utils.onWidgetDidBuild((){
                          Navigator.pop(context);
                        });
                        alerteInfo(context, detailsState.nfdetailsinfos);
                      }
                      return RefreshIndicator(
                        key: _refreshIndicatorKey,
                        child: Padding(padding: EdgeInsets.only(top: 10.0), child: content(state.nfoperations),),
                        onRefresh: () => refresh(),
                      );

                    });

              }
            }
            return Container();

          },
        ),
        backgroundColor: ColorApp.background,
      ),
    );
  }

  @override
  Future refresh() async {
    visibility =[];
    _infoBloc.emitEvent(Fetch(type: Config.serviceMMoney, init: true));
    return Future.value();
    // TODO: implement refresh
  }

  toggle(int index) {
    setState(() {
      if(visibility.contains(index)) {
        print(visibility.remove(index));
      } else {
        print('ok');
        visibility.add(index);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      visibility =[];
      _infoBloc.emitEvent(Fetch(type: Config.serviceMMoney));
    }
  }

  @override
  passwordSubmit(String secret, String reference) {
    // TODO: implement passwordSubmit
    _detailsInfoBloc.emitEvent(Post(secret: secret, reference: reference));
    return null;
  }

  void alerteInfo(BuildContext context, List<NFDetailsInfo> nfs) {
    String message = "";
    nfs.forEach((k)=>message +="- " +  k.label+" : "+k.value+"\n");
    Utils.dialog(context, message, 'INFOS', false);

  }

  getLogin() async{
    await Utils.getLogin(Config.serviceMMoney).then((login){
      if(login != null){
        Utils.redirectToPage(context, MenuMMPage(login));
      }
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le login n'existe pas !", reponse: null)));
  }


}
