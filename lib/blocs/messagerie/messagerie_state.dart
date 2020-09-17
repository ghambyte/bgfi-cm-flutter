import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/models/messagerie.dart';

class MessagerieState extends BlocState{}

class MessagerieInitialized extends MessagerieState {

  MessagerieInitialized();

  @override
  String toString() => 'MessagerieInitialized';
}

class MessagerieUninitialized extends MessagerieState {
  @override
  String toString() => 'MessagesUninitialized';
}

class MessagerieError extends MessagerieState {

  final String error;

  MessagerieError({this.error});

  @override
  String toString() => 'MessagesError';
}

class MessagerieSuccess extends MessagerieState {

  final String success;

  MessagerieSuccess({this.success});

  @override
  String toString() => 'MessagerieSuccess';
}

class MessagerieLoaded extends MessagerieState {
  final List<Messagerie> messages;
  final bool hasReachedMax;
  final int page;
  final String error;


  MessagerieLoaded({
    this.messages,
    this.hasReachedMax,
    this.page: 0,
    this.error
  });

  MessagerieLoaded copyWith({
    List<Messagerie> messages,
    bool hasReachedMax,
    int page,
    String error
  }) {
    return MessagerieLoaded(
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'Messagerie { posts: ${messages.length}, hasReachedMax: $hasReachedMax }';
}