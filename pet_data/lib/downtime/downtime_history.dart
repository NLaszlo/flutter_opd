import 'package:pet_data/downtime/downtime.dart';

class DowntimeHistory {
  final String? userID;
  final String? comment;
  final DateTime time;
  final DowntimeStatus newStatus;
  final DowntimeStatus oldStatus;
  final int? currentOperationID;
  final int? currentReasonID;
  final int? currentSubReasonID;
  final String? escalationDescription;

  const DowntimeHistory(
      {required this.userID,
      required this.comment,
      required this.time,
      required this.newStatus,
      required this.oldStatus,
      required this.currentOperationID,
      required this.currentReasonID,
      required this.currentSubReasonID,
      required this.escalationDescription});

  factory DowntimeHistory.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'UserID': String? userID,
        'Comment': String? comment,
        'Time': String time,
        'NewStatus': int newStatus,
        'OldStatus': int oldStatus,
        'CurrentOperationID': int? currentOperationID,
        'CurrentReasonID': int? currentReasonID,
        'CurrentSubReasonID': int? currentSubReasonID,
        'EscalationDescription': String? escalationDescription
      } =>
        DowntimeHistory(
            userID: userID,
            comment: comment,
            time: DateTime.parse(time),
            newStatus: DowntimeStatus.values[newStatus],
            oldStatus: DowntimeStatus.values[oldStatus],
            currentOperationID: currentOperationID,
            currentReasonID: currentReasonID,
            currentSubReasonID: currentSubReasonID,
            escalationDescription: escalationDescription),
      _ => throw const FormatException('Failed to load DowntimeHistory.'),
    };
  }
}
