import 'package:gui/models/reponse.dart';

abstract class PaiementMarchantRepository {

  //Recuperation du token mobile money
  Future<Reponse> payer(String secret, double montant, String code);

  Future<Reponse> confirmer(String id, int action, String token);
}