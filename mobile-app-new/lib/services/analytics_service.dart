import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@Riverpod(keepAlive: true)
FirebaseAnalytics analytics(Ref ref) => FirebaseAnalytics.instance;
