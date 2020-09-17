
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/messagerie/messagerie_bloc.dart';
import 'package:gui/blocs/messagerie/messagerie_state.dart';
import 'package:gui/blocs/messagerie/messagerie_event.dart';
import 'package:gui/models/messagerie.dart';
import 'package:gui/pages/banking/new_message.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';
import 'package:gui/widgets/item_details_line.dart';
import 'package:gui/widgets/item_simple_toggle.dart';

class MessageriePage extends StatefulWidget {
  @override
  _MessageriePageState createState() => _MessageriePageState();
}

class _MessageriePageState extends State<MessageriePage> with MAppBar, ErrorWideget{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final MessagerieBloc _messagerieBloc = MessagerieBloc();
  int page = 0;
  List<int> visibility =[];

  @override
  void initState() {
    // TODO: implement initState
    _messagerieBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget content(List<Messagerie> virementsBanque) {
      new ListView.builder(
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
                            title: '${virementsBanque[index].objet}',
                            trailing: ''
                        ),
                      ),
                      visibility.contains(index)
                          ? Column(
                            children: <Widget>[
                              Divider(),
                              ItemDetailsLinePage(cle: 'Achat', value: virementsBanque[index].corps.split(' ')[0].replaceAll('-', ' - '),),
                              Divider(),
                              ItemDetailsLinePage(cle: 'Vente', value: virementsBanque[index].codeClient,),
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
        itemCount: virementsBanque.length,
        controller: _scrollController,
      );
      FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.check),
          backgroundColor: new Color(0xFFE57373),
          onPressed: (){}
      );
    }
    return Scaffold(
      body: BlocEventStateBuilder<MessagerieState>(
        bloc: _messagerieBloc,
        builder: (BuildContext context, MessagerieState state) {
          if(state is MessagerieUninitialized) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.darkblue)),);
          }
          if(state is MessagerieError) {
            Utils.saveLogin('banking', null);
            return buildError(context, state.error, ColorApp.darkblue);
          }
          if(state is MessagerieLoaded) {
            if(state.messages.length<=0) {
              return Scaffold(
                  body: new Center(
                    child: Center(child: Text('Aucun message!', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,)
                  ),
                  floatingActionButton: new FloatingActionButton(
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      backgroundColor: new Color(0xFFE57373),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewMessagePage()),
                        );
                      }
                  )
              );
//              return Container(
//                  child: Center(child: Text('Aucun message!', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,)
//                ,
//              );
            } else {
              if(state.error != null ){
                Utils.onWidgetDidBuild(() {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.error}'),),);
                });
              }
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                child: Padding(padding: EdgeInsets.only(top: 10.0), child: content(state.messages),),
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
    _messagerieBloc.emitEvent(Fetch(type: Config.serviceMBanking, init: true));
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
      _messagerieBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    }
  }

  Future _doVirement() async {

  }

}
