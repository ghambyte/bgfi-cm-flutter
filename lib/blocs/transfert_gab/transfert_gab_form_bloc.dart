
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/input_length_validator.dart';
import 'package:gui/validator/password_validator.dart';
import 'package:rxdart/rxdart.dart';

class TransfertGabFormBloc extends Object with PasswordValidator, InputLengthValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _montantController = BehaviorSubject<String>();
  final BehaviorSubject<String> _paysController = BehaviorSubject<String>();
  final BehaviorSubject<String> _mobileController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onMontantChanged => _montantController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(secretValidation);
  Stream<String> get montant => _montantController.stream.transform(inputValidation);
  Stream<String> get pays => _montantController.stream.transform(inputValidation);
  Stream<String> get mobile => _mobileController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest4(
      secret,
      montant,
      pays,
      mobile,
          (s, c, p, m) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _montantController?.close();
    _paysController?.close();
    _mobileController?.close();
    // TODO: implement dispose
  }


}