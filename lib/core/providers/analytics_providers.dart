import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/app_analytics.dart';
import 'firebase_providers.dart';

final appAnalyticsProvider = Provider<AppAnalytics>((ref) {
  final analytics = ref.watch(firebaseAnalyticsProvider);
  return AppAnalytics(analytics);
});
