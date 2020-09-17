import 'package:gui/models/reponse.dart';

abstract class TransfertGabRepository {

  //Recuperation du token mobile money
  Future<Reponse> payer(String secret, double montant, String isgimac);

  Future<Reponse> confirmer(String id, int action, String isgimac, String token);
}