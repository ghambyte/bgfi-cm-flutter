
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/messagerie/messagerie_event.dart';
import 'package:gui/blocs/messagerie/messagerie_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/messagerie.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/messagerie_repository.dart';
import 'package:gui/tools/config.dart';

class MessagerieBloc extends BlocEventStateBase<MessagerieEvent, MessagerieState> {

  MessagerieRepository _messagerieRepository = new InjectorApp().messagerieRepository;

  MessagerieBloc():super(initialState: MessagerieUninitialized());

  @override
  Stream<MessagerieState> eventHandler(MessagerieEvent event, MessagerieState currentState) async* {

    if(event is Post) {

      yield MessagerieInitialized();

      Reponse response = await _messagerieRepository
          .send(event.objet, event.compte, event.agence, event.message)
          .then((rep)=> rep)
          .catchError((onError)=> onError.response);
      if(response.statutcode == Config.codeSuccess) {
        yield MessagerieSuccess(success: response.message);
      } else {
        yield MessagerieError(error: response.message);
      }

      await Future.delayed(Duration(seconds: 1));
      yield MessagerieUninitialized();
    }

    if (event is Fetch) {
      if(event.init) {
        yield MessagerieUninitialized();
        try{
          final messages = await _fetchMessagerie(0, event.type);
          if(messages.length>0){
            yield MessagerieLoaded(messages: messages, hasReachedMax: false, page: 0);
          } else if(currentState is MessagerieLoaded){
            yield MessagerieLoaded(messages: currentState.messages, hasReachedMax: false, page: 0);
          }
        } catch (e) {
          if (currentState is MessagerieLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield MessagerieError(error: e.response.message);
          }
        }
      } else if(!_hasReachedMax(currentState)){

        try {
          if (currentState is MessagerieUninitialized || currentState is MessagerieError) {
            final messages = await _fetchMessagerie(0, event.type);
            yield MessagerieLoaded(messages: messages, hasReachedMax: false, page: 0);
          }
          if (currentState is MessagerieLoaded) {
            final messages = await _fetchMessagerie(currentState.page+1, event.type);
            yield messages.isEmpty
                ? currentState.copyWith(hasReachedMax: true, error: null)
                : MessagerieLoaded(messages: currentState.messages + messages, hasReachedMax: false, page: currentState.page+1);
          }
        } catch (e) {
          if(currentState is MessagerieUninitialized) {
            yield MessagerieError(error: e.response.message);
          }
          if(currentState is MessagerieLoaded) {
            yield currentState.copyWith(error: e.response.message);
          }
        }

      }
    }
  }

  bool _hasReachedMax(MessagerieState state) =>
      state is MessagerieLoaded && state.hasReachedMax;

  Future<List<Messagerie>> _fetchMessagerie(int page, String type) async {
    final Reponse response= await _messagerieRepository.getMessages(page, type);
    if (response.statutcode == Config.codeSuccess) {
      return response.reponse['outgoing'].map<Messagerie>((val) => Messagerie.fromMap(val)).toList();
    } else {
      throw response;
    }
  }

}

