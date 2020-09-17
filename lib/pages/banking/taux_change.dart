
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/taux_change/taux_change_bloc.dart';
import 'package:gui/blocs/taux_change/taux_change_state.dart';
import 'package:gui/blocs/taux_change/taux_change_event.dart';
import 'package:gui/models/taux_change.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';
import 'package:gui/widgets/item_details_jb_line.dart';
import 'package:gui/widgets/item_details_line.dart';
import 'package:gui/widgets/item_simple_jb_toggle.dart';
import 'package:gui/widgets/item_simple_toggle.dart';

class TauxChangePage extends StatefulWidget {
  @override
  _TauxChangePageState createState() => _TauxChangePageState();
}

class _TauxChangePageState extends State<TauxChangePage> with MAppBar, ErrorWideget{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final TauxChangeBloc _tauxChangeBloc = TauxChangeBloc();
  LoginBloc _loginBloc;
  int page = 0;
  List<int> visibility =[];

  @override
  void initState() {
    // TODO: implement initState
    _tauxChangeBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget content(List<TauxChange> tauxChange) {
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
                        child: ItemToggleJBPage(
                            leading: visibility.contains(index),
                            title: '${tauxChange[index].libelle}',
                            trailing: ''
                        ),
                      ),
                      visibility.contains(index)
                          ? Column(
                            children: <Widget>[
                              Divider(),
                              ItemDetailsLineJBPage(cle: 'Achat', value: tauxChange[index].achat_bb.split(' ')[0].replaceAll('-', ' - '),),
                              Divider(),
                              ItemDetailsLineJBPage(cle: 'Vente', value: tauxChange[index].vente_bb,),
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
        itemCount: tauxChange.length,
        //controller: _scrollController,
      );
    }
    return Scaffold(
      body: BlocEventStateBuilder<TauxChangeState>(
        bloc: _tauxChangeBloc,
        builder: (BuildContext context, TauxChangeState state) {
          if(state is TauxChangeUninitialized) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.blue)),);
          }
          if(state is TauxChangeError) {
            return buildError(context, state.error, ColorApp.blue);
          }
          if(state is TauxChangeLoaded) {
            if(state.tauxChange.length<=0) {
              return Center(child: Text('Aucune donnée à afficher.', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,);
            } else {
              if(state.error != null ){
                Utils.onWidgetDidBuild(() {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.error}'),),);
                });
              }
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                child: Padding(padding: EdgeInsets.only(top: 10.0), child: content(state.tauxChange),),
                onRefresh: () => refresh(),
              );
            }
          }
          return Container();

        },
      ),
      backgroundColor: ColorApp.background,
    );
  }

  @override
  Future refresh() async {
    visibility =[];
    _tauxChangeBloc.emitEvent(Fetch(type: Config.serviceMBanking, init: true));
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
      _tauxChangeBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    }
  }

}
