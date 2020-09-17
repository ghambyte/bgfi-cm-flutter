
import 'package:gui/models/reponse.dart';

abstract class MessagerieRepository {

  Future<Reponse> getMessages(int index, String type);

  Future<Reponse> send(String objet, String compte, String agence, String message);

}