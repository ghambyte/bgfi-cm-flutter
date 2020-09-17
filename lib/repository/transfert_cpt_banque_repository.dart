
import 'package:gui/models/reponse.dart';

abstract class TransfertCompteBanqueRepository {

  Future<Reponse> payer(String secret, double montant, String banque, String pays, String titnom, String titprenom, String compte);

  Future<Reponse> confirmer(String id, int action, String token);

  Future<Reponse> savePreference(String libelle, String banque,String codeBanque, String codeAgence, String pays, String codePays, String nom, String prenom, String compte);

  Future<Reponse> getPreferences();

}