import 'package:gui/blocs/bloc_event_state.dart';

class SplashState extends BlocState {

  SplashState({
    this.isInit: false,
    this.notInit: false
  });

  final bool isInit;

  final bool notInit;

  factory SplashState.init() {
    return SplashState(
      isInit: true,
    );
  }

  factory SplashState.not() {
    return SplashState(
      notInit: true,
    );
  }
}