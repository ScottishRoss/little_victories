import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver appAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ignore: avoid_void_async
  void logEvent(String name, Map<String, Object?> parameters) async {
    await FirebaseAnalytics.instance
        .logEvent(name: name, parameters: parameters);
  }
}
