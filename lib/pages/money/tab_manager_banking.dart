
import 'package:flutter/material.dart';
import 'package:gui/models/item_menu.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';

class TabManagerPageBanking extends StatefulWidget{

  final int menuchosen;

  TabManagerPageBanking({this.menuchosen});

  @override
  _TabManagerPageState createState() => _TabManagerPageState();
}

class _TabManagerPageState extends State<TabManagerPageBanking>  with MAppBar {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: Utils.menuMB.where((i) => !i.compte && !i.gab).length,
      initialIndex: widget.menuchosen,
      child: Theme(
        data : theme.copyWith(
          primaryColor: ColorApp.darkblue,
          hintColor: ColorApp.blue,
          highlightColor: ColorApp.blue,
          accentColor: ColorApp.blue,
          primaryColorDark: ColorApp.darkblue,
          backgroundColor: ColorApp.bg,
          cursorColor: Colors.white,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text("Mobile Banking", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
            ),),
            actions: <Widget>[
//              GestureDetector(
//                child: Padding(
//                  padding: const EdgeInsets.only(right: 5.0),
//                  child: Container(
//                    width: 25.0,
//                    child: Center(child: Image.asset('images/mb-icon.png', fit: BoxFit.contain,)),
//                  ),
//                ),
//                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
//
//              ),
//              Icon(Icons.more_vert, color: Colors.white,)
            ],
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: ColorApp.blue,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: Utils.menuMB.where((i) => !i.compte && !i.gab).map((ItemMenu itemMenu) {
                return Tab(
                  text: itemMenu.texte,
                  icon: itemMenu.image,
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: Utils.menuMB.where((i) => !i.compte && !i.gab).map((ItemMenu itemMenu) {
              return itemMenu.widget;
            }).toList(),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
