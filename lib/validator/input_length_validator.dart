

import 'dart:async';

class InputLengthValidator {

  final StreamTransformer<String,String> inputValidation = StreamTransformer<String,String>.fromHandlers(handleData: (value, sink) {

    if (value.length > 0) {
      sink.add(value);
    } else {
      sink.addError('Valeur requise ${value.length}');
    }

  });

  final StreamTransformer<String,String> carrierValidation = StreamTransformer<String,String>.fromHandlers(handleData: (value, sink) {

    sink.add("0");

  });

}