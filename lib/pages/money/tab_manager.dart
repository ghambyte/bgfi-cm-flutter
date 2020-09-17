
import 'package:flutter/material.dart';
import 'package:gui/exception/fetch_exception.dart';
import 'package:gui/models/item_menu.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/pages/money/menu.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/money_app_bar.dart';

class TabManagerPage extends StatefulWidget{

  final int menuchosen;

  TabManagerPage({this.menuchosen});

  @override
  _TabManagerPageState createState() => _TabManagerPageState();
}

class _TabManagerPageState extends State<TabManagerPage>  with MAppBar {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        getLogin();
      },
      child: new DefaultTabController(
        length: Utils.menuMM.where((i) => !i.hist).length,
        initialIndex: widget.menuchosen,
        child: Theme(
          data : theme.copyWith(
            primaryColor: ColorApp.darkGreen,
            hintColor: ColorApp.green,
            highlightColor: ColorApp.green,
            accentColor: ColorApp.green,
            primaryColorDark: ColorApp.darkGreen,
            backgroundColor: ColorApp.bg,
            cursorColor: Colors.white,
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Center(child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text("Mobile money", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              ),),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () => getLogin(),
              ),
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
              backgroundColor: ColorApp.green,
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: Utils.menuMM.where((i) => !i.hist).map((ItemMenu itemMenu) {
                  return Tab(
                    text: itemMenu.texte,
                    icon: itemMenu.image,
                  );
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: Utils.menuMM.where((i) => !i.hist).map((ItemMenu itemMenu) {
                return itemMenu.widget;
              }).toList(),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
//    return DefaultTabController(
//      length: Utils.menuMM.where((i) => !i.hist).length,
//      initialIndex: widget.menuchosen,
//      child: Theme(
//        data : theme.copyWith(
//          primaryColor: ColorApp.darkGreen,
//          hintColor: ColorApp.green,
//          highlightColor: ColorApp.green,
//          accentColor: ColorApp.green,
//          primaryColorDark: ColorApp.darkGreen,
//          backgroundColor: ColorApp.bg,
//          cursorColor: Colors.white,
//        ),
//        child: Scaffold(
//          appBar: AppBar(
//            title: Center(child: Padding(
//              padding: const EdgeInsets.only(top: 15.0),
//              child: Text("Mobile money", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
//            ),),
//            actions: <Widget>[
////              GestureDetector(
////                child: Padding(
////                  padding: const EdgeInsets.only(right: 5.0),
////                  child: Container(
////                    width: 25.0,
////                    child: Center(child: Image.asset('images/mb-icon.png', fit: BoxFit.contain,)),
////                  ),
////                ),
////                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
////
////              ),
////              Icon(Icons.more_vert, color: Colors.white,)
//            ],
//            iconTheme: IconThemeData(
//              color: Colors.white,
//            ),
//            backgroundColor: ColorApp.green,
//            bottom: TabBar(
//              isScrollable: true,
//              indicatorColor: Colors.white,
//              tabs: Utils.menuMM.where((i) => !i.hist).map((ItemMenu itemMenu) {
//                return Tab(
//                  text: itemMenu.texte,
//                  icon: itemMenu.image,
//                );
//              }).toList(),
//            ),
//          ),
//          body: TabBarView(
//            children: Utils.menuMM.where((i) => !i.hist).map((ItemMenu itemMenu) {
//              return itemMenu.widget;
//            }).toList(),
//          ),
//          backgroundColor: Colors.white,
//        ),
//      ),
//    );
  }

  getLogin() async{
    await Utils.getLogin(Config.serviceMMoney).then((login){
      if(login != null){
        Utils.redirectToPage(context, MenuMMPage(login));
      }
    }).catchError((error)=> throw new FetchException(Reponse(statutcode: Config.codeError, message: "Le login n'existe pas !", reponse: null)));
  }
}
