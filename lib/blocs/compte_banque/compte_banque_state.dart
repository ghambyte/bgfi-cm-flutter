import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/compte.dart';
import 'package:gui/models/nf_confirm_response.dart';

class CompteBanqueState extends BlocState{}


class CompteBanqueUninitialized extends CompteBanqueState {
  @override
  String toString() => 'JournalCompteUninitialized';
}

class CompteBanqueError extends CompteBanqueState {

  final String error;

  CompteBanqueError({this.error});

  @override
  String toString() => 'JournalCompteError';
}

class CompteBanqueLoaded extends CompteBanqueState {
  final List<Compte> comptes;
  final String error;


  CompteBanqueLoaded({
    this.comptes,
    this.error
  });

  CompteBanqueLoaded copyWith({
    List<Compte> comptes,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return CompteBanqueLoaded(
      comptes: comptes ?? this.comptes,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'JournalCompteError { posts: ${comptes.length}}';
}