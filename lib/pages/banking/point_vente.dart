
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/point_vente/point_vente_bloc.dart';
import 'package:gui/blocs/point_vente/point_vente_event.dart';
import 'package:gui/blocs/point_vente/point_vente_state.dart';
import 'package:gui/models/agences.dart';
import 'package:gui/models/nf_details_info.dart';
import 'package:gui/models/nf_operation.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';
import 'package:gui/widgets/item_details_jb_line.dart';
import 'package:gui/widgets/item_details_line.dart';
import 'package:gui/widgets/item_simple_jb_toggle.dart';
import 'package:gui/widgets/item_simple_toggle.dart';
import 'package:gui/widgets/password_popup.dart';

class PointVentePage extends StatefulWidget {
  @override
  _PointVentePageState createState() => _PointVentePageState();
}

class _PointVentePageState extends State<PointVentePage> with MAppBar, ErrorWideget{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final PointVenteBloc _pointVenteBloc = PointVenteBloc();
  LoginBloc _loginBloc;
  int page = 0;
  List<int> visibility =[];

  @override
  void initState() {
    // TODO: implement initState
    _pointVenteBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget content(List<Agences> agences) {
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
                            title: '${agences[index].nomAgence}',
                            trailing: ''
                        ),
                      ),
                      visibility.contains(index)
                          ? Column(
                            children: <Widget>[
                              Divider(),
                              ItemDetailsLineJBPage(cle: 'Adresse', value: agences[index].adresseAgence,),
                              Divider(),
                              ItemDetailsLineJBPage(cle: 'Téléphone', value: agences[index].telephone,),
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
        itemCount: agences.length,
        //controller: _scrollController,
      );
    }
    return Scaffold(
      body: BlocEventStateBuilder<PointVenteState>(
        bloc: _pointVenteBloc,
        builder: (BuildContext context, PointVenteState state) {
          if(state is PointVenteUninitialized) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.blue)),);
          }
          if(state is PointVenteError) {
            return buildError(context, state.error, ColorApp.blue);
          }
          if(state is PointVenteLoaded) {
            if(state.agences.length<=0) {
              return Center(child: Text('Aucun point de vente!', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,);
            } else {
              if(state.error != null ){
                Utils.onWidgetDidBuild(() {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.error}'),),);
                });
              }
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                child: Padding(padding: EdgeInsets.only(top: 10.0), child: content(state.agences),),
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
    _pointVenteBloc.emitEvent(Fetch(type: Config.serviceMBanking, init: true));
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
      _pointVenteBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    }
  }

}
