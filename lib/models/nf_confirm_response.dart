
import 'package:gui/models/nf_details_info.dart';

class NFConfirmResponse {

 String token;

 String idtransaction;

 String solde;

 List<NFDetailsInfo> recaps ;

 NFConfirmResponse.fromMap(Map<String, dynamic> map)
     : token = map["token"],
       recaps = map['recap'].map<NFDetailsInfo>((recap) => NFDetailsInfo.fromMap(recap)).toList(),
       solde = map['solde'],
       idtransaction = map["idtransaction"];

}