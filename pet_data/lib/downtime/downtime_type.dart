
class DowntimeType {
  final int downTimeTypeID;
  final int color;
  final String? colorString;
  final String beaconColor;
  final String downTimeTypeName;
  final String? description;
  final String? imageURL;

  const DowntimeType({
    required this.downTimeTypeID,
    required this.color,
    required this.colorString,
    required this.beaconColor,
    required this.downTimeTypeName,
    required this.description,
    required this.imageURL,
  });

  factory DowntimeType.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'DownTimeTypeID': int downTimeTypeID,
        'Color': int color,
        'ColorString': String? colorString,
        'BeaconColor': String beaconColor,
        'DownTimeTypeName': String downTimeTypeName,
        'Description': String? description,
        'ImageURL': String? imageURL,
      } =>
        DowntimeType(
          downTimeTypeID: downTimeTypeID,
          color: color,
          colorString: colorString,
          beaconColor: beaconColor,  
          downTimeTypeName: downTimeTypeName,
          description: description,
          imageURL: imageURL,
        ),
      _ => throw const FormatException('Failed to load DowntimeType.'),
    };
  }
}