import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/agences.dart';
import 'package:gui/models/gabs.dart';

class ReseauGabState extends BlocState{}


class ReseauGabUninitialized extends ReseauGabState {
  @override
  String toString() => 'ReseauGabUninitialized';
}

class ReseauGabError extends ReseauGabState {

  final String error;

  ReseauGabError({this.error});

  @override
  String toString() => 'ReseauGabError';
}

class ReseauGabLoaded extends ReseauGabState {
  final List<Gabs> gabs;
  final bool hasReachedMax;
  final int page;
  final String error;


  ReseauGabLoaded({
    this.gabs,
    this.hasReachedMax,
    this.page: 0,
    this.error
  });

  ReseauGabLoaded copyWith({
    List<Gabs> gabs,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return ReseauGabLoaded(
      gabs: gabs ?? this.gabs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'ReseauGabError { posts: ${gabs.length}, hasReachedMax: $hasReachedMax }';
}