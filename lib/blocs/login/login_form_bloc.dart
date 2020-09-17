
import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/validator/Login_validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginFormBloc extends Object with LoginValidator implements BlocBase {

  final BehaviorSubject<String> _mobileMMController = BehaviorSubject<String>();
  final BehaviorSubject<String> _mobileMBController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<String> _activationController = BehaviorSubject<String>();

  //
  //  Inputs
  //
  Function(String) get onMobileMMChanged => _mobileMMController.sink.add;
  Function(String) get onPasswordChanged => _passwordController.sink.add;
  Function(String) get onMobileMBChanged => _mobileMBController.sink.add;
  Function(String) get onActivationChanged => _activationController.sink.add;

  //
  // Validators
  //
  Stream<String> get mobileMM => _mobileMMController.stream.transform(validateMobileMM);
  Stream<String> get mobileMB => _mobileMBController.stream.transform(validateMobileMB);
  Stream<String> get password => _passwordController.stream.transform(validatepassword);
  Stream<String> get activation => _activationController.stream.transform(validateactivation);

  //
  // Login button mobile money
  Stream<bool> get registerValidMM => Observable.combineLatest2(
      mobileMM,
      password,
          (e, p) => true
  );

  // Login button mobile banking
  Stream<bool> get registerValidMB => Observable.combineLatest2(
      mobileMB,
      password,
          (e, p) => true
  );

  Stream<bool> get registerValidActivation => Observable.combineLatest2(
      activation,
      activation,
          (e, p) => true
  );

  @override
  void dispose() {
    _mobileMMController?.close();
    _passwordController?.close();
    _mobileMBController?.close();
    _activationController?.close();
  }
}