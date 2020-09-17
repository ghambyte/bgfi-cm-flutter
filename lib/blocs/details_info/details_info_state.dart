import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_details_info.dart';

class DetailsInfoState extends BlocState{}


class DetailsInfoUninitialized extends DetailsInfoState {
  @override
  String toString() => 'DetailsInfoUninitialized';
}

class DetailsInfoInitialized extends DetailsInfoState {
  @override
  String toString() => 'DetailsInfoInitialized';
}

class DetailsInfoError extends DetailsInfoState {

  final String error;

  DetailsInfoError({this.error});

  @override
  String toString() => 'DetailsInfoError';
}

class DetailsInfoLoaded extends DetailsInfoState {

  final List<NFDetailsInfo> nfdetailsinfos;


  DetailsInfoLoaded({
    this.nfdetailsinfos
  });

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfdetailsinfos.length}}';
}