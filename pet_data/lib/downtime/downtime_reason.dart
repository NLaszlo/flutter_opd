class DowntimeReason {
  final int downTimeReasonID;
  final int downTimeTypeID;
  final String downTimeName;
  final String? description;
  final bool isDefaultDownTimeReason;
  final bool displayedInOpdList;
  final bool isValidationTesting;
  final bool isDefaultForStartEndShift;
  final bool commentRequired;

  const DowntimeReason({
    required this.downTimeReasonID,
    required this.downTimeTypeID,
    required this.downTimeName,
    required this.description,
    required this.isDefaultDownTimeReason,
    required this.displayedInOpdList,
    required this.isValidationTesting,
    required this.isDefaultForStartEndShift,
    required this.commentRequired,
  });

  factory DowntimeReason.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'DownTimeName': String downTimeName,
        'Description': String? description,
        'DownTimeTypeID': int downTimeTypeID,
        'DownTimeReasonID': int downTimeReasonID,
        'IsDefaultDownTimeReason': bool isDefaultDownTimeReason,
        // 'ShowInStatistics': downTimeReasonWithTypeDto.ShowInStatistics,
        'DisplayedInOPDList': bool displayedInOpdList,
        'IsValidationTesting': bool isValidationTesting,
        'IsDefaultDTRForStartEndShift': bool isDefaultForStartEndShift,
        'CommentRequired': bool commentRequired,
      } =>
        DowntimeReason(
          downTimeReasonID: downTimeReasonID,
          downTimeTypeID: downTimeTypeID,
          downTimeName: downTimeName,
          description: description,  
          isDefaultDownTimeReason: isDefaultDownTimeReason,
          displayedInOpdList: displayedInOpdList,
          isValidationTesting: isValidationTesting,
          isDefaultForStartEndShift: isDefaultForStartEndShift,
          commentRequired: commentRequired
        ),
      _ => throw const FormatException('Failed to load DowntimeReason.'),
    };
  }
}