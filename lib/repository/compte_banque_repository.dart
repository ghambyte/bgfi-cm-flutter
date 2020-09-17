
import 'package:gui/models/reponse.dart';

abstract class CompteBanqueRepository {

  Future<Reponse> payer(String secret, double montant, String mobile, String carrier);

  Future<Reponse> confirmer(String id, int action, String token);

  Future<Reponse> comptes();

}