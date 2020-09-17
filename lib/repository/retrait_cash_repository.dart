import 'package:gui/models/reponse.dart';

abstract class RetraitCashRepository {

  //Recuperation du token mobile money
  Future<Reponse> payer(String secret, double montant);

  Future<Reponse> confirmer(String id, int action, String token);
}