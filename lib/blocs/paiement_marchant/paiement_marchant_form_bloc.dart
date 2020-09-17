
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/input_length_validator.dart';
import 'package:gui/validator/password_validator.dart';
import 'package:rxdart/rxdart.dart';

class PaiementMarchantFormBloc extends Object with PasswordValidator, InputLengthValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _codeMarchantController = BehaviorSubject<String>();
  final BehaviorSubject<String> _montantController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onCodeMarchantChanged => _codeMarchantController.sink.add;
  Function(String) get onMontantChanged => _montantController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(secretValidation);
  Stream<String> get codeMarchant => _codeMarchantController.stream.transform(inputValidation);
  Stream<String> get montant => _montantController.stream.transform(inputValidation);

  Stream<bool> get submitValidation => Observable.combineLatest3(
      secret,
      codeMarchant,
      montant,
          (s, c, m) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _codeMarchantController?.close();
    _montantController?.close();
    // TODO: implement dispose
  }


}