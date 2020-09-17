import 'package:gui/models/reponse.dart';

abstract class PaiementLineRepository {

  //Recuperation du token mobile money
  Future<Reponse> payer(String secret, String reference);

  Future<Reponse> confirmer(String id, String token);
}