import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/virement_virtuel.dart';

class VirementsVirtuelsState extends BlocState{}


class VirementsVirtuelsInitialized extends VirementsVirtuelsState {

  VirementsVirtuelsInitialized();

  @override
  String toString() => 'VirementsVirtuelsInitialized';
}

class VirementsVirtuelsUninitialized extends VirementsVirtuelsState {
  @override
  String toString() => 'VirementsVirtuelsUninitialized';
}

class VirementsVirtuelsError extends VirementsVirtuelsState {

  final String error;

  VirementsVirtuelsError({this.error});

  @override
  String toString() => 'VirementsVirtuelsError';
}

class VirementsVirtuelsSuccess extends VirementsVirtuelsState {

  final String success;

  VirementsVirtuelsSuccess({this.success});

  @override
  String toString() => 'VirementsVirtuelsSuccess';
}

class VirementsVirtuelsLoaded extends VirementsVirtuelsState {
  final List<VirementVirtuel> virementsVirtuels;
  final bool hasReachedMax;
  final int page;
  final String error;


  VirementsVirtuelsLoaded({
    this.virementsVirtuels,
    this.hasReachedMax,
    this.page: 0,
    this.error
  });

  VirementsVirtuelsLoaded copyWith({
    List<VirementVirtuel> virementsVirtuels,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return VirementsVirtuelsLoaded(
      virementsVirtuels: virementsVirtuels ?? this.virementsVirtuels,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'TauxChangeError { posts: ${virementsVirtuels.length}, hasReachedMax: $hasReachedMax }';
}