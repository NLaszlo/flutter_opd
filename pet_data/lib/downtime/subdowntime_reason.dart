class SubDowntimeReason {
  final int subDownTimeReasonID;
  final String name;
  final String? description;

  const SubDowntimeReason({
    required this.subDownTimeReasonID,
    required this.name,
    required this.description,
  });

  factory SubDowntimeReason.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'SubDownTimeReasonID': int subDownTimeReasonID,
        'Name': String name,
        'Description': String? description,
        // 'CommentRequired' = x.CommentRequired,
        // 'DisplayedInOPDList' = x.DisplayedInOPDList
      } =>
        SubDowntimeReason(
          subDownTimeReasonID: subDownTimeReasonID,
          name: name,
          description: description,  
        ),
      _ => throw const FormatException('Failed to load SubDowntimeReason.'),
    };
  }
}