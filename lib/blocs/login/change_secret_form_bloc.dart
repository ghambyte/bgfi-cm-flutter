
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/Login_validator.dart';
import 'package:rxdart/rxdart.dart';

class ChangeSecretFormBloc extends Object with LoginValidator implements BlocBase {

  final BehaviorSubject<String> _secretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _nouveauSecretController = BehaviorSubject<String>();
  final BehaviorSubject<String> _confirmSecretController = BehaviorSubject<String>();

  Function(String) get onSecretChanged => _secretController.sink.add;
  Function(String) get onNouveauChanged => _nouveauSecretController.sink.add;
  Function(String) get onConfirmChanged => _confirmSecretController.sink.add;

  Stream<String> get secret => _secretController.stream.transform(validatepassword);
  Stream<String> get nouveauxSecret => _nouveauSecretController.stream.transform(validatepassword);
  Stream<String> get confirmSecret => _confirmSecretController.stream.transform(validatepassword);

  Stream<bool> get submitValidation => Observable.combineLatest3(
      secret,
      nouveauxSecret,
      confirmSecret,
          (s, m, c) => true
  );

  @override
  void dispose() {
    _secretController?.close();
    _nouveauSecretController?.close();
    _confirmSecretController?.close();
    // TODO: implement dispose
  }


}