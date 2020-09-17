
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/virements_banque/virements_banque_bloc.dart';
import 'package:gui/blocs/virements_banque/virements_banque_event.dart';
import 'package:gui/blocs/virements_banque/virements_banque_state.dart';
import 'package:gui/models/virement_banque.dart';
import 'package:gui/models/virement_virtuel.dart';
import 'package:gui/pages/banking/new_virement_banque.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';
import 'package:gui/widgets/item_details_jb_line.dart';
import 'package:gui/widgets/item_details_line.dart';
import 'package:gui/widgets/item_simple_jb_toggle.dart';
import 'package:gui/widgets/item_simple_toggle.dart';

class VirementsBanquePage extends StatefulWidget {
  @override
  _VirementsBanquePageState createState() => _VirementsBanquePageState();
}

class _VirementsBanquePageState extends State<VirementsBanquePage> with MAppBar, ErrorWideget{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final VirementsBanqueBloc _virementsBanqueBloc = VirementsBanqueBloc();
  LoginBloc _loginBloc;
  int page = 0;
  List<int> visibility =[];

  @override
  void initState() {
    // TODO: implement initState
    _virementsBanqueBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget content(List<VirementBanque> virements) {
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
                          title: '${virements[index].libelle}',
                          trailing: ''
                      ),
                    ),
                    visibility.contains(index)
                        ? Column(
                      children: <Widget>[
                        Divider(),
                        ItemDetailsLineJBPage(cle: 'Montant', value: virements[index].montant,),
                        Divider(),
                        ItemDetailsLineJBPage(cle: 'Motif', value: virements[index].motif,),
                        Divider(),
                        ItemDetailsLineJBPage(cle: 'Date', value: virements[index].dateDemande,),
                        Divider(),
                        ItemDetailsLineJBPage(cle: 'ETAT', value: virements[index].libelleEtatVirement,),
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
        itemCount: virements.length,
        //controller: _scrollController,
      );
    }
    return Scaffold(
      body: BlocEventStateBuilder<VirementsBanqueState>(
        bloc: _virementsBanqueBloc,
        builder: (BuildContext context, VirementsBanqueState state) {
          if(state is VirementsBanqueUninitialized) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.darkblue)),);
          }
          if(state is VirementsBanqueError) {
            Utils.saveLogin('banking', null);
            return buildError(context, state.error, ColorApp.darkblue);
          }
          if(state is VirementsBanqueLoaded) {
            if(state.virements.length<=0) {
              return Scaffold(
                  body: new Center(
                      child: Center(child: Text('Aucun virement!', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,)
                  ),
                  floatingActionButton: new FloatingActionButton(
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      backgroundColor: new Color(0xFFE57373),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewVirementBanquePage()),
                        );
                      }
                  )
              );
            } else {
              if(state.error != null ){
                Utils.onWidgetDidBuild(() {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.error}'),),);
                });
              }
              return Scaffold(
                  body: new Center(
                    child: RefreshIndicator(key: _refreshIndicatorKey, child: Padding(padding: EdgeInsets.only(top: 10.0), child: content(state.virements),), onRefresh: () => refresh(),),
                  ),
                  floatingActionButton: new FloatingActionButton(
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      backgroundColor: new Color(0xFFE57373),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewVirementBanquePage()),
                        );
                      }
                  )
              );
//              return RefreshIndicator(
//                key: _refreshIndicatorKey,
//                child: Padding(padding: EdgeInsets.only(top: 10.0), child: content(state.virements),),
//                onRefresh: () => refresh(),
//              );
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
    _virementsBanqueBloc.emitEvent(Fetch(type: Config.serviceMBanking, init: true));
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
      _virementsBanqueBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    }
  }

  Future _doVirement() async {

  }

}
