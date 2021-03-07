import 'package:flutter/material.dart';
import 'package:freecodecamp/views/training/training_view.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:stacked/stacked.dart';
import 'splash_view_model.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (BuildContext context, SplashViewModel viewModel, Widget _) {
        return SplashScreen(
          loaderColor: Color(0xFF1b1b32),
          backgroundColor: Color(0xfff5f6f7),
          loadingText: Text(
            "Loading",
            style: TextStyle(
              color: Color(0xff0a0a23),
              fontSize: height * 0.03,
            ),
          ),
          photoSize: width * 0.4,
          image: Image.asset('assets/images/splash_screen.png'),
          navigateAfterSeconds: TrainingView(),
          seconds: 2,
        );
      },
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
