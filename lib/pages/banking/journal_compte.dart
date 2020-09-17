
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/journal_compte/journal_compte_bloc.dart';
import 'package:gui/blocs/journal_compte/journal_compte_event.dart';
import 'package:gui/blocs/journal_compte/journal_compte_state.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/models/journal_compte.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/item_details_jb_line.dart';
import 'package:gui/widgets/item_details_jounal_banking_line.dart';
import 'package:gui/widgets/item_simple_jounal_banking_toggle.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';

class JournalComptePage extends StatefulWidget {

  JournalComptePage();

  @override
  _JournalComptePageState createState() => _JournalComptePageState();
}

class _JournalComptePageState extends State<JournalComptePage> with BankingAppBar, ErrorWideget{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final JournalCompteBloc _journalCompteBloc = JournalCompteBloc();
  LoginBloc _loginBloc;
  int page = 0;
  List<int> visibility =[];

  @override
  void initState() {
    // TODO: implement initState
    _journalCompteBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    Widget contentEmptyJournalJour(List<JournalCompte> journaux) {
      return new Container(
          child: new Stack(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(child:
                    ListView.builder(
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
                                    child: ItemToggleJournalBankingPage(
                                        leading: visibility.contains(index),
                                        title: '${journaux[index].libelle}',
                                        trailing: journaux[index].sens
                                    ),
                                  ),
                                  visibility.contains(index)
                                      ? Column(
                                    children: <Widget>[
                                      Divider(),
                                      ItemDetailsLineJournalBankingPage(cle: 'LIBELLE:', value: journaux[index].libelle,),
                                      Divider(),
                                      ItemDetailsLineJournalBankingPage(cle: 'MONTANT:', value: journaux[index].montant,),
                                      Divider(),
                                      ItemDetailsLineJournalBankingPage(cle: 'DATE:', value: journaux[index].dateMouvement,),
                                      Divider(),
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
                      itemCount: journaux.length,
                      controller: _scrollController,
                    ))
                  ],
                ),
              ),
            ],
          )
      );
    }
    Widget content(List<JournalCompte> journaux, List<JournalCompte> journalJour) {
      final headerList = new ListView.builder(
        itemBuilder: (context, index) {
          EdgeInsets padding = index == 0?const EdgeInsets.only(
              left: 20.0, right: 10.0, top: 4.0, bottom: 30.0):const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 4.0, bottom: 30.0);

          return new Padding(
            padding: padding,
            child: new InkWell(
              onTap: () {
                print('Card selected');
              },
              child: new Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black.withAlpha(70),
                        offset: const Offset(3.0, 10.0),
                        blurRadius: 15.0)
                  ],
//                  image: new DecorationImage(
//                    image: new ExactAssetImage(
//                        'assets/img_${index%items.length}.jpg'),
//                    fit: BoxFit.fitHeight,
//                  ),
                ),
                height: 100.0,
                width: 200.0,
                child: new Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              ItemDetailsLineJBPage(cle: 'Montant', value: journalJour[index].montant,),
                              Divider(),
                              ItemDetailsLineJBPage(cle: 'Date', value: journalJour[index].dateMouvement,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                      ],
                    ),
                    new Align(
                      alignment: Alignment.bottomCenter,
                      child: new Container(
                          decoration: new BoxDecoration(
                              color: journalJour[index].sens=="D"?const Color(0xFFEF5350):const Color(0xFF388E3C),
                              borderRadius: new BorderRadius.only(
                                  bottomLeft: new Radius.circular(10.0),
                                  bottomRight: new Radius.circular(10.0))),
                          height: 30.0,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                '${journalJour[index].libelle}',
                                style: new TextStyle(color: Colors.white, fontSize: 10.0),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: journalJour.length,
      );
      return new Container(
          child: new Stack(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerLeft,
                      child: new Padding(
                          padding: new EdgeInsets.only(left: 8.0),
                          child: new Text(
                            'ÉVÉNEMENTS DU JOUR',
                            style: new TextStyle(color: ColorApp.darkblue, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,),
                          )),
                    ),
                    Divider(),
                    new Container(
                        height: 180.0, width: _width, child: headerList),
                    new Expanded(child:
                    ListView.builder(
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
                                    child: ItemToggleJournalBankingPage(
                                        leading: visibility.contains(index),
                                        title: '${journaux[index].libelle}',
                                        trailing: journaux[index].sens
                                    ),
                                  ),
                                  visibility.contains(index)
                                      ? Column(
                                    children: <Widget>[
                                      Divider(),
                                      ItemDetailsLineJournalBankingPage(cle: 'Libelle', value: journaux[index].libelle,),
                                      Divider(),
                                      ItemDetailsLineJournalBankingPage(cle: 'Montant', value: journaux[index].montant,),
                                      Divider(),
                                      ItemDetailsLineJournalBankingPage(cle: 'Date', value: journaux[index].dateMouvement,),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
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
                      itemCount: journaux.length,
                      controller: _scrollController,
                    ))
                  ],
                ),
              ),
            ],
          )
      );
    }

    return BlocEventStateBuilder<JournalCompteState>(
      bloc: _journalCompteBloc,
      builder: (BuildContext context, JournalCompteState state) {
        return new Scaffold(
            appBar: appBar(context, Config.serviceMBanking, _loginBloc, "Journal Banking"),
            body: BlocEventStateBuilder<JournalCompteState>(
              bloc: _journalCompteBloc,
              builder: (BuildContext context, JournalCompteState state) {
                if(state is JournalCompteUninitialized) {
                  return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.darkblue)),);
                }
                if(state is JournalCompteError) {
                  return buildError(context, state.error, ColorApp.darkblue);
                }
                if(state is JournalCompteLoaded) {
                  if(state.journalCompte.length<=0) {
                    return Center(child: Text('Aucune donnée à afficher.', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,);
                  } else {
                    if(state.error != null ){
                      Utils.onWidgetDidBuild(() {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.error}'),),);
                      });
                    }
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      child: (state.journalJour == null || state.journalJour.isEmpty) ? Padding(padding: EdgeInsets.only(top: 10.0), child: contentEmptyJournalJour(state.journalCompte),)
                          :Padding(padding: EdgeInsets.only(top: 10.0), child: content(state.journalCompte, state.journalJour),),
                      onRefresh: () => refresh(),
                    );
                  }
                }
                return Container();

              },
            ),
          backgroundColor: ColorApp.background,
        );
      },
    );

  }

  @override
  Future refresh() async {
    visibility =[];
    _journalCompteBloc.emitEvent(Fetch(type: Config.serviceMBanking, init: true));
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
      _journalCompteBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    }
  }

}
