import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pet_data/equipment.dart';
import 'package:pet_data/operation.dart';

final equipmentID = GlobalConfiguration().getValue("equipmentID");
final apiBaseURL = GlobalConfiguration().getValue("apiBaseURL");

class EquipmentState extends ChangeNotifier {
  late Future<Map<int, Operation>> operations = fetchOperations();
  late Future<Equipment> equipment = fetchEquipment();

  EquipmentState() {
    // notifyListeners();
  }
}

Future<Map<int, Operation>> fetchOperations() async {
  final uri = '$apiBaseURL/Equipments/GetEquipmentOperations/$equipmentID';

  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    print('fetchOperations');
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var ops = (json.decode(response.body) as List);
    var operations = ops.map((i) => Operation.fromJson(i)).toList();

    Map<int, Operation> operationsMap = {};
    for (var op in operations) {
      operationsMap[op.operationID] = op;
    }

    return operationsMap;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load Operations');
  }
}

Future<Equipment> fetchEquipment() async {
  final uri = '$apiBaseURL/Equipments/GetEquipmentDetails/$equipmentID';

  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    print('fetchEquipment');

    var equipment =
        Equipment.fromJson(json.decode(response.body) as Map<String, dynamic>);
    return equipment;
  } else {
    throw Exception('Failed to load Equipment');
  }
}
