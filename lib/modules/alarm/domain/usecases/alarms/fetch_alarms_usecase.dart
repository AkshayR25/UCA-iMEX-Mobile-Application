import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:thingsboard_app/modules/alarm/domain/repository/alarms/i_alarms_repository.dart';
import 'package:thingsboard_app/thingsboard_client.dart';
import 'package:thingsboard_app/utils/usecase.dart';

// Matches the "-(email@domain.com)" suffix appended to alarm type names.
final _emailSuffixRegExp = RegExp(r'\s*-\([^)]*\)\s*$');

/// Strips the "-(email)" suffix from an alarm type string for display.
String stripEmailFromAlarmType(String type) =>
    type.replaceAll(_emailSuffixRegExp, '').trim();

class FetchAlarmsUseCase
    extends UseCase<Future<PageData<AlarmInfo>>, AlarmQueryV2> {
  FetchAlarmsUseCase({
    required this.repository,
    required this.tbClient,
    required this.userEmail,
  });

  final IAlarmsRepository repository;

  final ThingsboardClient tbClient;

  /// The email of the currently logged-in user (lower-cased for comparison).
  final String userEmail;

  /// Cached future so the "area" attribute API is called only once per instance.
  Future<List<String>?>? _allowedDeviceNamesFuture;

  Future<List<String>?> _getAllowedDeviceNames() {
    return _allowedDeviceNamesFuture ??= _fetchAllowedDeviceNames();
  }

  /// Reads the user's SERVER_SCOPE 'area' attribute — a comma-separated list of
  /// device names the user is allowed to see. Returns null on failure.
  Future<List<String>?> _fetchAllowedDeviceNames() async {
    try {
      final userId = tbClient.getAuthUser()?.userId;
      if (userId == null) return null;

      final attrs = await tbClient.getAttributeService().getAttributesByScope(
        UserId(userId),
        AttributeScope.SERVER_SCOPE.toShortString(),
        ['area'],
      );

      final raw = attrs.isNotEmpty ? attrs.first.getValue()?.toString() : null;
      if (raw == null || raw.isEmpty) return <String>[];

      return raw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('[FetchAlarmsUseCase] failed to fetch user area attribute: $e');
      return null;
    }
  }

  /// Extracts `notifyEmailValue` from the alarm's `details.data` JSON blob.
  /// The `data` field is itself a JSON-encoded string.
  String? _notifyEmailValue(AlarmInfo alarm) {
    final data = alarm.details?['data'];
    if (data == null) return null;

    try {
      final Map<String, dynamic> inner = data is String
          ? jsonDecode(data) as Map<String, dynamic>
          : Map<String, dynamic>.from(data as Map);
      final value = inner['notifyEmailValue'];
      return value?.toString();
    } catch (e) {
      debugPrint('[FetchAlarmsUseCase] failed to parse alarm details: $e');
      return null;
    }
  }

  @override
  Future<PageData<AlarmInfo>> call(AlarmQueryV2 params) async {
    final pageData = await repository.fetchAlarms(params);
    final allowedNames = await _getAllowedDeviceNames();

    pageData.data = pageData.data.where((alarm) {
      // 1) Device access: only alarms for devices in the user's 'area' list.
      //    If the area list is unavailable or empty, no device alarms show.
      if (allowedNames == null ||
          allowedNames.isEmpty ||
          !allowedNames.contains(alarm.originatorName)) {
        return false;
      }

      // 2) Email match: notifyEmailValue must equal the user's email or 'All'.
      //    Alarms without a notifyEmailValue are hidden.
      final notifyEmail = _notifyEmailValue(alarm);
      if (notifyEmail == null) return false;
      return notifyEmail.toLowerCase() == 'all' ||
          notifyEmail.toLowerCase() == userEmail.toLowerCase();
    }).toList();

    return pageData;
  }
}
