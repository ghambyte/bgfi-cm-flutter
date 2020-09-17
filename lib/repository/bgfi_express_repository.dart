import 'package:gui/models/reponse.dart';

abstract class BgfiExpressRepository {

  //Recuperation du token mobile money
  Future<Reponse> payer(String secret, double montant, String mobile, String pays, String nom, String prenom, String question, String reponse);

  Future<Reponse> confirmer(String id, int action, String token);
}