import 'dart:async';

class LoginValidator {

  final validateMobileMM = StreamTransformer<String, String>.fromHandlers(
    handleData: (mobile, sink) {
      if (mobile.length==9) {
        sink.add(mobile);
      } else {
        sink.addError('PARAMETRES INVALIDES');
      }
    }
  );

  final validateMobileMB = StreamTransformer<String, String>.fromHandlers(
    handleData: (mobile, sink) {
      if (mobile.length==7) {
        sink.add(mobile);
      } else {
        sink.addError('PARAMETRES INVALIDES');
      }
    }
  );

  final validatepassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length==4) {
        sink.add(password);
      } else {
        sink.addError('PARAMETRES INVALIDES');
      }
    }
  );

  final validateactivation = StreamTransformer<String, String>.fromHandlers(
    handleData: (activation, sink) {
      if (activation.length==6) {
        sink.add(activation);
      } else {
        sink.addError("CODE D'ACTIVATION INVALIDE");
      }
    }
  );


}