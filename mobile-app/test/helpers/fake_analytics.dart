import 'package:freecodecamp/services/analytics_service.dart';

typedef LoggedEvent = ({String name, Map<String, Object> parameters});

// NOTE: Records what AnalyticsService would send to Firebase.
class FakeAnalyticsSink implements AnalyticsSink {
  final events = <LoggedEvent>[];
  final screens = <ScreenView>[];
  final userProperties = <String, String>{};

  // NOTE: Records compare maps by identity, so tests compare these lists instead.
  List<List<Object>> get logged => [
    for (final event in events) [event.name, event.parameters],
  ];

  @override
  Future<void> logEvent(String name, Map<String, Object> parameters) async =>
      events.add((name: name, parameters: parameters));

  @override
  Future<void> logScreenView(String screenName, String screenClass) async =>
      screens.add((name: screenName, screenClass: screenClass));

  @override
  Future<void> setUserProperty(String name, String value) async =>
      userProperties[name] = value;
}
