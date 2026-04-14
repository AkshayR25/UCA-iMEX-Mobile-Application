import 'package:thingsboard_app/modules/alarm/domain/repository/alarms/i_alarms_repository.dart';
import 'package:thingsboard_app/thingsboard_client.dart';
import 'package:thingsboard_app/utils/usecase.dart';

// Matches the "-(email@domain.com)" suffix appended to alarm type names.
final _emailSuffixRegExp = RegExp(r'\s*-\([^)]*\)\s*$');
final _emailExtractRegExp = RegExp(r'-\(([^)]+)\)');

/// Strips the "-(email)" suffix from an alarm type string for display.
String stripEmailFromAlarmType(String type) =>
    type.replaceAll(_emailSuffixRegExp, '').trim();

class FetchAlarmsUseCase
    extends UseCase<Future<PageData<AlarmInfo>>, AlarmQueryV2> {
  const FetchAlarmsUseCase({
    required this.repository,
    required this.userEmail,
  });

  final IAlarmsRepository repository;

  /// The email of the currently logged-in user (lower-cased for comparison).
  final String userEmail;

  @override
  Future<PageData<AlarmInfo>> call(AlarmQueryV2 params) async {
    final pageData = await repository.fetchAlarms(params);

    // Filter: keep alarms that have no email in the type, or whose email
    // matches the current user.
    pageData.data = pageData.data.where((alarm) {
      final match = _emailExtractRegExp.firstMatch(alarm.type);
      if (match == null) return true; // no email tag — always show
      return match.group(1)?.toLowerCase() == userEmail.toLowerCase();
    }).toList();

    return pageData;
  }
}
