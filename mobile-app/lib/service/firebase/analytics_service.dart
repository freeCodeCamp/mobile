import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:freecodecamp/service/firebase/analytics_observer.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsObserver getAnalyticsObserver() {
    return AnalyticsObserver(analytics: _analytics);
  }

  AnalyticsService._internal();
}
