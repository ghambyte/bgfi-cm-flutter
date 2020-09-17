
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/Login_validator.dart';
import 'package:gui/validator/input_length_validator.dart';
import 'package:rxdart/rxdart.dart';

class CompteBanqueFormBloc extends Object with LoginValidator, InputLengthValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _montantController = BehaviorSubject<String>();
  final BehaviorSubject<String> _mobileController = BehaviorSubject<String>();
  final BehaviorSubject<String> _carrierController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onMontantChanged => _montantController.sink.add;
  Function(String) get onMobileChanged => _mobileController.sink.add;
  Function(String) get onCarrierChanged => _carrierController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(validatepassword);
  Stream<String> get montant => _montantController.stream.transform(inputValidation);
  Stream<String> get mobile => _mobileController.stream.transform(validateMobileMM);
  Stream<String> get carrier => _carrierController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest4(
      secret,
      montant,
      carrier,
      mobile,
          (s, m, c, mb) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _carrierController?.close();
    _mobileController?.close();
    _montantController?.close();
    // TODO: implement dispose
  }


}