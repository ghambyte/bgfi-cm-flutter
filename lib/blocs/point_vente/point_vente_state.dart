import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/agences.dart';

class PointVenteState extends BlocState{}


class PointVenteUninitialized extends PointVenteState {
  @override
  String toString() => 'PointVenteUninitialized';
}

class PointVenteError extends PointVenteState {

  final String error;

  PointVenteError({this.error});

  @override
  String toString() => 'PointVenteError';
}

class PointVenteLoaded extends PointVenteState {
  final List<Agences> agences;
  final bool hasReachedMax;
  final int page;
  final String error;


  PointVenteLoaded({
    this.agences,
    this.hasReachedMax,
    this.page: 0,
    this.error
  });

  PointVenteLoaded copyWith({
    List<Agences> agences,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return PointVenteLoaded(
      agences: agences ?? this.agences,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'PointVenteError { posts: ${agences.length}, hasReachedMax: $hasReachedMax }';
}