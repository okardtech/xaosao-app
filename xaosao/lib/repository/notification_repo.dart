import 'dart:io';

import 'package:xaosao/models/notification_item_model.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../services/base_repo.dart';

class NotificationRepo extends BaseRepository {
  Future<ApiResponse<NotificationListData>> getNotifications({
    int page = 1,
    int limit = 20,
  }) {
    return safeCall(
      () => api.get('${ApiConstants.myNotificaiton}?page=$page&limit=$limit'),
      fromJson: (json) =>
          NotificationListData.fromJson(json as Map<String, dynamic>),
      authRequired: true,
    );
  }

  Future<ApiResponse<bool>> markRead({required List<String> ids}) {
    return safeCall(
      () => api.post(
        ApiConstants.notificationRead,
        data: {'notification_ids': ids},
      ),
      fromJson: (_) => true,
      authRequired: true,
    );
  }

  Future<ApiResponse<bool>> markAllRead() {
    return safeCall(
      () => api.post(ApiConstants.notificationReadAll),
      fromJson: (_) => true,
      authRequired: true,
    );
  }

  /// Registers this device's push token with the backend so the server can
  /// target it. Called from [NotificationService.syncTokenToServer] — the
  /// single place that owns token acquisition + registration.
  /// Remove this phone's push registration for the logged-in account.
  ///
  /// The backend keeps one row per (account, platform), so deleting the
  /// row for this platform is deleting this phone. Called on logout: a
  /// registered Android phone counts as reachable for calls, so a logged-out
  /// phone left registered would keep ringing for an account no longer on it.
  Future<void> unregisterThisDevice() async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final res = await safeCall<List<dynamic>>(
      () => api.get('${ApiConstants.myNotificaiton}/devices'),
      fromJson: (j) => j is List ? j : (j is Map ? (j['devices'] as List? ?? []) : []),
    );
    for (final d in res.data ?? const []) {
      if (d is Map && d['platform'] == platform && d['id'] != null) {
        await safeCall(
          () => api.delete('${ApiConstants.myNotificaiton}/devices/${d['id']}'),
        );
      }
    }
  }

  Future<ApiResponse<bool>> registerDevice({required String deviceToken}) {
    return safeCall(
      () => api.post(
        '${ApiConstants.myNotificaiton}/register-device',
        data: {
          'device_token': deviceToken,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
      ),
      fromJson: (_) => true,
      authRequired: true,
    );
  }

  Future<ApiResponse<int>> unreadCount() {
    return safeCall(
      () => api.get(ApiConstants.notificationUnreadCount),
      fromJson: (json) => (json as Map<String, dynamic>)['unread_count'] as int? ?? 0,
      authRequired: true,
    );
  }
}
