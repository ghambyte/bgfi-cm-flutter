import 'dart:async';

class ChequierValidator {

  final validateTypeCheque = StreamTransformer<String, String>.fromHandlers(
    handleData: (type, sink) {
      if (type.length>1) {
        print('TYPE CHEQUE VALIDE');
        sink.add(type);
      } else {
        print('TYPE CHEQUE INVALIDE');
        sink.addError('TYPE CHEQUE INVALIDE');
      }
    }
  );

  final validateVolumeCheque = StreamTransformer<String, String>.fromHandlers(
    handleData: (volume, sink) {
      if (volume.length>1) {
        print('VOLUME CHEQUE VALIDE');
        sink.add(volume);
      } else {
        print('VOLUME CHEQUE INVALIDE');
        sink.addError('VOLUME CHEQUE INVALIDE');
      }
    }
  );

  final validateCompteCheque = StreamTransformer<String, String>.fromHandlers(
    handleData: (volume, sink) {
      if (volume.length>1) {
        print('COMPTE CHEQUE VALIDE');
        sink.add(volume);
      } else {
        print('COMPTE CHEQUE INVALIDE');
        sink.addError('COMPTE CHEQUE INVALIDE');
      }
    }
  );

}