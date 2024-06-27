class DowntimeReason {
  final int downTimeReasonID;
  final int downTimeTypeID;
  final String downTimeName;
  final String? description;

  const DowntimeReason({
    required this.downTimeReasonID,
    required this.downTimeTypeID,
    required this.downTimeName,
    required this.description,
  });

  factory DowntimeReason.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'DownTimeName': String downTimeName,
        'Description': String? description,
        'DownTimeTypeID': int downTimeTypeID,
        'DownTimeReasonID': int downTimeReasonID,
        // 'IsDefaultDownTimeReason' = downTimeReasonWithTypeDto.IsDefaultDownTimeReason,
        // 'ShowInStatistics' = downTimeReasonWithTypeDto.ShowInStatistics,
        // 'DisplayedInOPDList' = downTimeReasonWithTypeDto.DisplayedInOpdList,
        // 'IsValidationTesting' = downTimeReasonWithTypeDto.IsValidationTesting,
        // 'IsDefaultDTRForStartEndShift' = downTimeReasonWithTypeDto.IsDefaultForStartEndShift,
        // 'CommentRequired' = downTimeReasonWithTypeDto.CommentRequired,
      } =>
        DowntimeReason(
          downTimeReasonID: downTimeReasonID,
          downTimeTypeID: downTimeTypeID,
          downTimeName: downTimeName,
          description: description,  
        ),
      _ => throw const FormatException('Failed to load DowntimeReason.'),
    };
  }
}