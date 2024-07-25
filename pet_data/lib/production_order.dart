
class ProductionOrder {
  final int productionOrderID;
  final String order;
  final String batch;
  final int equipmentID;
  DateTime plannedStartTime;
  DateTime plannedEndTime;
  DateTime? actualStartTime;
  DateTime? actualEndTime;
  int conversionFactor;
  String partCode;
  int unitsProduced;
  int defectsProduced;

  ProductionOrder({
    required this.productionOrderID,
    required this.order,
    required this.batch,
    required this.equipmentID,
    required this.plannedStartTime,
    required this.plannedEndTime,
    required this.actualStartTime,
    required this.actualEndTime,
    required this.conversionFactor,
    required this.partCode,
    required this.unitsProduced,
    required this.defectsProduced
  });

  factory ProductionOrder.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'ProductionOrderID': int productionOrderID,
        'Order': String order,
        'Batch': String batch,
        'EquipmentID': int equipmentID,
        'PlannedStartTime': String plannedStartTime,
        'PlannedEndTime': String plannedEndTime,
        'ActualStartTime': String? actualStartTime,
        'ActualEndTime': String? actualEndTime,
        'ConversionFactor': int conversionFactor,
        'PartCode': String partCode,
        'UnitsProduced': int unitsProduced,
        'DefectsProduced': int defectsProduced
      } =>
        ProductionOrder(
          productionOrderID: productionOrderID,
          order: order,
          batch: batch,
          equipmentID: equipmentID,
          plannedStartTime: DateTime.parse(plannedStartTime),
          plannedEndTime: DateTime.parse(plannedEndTime),
          actualStartTime: actualStartTime != null ? DateTime.parse(actualStartTime) : null,
          actualEndTime: actualEndTime != null ? DateTime.parse(actualEndTime) : null,  
          conversionFactor: conversionFactor,
          partCode: partCode,
          unitsProduced: unitsProduced,
          defectsProduced: defectsProduced
        ),
      _ => throw const FormatException('Failed to load ProductionOrder.'),
    };
  }
}