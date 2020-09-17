import 'dart:async';

class TransfertCVValidator {

  final validateSecret = StreamTransformer<String, String>.fromHandlers(
    handleData: (secret, sink) {
      if (secret.length>1) {
        sink.add(secret);
      } else {
        print('SECRET INVALIDE');
        sink.addError('SECRET INVALIDE');
      }
    }
  );

  final validateSource = StreamTransformer<String, String>.fromHandlers(
    handleData: (source, sink) {
      if (source.length>1) {
        sink.add(source);
      } else {
        print('SOURCE INVALIDE');
        sink.addError('SOURCE INVALIDE');
      }
    }
  );

  final validateMotif = StreamTransformer<String, String>.fromHandlers(
    handleData: (motif, sink) {
      if (motif.length>1) {
        sink.add(motif);
      } else {
        print('MOTIF INVALIDE');
        sink.addError('MOTIF INVALIDE');
      }
    }
  );

  final validateNroCptVirtuel = StreamTransformer<String, String>.fromHandlers(
    handleData: (nroCptVirtuel, sink) {
      if (nroCptVirtuel.length>1) {
        sink.add(nroCptVirtuel);
      } else {
        print('NRO COMPTE VIRTUEL INVALIDE');
        sink.addError('NRO COMPTE VIRTUEL INVALIDE');
      }
    }
  );

  final validateMontant = StreamTransformer<String, String>.fromHandlers(
    handleData: (montant, sink) {
      if (montant.length>1) {
        sink.add(montant);
      } else {
        print('MONTANT INVALIDE');
        sink.addError('MONTANT INVALIDE');
      }
    }
  );
}