// [ This is an auto generated file ]

import 'package:flutter/material.dart';
import 'package:freecodecamp/core/router_constants.dart';

import 'package:freecodecamp/views/splash/splash_view.dart' as view0;
import 'package:freecodecamp/views/training/training_view.dart' as view1;
import 'package:freecodecamp/views/forum/forum_view.dart' as view2;
import 'package:freecodecamp/views/news/news_view.dart' as view4;

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
        return MaterialPageRoute(builder: (_) => view4.NewsView());      
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
