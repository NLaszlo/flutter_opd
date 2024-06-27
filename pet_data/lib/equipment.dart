
class Equipment {
  final String equipmentName;
  final String equipmentGroupName;
  final int equipmentGroupID;
  bool closingCommentRequired;
  bool escalationCommentRequired;
  int microstopInterval;
  double changeoverAutoEndBatch;

  Equipment({
    required this.equipmentName,
    required this.equipmentGroupName,
    required this.equipmentGroupID,
    required this.closingCommentRequired,
    required this.escalationCommentRequired,
    required this.microstopInterval,
    required this.changeoverAutoEndBatch,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'EquipmentName': String equipmentName,
        'ClosingCommentRequired': bool closingCommentRequired,
        'EscalationCommentRequired': bool escalationCommentRequired,
        'MicrostopInterval': int microstopInterval,
        'EquipmentGroupName': String equipmentGroupName,
        'EquipmentGroupID': int equipmentGroupID,
        'ChangeoverAutoEndBatch': double changeoverAutoEndBatch,
      } =>
        Equipment(
          equipmentName: equipmentName,
          equipmentGroupName: equipmentGroupName,
          equipmentGroupID: equipmentGroupID,
          closingCommentRequired: closingCommentRequired,
          escalationCommentRequired: escalationCommentRequired,  
          microstopInterval: microstopInterval,
          changeoverAutoEndBatch: changeoverAutoEndBatch,
        ),
      _ => throw const FormatException('Failed to load Equipment.'),
    };
  }
}