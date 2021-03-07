// [ This is an auto generated file ]

import 'package:flutter/material.dart';
import 'package:freecodecamp/core/router_constants.dart';

import 'package:freecodecamp/views/splash/splash_view.dart' as view0;
import 'package:freecodecamp/views/training/training_view.dart' as view1;
import 'package:freecodecamp/views/forum/forum_view.dart' as view2;
import 'package:freecodecamp/views/news/news_view.dart' as view3;
import 'package:freecodecamp/views/radio/radio_view.dart' as view4;
import 'package:freecodecamp/views/donation/donation_view.dart' as view5;
import 'package:freecodecamp/views/faq/faq_view.dart' as view6;

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashViewRoute:
        return MaterialPageRoute(builder: (_) => view0.SplashView());
      case trainingViewRoute:
        return MaterialPageRoute(builder: (_) => view1.TrainingView());
      case forumViewRoute:
        return MaterialPageRoute(builder: (_) => view2.ForumView());
      case newsViewRoute:
        return MaterialPageRoute(builder: (_) => view3.NewsView());
      case radioViewRoute:
        return MaterialPageRoute(builder: (_) => view4.RadioView());
      case donationViewRoute:
        return MaterialPageRoute(builder: (_) => view5.DonationView());
      case faqViewRoute:
        return MaterialPageRoute(builder: (_) => view6.FaqView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}