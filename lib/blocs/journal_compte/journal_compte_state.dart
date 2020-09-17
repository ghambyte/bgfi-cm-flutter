import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/journal_compte.dart';

class JournalCompteState extends BlocState{}


class JournalCompteUninitialized extends JournalCompteState {
  @override
  String toString() => 'JournalCompteUninitialized';
}

class JournalCompteError extends JournalCompteState {

  final String error;

  JournalCompteError({this.error});

  @override
  String toString() => 'JournalCompteError';
}

class JournalCompteLoaded extends JournalCompteState {
  final List<JournalCompte> journalCompte;
  final List<JournalCompte> journalJour;
  final bool hasReachedMax;
  final int page;
  final String error;


  JournalCompteLoaded({
    this.journalCompte,
    this.journalJour,
    this.hasReachedMax,
    this.page: 0,
    this.error
  });

  JournalCompteLoaded copyWith({
    List<JournalCompte> journalCompte,
    List<JournalCompte> journalJour,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return JournalCompteLoaded(
      journalCompte: journalCompte ?? this.journalCompte,
      journalJour: journalJour ?? this.journalJour,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'JournalCompteError { posts: ${journalCompte.length}, hasReachedMax: $hasReachedMax }';
}