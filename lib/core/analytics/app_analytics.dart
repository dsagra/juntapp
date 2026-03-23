import 'package:firebase_analytics/firebase_analytics.dart';

class AppAnalytics {
  AppAnalytics(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> logLoginSuccess() => _safeLog('login_google_success');

  Future<void> logLoginError(String code) =>
      _safeLog('login_google_error', {'code': code});

  Future<void> logLogout() => _safeLog('logout');

  Future<void> logEventCreated({required bool autoApproveReceipts}) =>
      _safeLog('event_created', {'auto_approve_receipts': autoApproveReceipts});

  Future<void> logEventDeleted() => _safeLog('event_deleted');

  Future<void> logParticipantsBulkAdded(int count) =>
      _safeLog('participants_bulk_added', {'count': count});

  Future<void> logPaymentSubmitted() => _safeLog('payment_submitted');

  Future<void> logPaymentApproved() => _safeLog('payment_approved');

  Future<void> logPaymentRejected() => _safeLog('payment_rejected');

  Future<void> logPublicLinkShared(String channel) =>
      _safeLog('public_link_shared', {'channel': channel});

  Future<void> logPublicSuccessPromoClicked(String cta) =>
      _safeLog('public_success_promo_clicked', {'cta': cta});

  Future<void> _safeLog(String name, [Map<String, Object?>? parameters]) async {
    final sanitized = <String, Object>{};
    parameters?.forEach((key, value) {
      if (value == null) return;
      if (value is String || value is num || value is bool) {
        sanitized[key] = value;
      }
    });

    try {
      await _analytics.logEvent(name: name, parameters: sanitized);
    } catch (_) {}
  }
}
