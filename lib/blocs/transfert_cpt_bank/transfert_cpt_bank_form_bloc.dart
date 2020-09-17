
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/input_length_validator.dart';
import 'package:gui/validator/password_validator.dart';
import 'package:rxdart/rxdart.dart';

class TransfertCompteBanqueFormBloc extends Object with PasswordValidator, InputLengthValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _montantController = BehaviorSubject<String>();
  final BehaviorSubject<String> _banqueController = BehaviorSubject<String>();
  final BehaviorSubject<String> _paysController = BehaviorSubject<String>();
  final BehaviorSubject<String> _titnomController = BehaviorSubject<String>();
  final BehaviorSubject<String> _titprenomController = BehaviorSubject<String>();
  final BehaviorSubject<String> _compteController = BehaviorSubject<String>();
  final BehaviorSubject<String> _agenceController = BehaviorSubject<String>();
  final BehaviorSubject<String> _codeBanqueController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onMontantChanged => _montantController.sink.add;
  Function(String) get onBanqueChanged => _banqueController.sink.add;
  Function(String) get onPaysChanged => _paysController.sink.add;
  Function(String) get onTitnomChanged => _titnomController.sink.add;
  Function(String) get onTitprenomChanged => _titprenomController.sink.add;
  Function(String) get onCompteChanged => _compteController.sink.add;
  Function(String) get onAgenceChanged => _agenceController.sink.add;
  Function(String) get onCodeBanqueChanged => _codeBanqueController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(secretValidation);
  Stream<String> get montant => _montantController.stream.transform(inputValidation);
  Stream<String> get banque => _banqueController.stream.transform(inputValidation);
  Stream<String> get pays => _paysController.stream.transform(inputValidation);
  Stream<String> get titnom => _titnomController.stream.transform(inputValidation);
  Stream<String> get titprenom => _titprenomController.stream.transform(inputValidation);
  Stream<String> get compte => _compteController.stream.transform(inputValidation);
  Stream<String> get agence => _agenceController.stream.transform(inputValidation);
  Stream<String> get codeBanque => _codeBanqueController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest7(
      secret,
      montant,
      banque,
      titnom,
      titprenom,
      compte,
      agence,
          (s, mo, b, tn, tp, c, a) => true
  );

  Stream<bool> get submitPreference => Observable.combineLatest6(
      banque,
      pays,
      titnom,
      titprenom,
      compte,
      agence,
          (b, p, tn, tp, c, a) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _banqueController?.close();
    _paysController?.close();
    _titprenomController?.close();
    _titnomController?.close();
    _compteController?.close();
    _agenceController?.close();
    _codeBanqueController?.close();
    _montantController?.close();
    // TODO: implement dispose
  }


}