
import 'package:gui/blocs/bloc_event_state.dart';
import 'package:gui/blocs/journal_compte/journal_compte_event.dart';
import 'package:gui/blocs/journal_compte/journal_compte_state.dart';
import 'package:gui/injector/injectorApp.dart';
import 'package:gui/models/jCompteBank.dart';
import 'package:gui/models/journal_compte.dart';
import 'package:gui/models/reponse.dart';
import 'package:gui/repository/compte_banque_repository.dart';
import 'package:gui/repository/journal_banque_repository.dart';
import 'package:gui/tools/config.dart';

class JournalCompteBloc extends BlocEventStateBase<JournalCompteEvent, JournalCompteState> {

  JournalBanqueRepository _JournalCompteRepository = new InjectorApp().journalBanqueRepository;

  JournalCompteBloc():super(initialState: JournalCompteUninitialized());

  @override
  Stream<JournalCompteState> eventHandler(JournalCompteEvent event, JournalCompteState currentState) async* {

    if (event is Fetch) {
      if(event.init) {
        yield JournalCompteUninitialized();
        try{
          final journalCompte = await _fetchJournalCompte(0, event.type);
          if(journalCompte.journal.length>0){
            yield JournalCompteLoaded(journalCompte: journalCompte.journal, journalJour: journalCompte.journalJour, hasReachedMax: false, page: 0);
          } else if(currentState is JournalCompteLoaded){
            yield JournalCompteLoaded(journalCompte: currentState.journalCompte, journalJour: currentState.journalJour, hasReachedMax: false, page: 0);
          }
        } catch (e) {
          if (currentState is JournalCompteLoaded) {
            yield currentState.copyWith(error: e.response.message);
          } else {
            yield JournalCompteError(error: e.response.message);
          }
        }
      } else if(!_hasReachedMax(currentState)){

        try {
          if (currentState is JournalCompteUninitialized || currentState is JournalCompteError) {
            final journalCompte = await _fetchJournalCompte(0, event.type);
            yield JournalCompteLoaded(journalCompte: journalCompte.journal, journalJour: journalCompte.journalJour, hasReachedMax: false, page: 0);
          }
          if (currentState is JournalCompteLoaded) {
            final journalCompte = await _fetchJournalCompte(currentState.page+1, event.type);
            yield journalCompte.journal.isEmpty
                ? currentState.copyWith(hasReachedMax: true, error: null)
                : JournalCompteLoaded(journalCompte: currentState.journalCompte + journalCompte.journal, journalJour: journalCompte.journalJour, hasReachedMax: false, page: currentState.page+1);
          }
        } catch (e) {
          if(currentState is JournalCompteUninitialized) {
            print('REPONSE error ### ${ currentState.toString()}');
            yield JournalCompteError(error: e.response.message);
          }
          if(currentState is JournalCompteLoaded) {
            yield currentState.copyWith(error: e.response.message);
          }
        }

      }
    }
  }

  bool _hasReachedMax(JournalCompteState state) =>
      state is JournalCompteLoaded && state.hasReachedMax;

  Future<JournalCompteBank> _fetchJournalCompte(int page, String type) async {
    List<JournalCompte> journal;
    List<JournalCompte> journalJour;
    final Reponse response= await _JournalCompteRepository.getJournal(page, type);
    print('REPONSE JOURNAL ### ${response.message}');
    if (response.statutcode == Config.codeSuccess) {
      journal = response.reponse['journal'].map<JournalCompte>((val) => JournalCompte.fromMap(val)).toList();
      journalJour = response.reponse['journal_jour'].map<JournalCompte>((val) => JournalCompte.fromMap(val)).toList();
      print('TAILLE JOURNAL JOUR ******* ### ${journalJour.length}');
      return JournalCompteBank(journalJour: journalJour, journal: journal);
    } else {
      throw response;
    }
  }


}

