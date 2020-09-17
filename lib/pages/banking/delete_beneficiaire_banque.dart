
import 'package:flutter/material.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/login/login_bloc.dart';
import 'package:gui/blocs/point_vente/point_vente_state.dart';
import 'package:gui/blocs/virements_banque/virements_banque_bloc.dart';
import 'package:gui/blocs/virements_banque/virements_banque_event.dart';
import 'package:gui/blocs/virements_banque/virements_banque_state.dart';
import 'package:gui/models/beneficiaire.dart';
import 'package:gui/tools/color_app.dart';
import 'package:gui/tools/config.dart';
import 'package:gui/tools/utils.dart';
import 'package:gui/widgets/banking_standard_app_bar.dart';
import 'package:gui/widgets/item_banking_beneficiaire_toggle.dart';
import 'package:gui/widgets/error_widget.dart';
import 'package:gui/widgets/item_details_jb_line.dart';

class DeleteBeneficiairePage extends StatefulWidget {
  @override
  _DeleteBeneficiairePageState createState() => _DeleteBeneficiairePageState();
}

class _DeleteBeneficiairePageState extends State<DeleteBeneficiairePage> with BankingStandardAppBar, ErrorWideget{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();
  final VirementsBanqueBloc _virementsBanqueBloc = VirementsBanqueBloc();
  LoginBloc _loginBloc;
  int page = 0;
  List<int> visibility =[];
  List<Beneficiaire> beneficiaires = [];

  @override
  void initState() {
    // TODO: implement initState
    _virementsBanqueBloc
        .emitEvent(GetPreference());
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget content(List<Beneficiaire> beneficiaires) {
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
                      child: ItemBankingBeneficiaireToggle(
                          leading: visibility.contains(index),
                          title: '${beneficiaires[index].nombeneficiaire}',
                          trailing: '${beneficiaires[index].id}',
                          virementsBanqueBloc: _virementsBanqueBloc,
                      ),
                    ),
                    visibility.contains(index)
                        ? Column(
                      children: <Widget>[
                        Divider(),
                        ItemDetailsLineJBPage(cle: 'Nom', value: beneficiaires[index].nombeneficiaire,),
                        Divider(),
                        ItemDetailsLineJBPage(cle: 'Nro de compte', value: beneficiaires[index].numerocompte,),
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
        itemCount: beneficiaires.length,
        //controller: _scrollController,
      );
    }
    return Scaffold(
      appBar: appBar(
          context, Config.serviceMBanking, _loginBloc, "Suppression bénéficiaire"),
      body: BlocEventStateBuilder<VirementsBanqueState>(
        bloc: _virementsBanqueBloc,
        builder: (BuildContext context, VirementsBanqueState state) {
          if(state is VirementsBanqueInitialized) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(ColorApp.blue)),);
          }
          if(state is VirementsBanqueError) {
            return buildError(context, state.error, ColorApp.blue);
          }
          if (state is VirementsBanqueGetPreference) {
            Utils.onWidgetDidBuild(() {
              beneficiaires = state.beneficiaires;
            });
          }
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            child: Padding(padding: EdgeInsets.only(top: 10.0), child: content(beneficiaires),),
            onRefresh: () => refresh(),
          );
        },
      ),
      backgroundColor: ColorApp.background,
    );
  }

  @override
  Future refresh() async {
    visibility =[];
    _virementsBanqueBloc
        .emitEvent(GetPreference());
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
      _virementsBanqueBloc
          .emitEvent(GetPreference());
    }
  }

}
