class Downtime {
  final int downTimeID;
  final DateTime start;
  DateTime? end;
  int activeTime;
  int resolvingTime;
  int operationID;
  DowntimeStatus downTimeStatus;
  int downTimeTypeID;
  late String donwtimeTypeName;
  String downTimeReasonName;
  String? subDownTimeReasonName;
  String? comment;

  Downtime({
    required this.downTimeID,
    required this.start,
    required this.end,
    required this.activeTime,
    required this.resolvingTime,
    required this.operationID,
    required this.downTimeStatus,
    required this.downTimeTypeID,
    required this.downTimeReasonName,
    required this.subDownTimeReasonName,
    required this.comment,
  });

  factory Downtime.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'DownTimeID': int downTimeID,
        'Start': String start,
        'End': String? end,
        'ActiveTime': int activeTime,
        'ResolvingTime': int resolvingTime,
        'OperationID': int operationID,
        'DownTimeStatus': int downTimeStatus,
        'DownTimeTypeID': int downTimeTypeID,
        'DownTimeReasonName': String downTimeReasonName,
        'SubDownTimeReasonName': String? subDownTimeReasonName,
        'Comment': String? comment,
      } =>
        Downtime(
            downTimeID: downTimeID,
            start: DateTime.parse(start),
            end: end == null ? null : DateTime.parse(end),
            activeTime: activeTime,
            resolvingTime: resolvingTime,
            operationID: operationID,
            downTimeStatus: DowntimeStatus.values[downTimeStatus],
            downTimeTypeID: downTimeTypeID,
            downTimeReasonName: downTimeReasonName.trim(),
            subDownTimeReasonName: subDownTimeReasonName?.trim(),
            comment: comment?.trim()),
      _ => throw const FormatException('Failed to load Downtime.'),
    };
  }

  Duration duration() {
    var now = DateTime.now();
    return (end ?? now).difference(start);
  }
}

enum DowntimeStatus {
  isNew,
  inProgress,
  escalate,
  closed,
  none;

  String get name {
    switch (this) {
      case isNew:
        return 'New';
      case inProgress:
        return 'InProgress';
      case escalate:
        return 'Escalate';
      case closed:
        return 'Closed';
      case none:
      default:
        return 'None';
    }
  }
}
