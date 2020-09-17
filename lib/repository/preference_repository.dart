
import 'package:gui/models/reponse.dart';

abstract class PreferenceRepository {

  Future<Reponse> savePreference(String libelle, String valeur, String type);

  Future<Reponse> getPreferences(String type);

}