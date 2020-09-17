
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/input_length_validator.dart';
import 'package:gui/validator/password_validator.dart';
import 'package:rxdart/rxdart.dart';

class PaiementLineFormBloc extends Object with PasswordValidator, InputLengthValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _referenceController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onReferenceChanged => _referenceController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(secretValidation);
  Stream<String> get reference => _referenceController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest2(
      secret,
      reference,
          (s, r) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _referenceController?.close();
    // TODO: implement dispose
  }


}