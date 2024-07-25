import 'dart:convert';
import 'package:pet_data/production_order.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

final equipmentID = GlobalConfiguration().getValue("equipmentID");
final apiBaseURL = GlobalConfiguration().getValue("apiBaseURL");

class ProductionState extends ChangeNotifier {
  late Future<List<ProductionOrder>> activeOrder = fetchProductionOrder();

}

Future<List<ProductionOrder>> fetchProductionOrder() async {
  final uri = '$apiBaseURL/GetActiveProductionOrders/0/0/$equipmentID';

  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    print('fetchProductionOrder');
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var dts = (json.decode(response.body) as List);
    var pos = dts.map((i) => ProductionOrder.fromJson(i)).toList();

    return pos;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load active production order');
  }
}