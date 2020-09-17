import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/nf_operation.dart';

class InfoState extends BlocState{}


class InfoUninitialized extends InfoState {
  @override
  String toString() => 'InfoUninitialized';
}

class InfoError extends InfoState {

  final String error;

  InfoError({this.error});

  @override
  String toString() => 'InfoError';
}

class InfoLoaded extends InfoState {
  final List<NFOperation> nfoperations;
  final bool hasReachedMax;
  final int page;
  final String error;


  InfoLoaded({
    this.nfoperations,
    this.hasReachedMax,
    this.page: 0,
    this.error
  });

  InfoLoaded copyWith({
    List<NFOperation> nfoperations,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return InfoLoaded(
      nfoperations: nfoperations ?? this.nfoperations,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'InfoLoaded { posts: ${nfoperations.length}, hasReachedMax: $hasReachedMax }';
}