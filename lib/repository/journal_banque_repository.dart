
import 'package:gui/models/reponse.dart';

abstract class JournalBanqueRepository {

  Future<Reponse> getJournal(int index, String type);
}