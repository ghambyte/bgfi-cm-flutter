import 'package:gui/blocs/bloc_provider.dart';
import 'package:gui/blocs/bloc_widgets/bloc_state_builder.dart';
import 'package:gui/blocs/splash/splash_bloc.dart';
import 'package:gui/blocs/splash/splash_event.dart';
import 'package:gui/blocs/splash/splash_state.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();
    slides.add(
      new Slide(
        backgroundImage: 'images/1.png',
        backgroundOpacity: 0.0,
        backgroundImageFit: BoxFit.cover,
      ),
    );
    slides.add(
      new Slide(
        backgroundImage: 'images/2.png',
        backgroundOpacity: 0.0,
        backgroundImageFit: BoxFit.cover,
      ),
    );
    slides.add(
      new Slide(
        backgroundImage: 'images/3.png',
        backgroundOpacity: 0.0,
        backgroundImageFit: BoxFit.cover,
      ),
    );
    slides.add(
      new Slide(
        backgroundImage: 'images/4.png',
        backgroundOpacity: 0.0,
        backgroundImageFit: BoxFit.cover,
      ),
    );
  }

  void onDonePress(BuildContext context, SplashBloc bloc) {
    // TODO: go to next screen
    bloc.emitEvent(SplashEventLogin(name: 'ok'));
    Navigator.of(context).pushReplacementNamed("/home");
  }

  void onSkipPress(BuildContext context, SplashBloc bloc) {
    // TODO: go to next screen
    bloc.emitEvent(SplashEventLogin(name: 'ok'));
    Navigator.of(context).pushReplacementNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    SplashBloc bloc = BlocProvider.of<SplashBloc>(context);
    return BlocEventStateBuilder<SplashState>(
        bloc: bloc,
        builder: (BuildContext context, SplashState state) {
          return new IntroSlider(
            slides: this.slides,
            onDonePress: () => this.onDonePress(context, bloc),
            onSkipPress: () => this.onSkipPress(context, bloc),
          );
        }
    );
  }
}
