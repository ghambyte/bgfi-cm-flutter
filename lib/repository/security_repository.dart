
import 'package:gui/models/reponse.dart';

abstract class SecurityRepository {

  //Recuperation du token mobile money
  Future getTokenDevice();

  //Connexion Mobile money mobile Banking
  Future<Reponse> login(String codeclient, String codesecret, String type);

  //Inscription Mobile money
  Future<Reponse> subscribe(String datenaissance, String secret, String mobile, String prenom, String nom,
      String sexe, String email, String reponse, String question, String pays, String typepiece,
      String numeropiece, String lieunaissance);

  //Connexion Mobile money mobile Banking
  Future<Reponse> activation(int codeactivation, String type);

  //Status du client
  Future<Reponse> getStatus(String type);

  //Deconnexion Money
  Future<Reponse> signout(String type);

  Future<Reponse> verify(String codesecret, String type);

  Future<Reponse> changeSecret(String codesecret, String nouveauSecret, String confirmSecret, String type);

}