import 'package:gui/models/reponse.dart';

abstract class FenixRepository {

  //Recuperation du token mobile money
  Future<Reponse> payer(String secret, String reference);

  Future<Reponse> confirmer(String id, int action, String token);
}