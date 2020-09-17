import 'package:gui/blocs/bloc_event_state.dart';

abstract class SplashEvent extends BlocEvent {
  final String name;

  SplashEvent({
    this.name: '',
  });
}

class SplashEventLogin extends SplashEvent {
  SplashEventLogin({
    String name,
  }) : super(
    name: name,
  );
}