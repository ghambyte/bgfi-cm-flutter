import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/taux_change.dart';

class TauxChangeState extends BlocState{}


class TauxChangeUninitialized extends TauxChangeState {
  @override
  String toString() => 'TauxChangeUninitialized';
}

class TauxChangeError extends TauxChangeState {

  final String error;

  TauxChangeError({this.error});

  @override
  String toString() => 'TauxChangeError';
}

class TauxChangeLoaded extends TauxChangeState {
  final List<TauxChange> tauxChange;
  final bool hasReachedMax;
  final int page;
  final String error;


  TauxChangeLoaded({
    this.tauxChange,
    this.hasReachedMax,
    this.page: 0,
    this.error
  });

  TauxChangeLoaded copyWith({
    List<TauxChange> tauxChange,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return TauxChangeLoaded(
      tauxChange: tauxChange ?? this.tauxChange,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'TauxChangeError { posts: ${tauxChange.length}, hasReachedMax: $hasReachedMax }';
}