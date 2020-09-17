
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/reseau_gab/reseau_gab_bloc.dart';
import 'package:gui/blocs/reseau_gab/reseau_gab_event.dart';
import 'package:gui/blocs/reseau_gab/reseau_gab_state.dart';
import 'package:gui/models/gabs.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/banking_app_bar.dart';
import 'package:gui/widgets/error_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:permission/permission.dart';

class ReseauGabPage extends StatefulWidget {
  @override
  _ReseauGabPageState createState() => _ReseauGabPageState();
}

class _ReseauGabPageState extends State<ReseauGabPage> with BankingAppBar, ErrorWideget{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final ReseauGabBloc _reseauGabBloc = ReseauGabBloc();
  LoginBloc _loginBloc;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.381681, 9.450396),
    zoom: 7.0,
    bearing: 10.8334901395799,
    tilt: 59.440717697143555,
  );

  int page = 0;
  List<int> visibility =[];

  LatLng _lastMapPosition;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    _reseauGabBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    _scrollController.addListener(_onScroll);
//    _getMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget content(List<Gabs> gabs) {
      var it = gabs.iterator;
      while(it.moveNext()){
        _lastMapPosition = LatLng(double.parse(it.current.latitude), double.parse(it.current.longitude));
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: it.current.label,
            snippet: it.current.adresse,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      }
      return new Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: Text('Centrer'),
          icon: Icon(Icons.map),
        ),
      );
    }
    return Scaffold(
      appBar: appBar(context, Config.serviceMBanking, _loginBloc, "Réseau de GABs"),
      body: BlocEventStateBuilder<ReseauGabState>(
        bloc: _reseauGabBloc,
        builder: (BuildContext context, ReseauGabState state) {
          if(state is ReseauGabUninitialized) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.blue)),);
          }
          if(state is ReseauGabError) {
            return buildError(context, state.error, ColorApp.blue);
          }
          if(state is ReseauGabLoaded) {
            if(state.gabs.length<=0) {
              return Center(child: Text('Aucun point gab!', style: TextStyle(color: Colors.black54, fontSize: 16.0),) ,);
            } else {
              if(state.error != null ){
                Utils.onWidgetDidBuild(() {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('${state.error}'),),);
                });
              }
              return Container(
                child: Padding(padding: EdgeInsets.only(top: 0.0), child: content(state.gabs),),
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
    _reseauGabBloc.emitEvent(Fetch(type: Config.serviceMBanking, init: true));
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
      _reseauGabBloc.emitEvent(Fetch(type: Config.serviceMBanking));
    }
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

//  Future<void> _getMap() async {
//    List<Permissions> permissions = await Permission.getPermissionsStatus([PermissionName.Location]);
//    print('### PERMISSION ### ${permissions.toString()}');
//  }

}
