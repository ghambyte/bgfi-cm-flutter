import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_bloc.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_event.dart';
import 'package:gui/blocs/virements_virtuels/virements_virtuels_state.dart';
import 'package:gui/models/virement_virtuel.dart';
import 'package:gui/pages/banking/new_virement_virtuel.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';
import 'package:gui/widgets/item_details_jb_line.dart';
import 'package:gui/widgets/item_details_line.dart';
import 'package:gui/widgets/item_simple_jb_toggle.dart';
import 'package:gui/widgets/item_simple_toggle.dart';

class VirementsVirtuelsPage extends StatefulWidget {
  @override
  _VirementsVirtuelsPageState createState() => _VirementsVirtuelsPageState();
}

class _VirementsVirtuelsPageState extends State<VirementsVirtuelsPage>
    with MAppBar, ErrorWideget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final VirementsVirtuelsBloc _virementsVirtuelsBloc = VirementsVirtuelsBloc();
  LoginBloc _loginBloc;
  int page = 0;
  List<int> visibility = [];

  @override
  void initState() {
    // TODO: implement initState
    _virementsVirtuelsBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content(List<VirementVirtuel> virements) {
      return StreamBuilder(
        builder: (context, snapshot) {
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
                              title: '${virements[index].motif}',
                              trailing: ''),
                        ),
                        visibility.contains(index)
                            ? Column(
                                children: <Widget>[
                                  Divider(),
                                  ItemDetailsLineJBPage(
                                    cle: 'Montant',
                                    value: virements[index].montant,
                                  ),
                                  Divider(),
                                  ItemDetailsLineJBPage(
                                    cle: 'Date',
                                    value: (virements[index].dateDemande != null)
                                        ? virements[index].dateDemande
                                        : "NULL",
                                  ),
                                  Divider(),
                                  ItemDetailsLineJBPage(
                                    cle: 'ETAT',
                                    value: virements[index].etat,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                  ),
                                ],
                              )
                            : Container()
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
      );
    }

    return Scaffold(
      body: BlocEventStateBuilder<VirementsVirtuelsState>(
        bloc: _virementsVirtuelsBloc,
        builder: (BuildContext context, VirementsVirtuelsState state) {
          if (state is VirementsVirtuelsUninitialized) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(ColorApp.darkblue)),
            );
          }
          if (state is VirementsVirtuelsError) {
            Utils.saveLogin('banking', null);
            return buildError(context, state.error, ColorApp.darkblue);
          }
          if (state is VirementsVirtuelsLoaded) {
            if (state.virementsVirtuels.length <= 0) {
              return Scaffold(
                  body: new Center(
                      child: Center(
                    child: Text(
                      'Aucun virement!',
                      style: TextStyle(color: Colors.black54, fontSize: 16.0),
                    ),
                  )),
                  floatingActionButton: new FloatingActionButton(
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      backgroundColor: new Color(0xFFE57373),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewVirementVirtuelPage()),
                        );
                      }));
            } else {
              if (state.error != null) {
                Utils.onWidgetDidBuild(() {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${state.error}'),
                    ),
                  );
                });
              }
              return Scaffold(
                  body: new Center(
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: content(state.virementsVirtuels),
                      ),
                      onRefresh: () => refresh(),
                    ),
                  ),
                  floatingActionButton: new FloatingActionButton(
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      backgroundColor: new Color(0xFFE57373),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewVirementVirtuelPage()),
                        );
                      }));
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
    visibility = [];
    _virementsVirtuelsBloc
        .emitEvent(Fetch(type: Config.serviceMBanking, init: true));
    return Future.value();
    // TODO: implement refresh
  }

  toggle(int index) {
    setState(() {
      if (visibility.contains(index)) {
        print(visibility.remove(index));
      } else {
        print('ok');
        visibility.add(index);
      }
    });
  }

  void _onScroll() {
    /*if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) */
        if(_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      visibility = [];
      _virementsVirtuelsBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    }
  }
}
