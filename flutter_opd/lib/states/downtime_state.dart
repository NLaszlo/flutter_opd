
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:pet_data/downtime/downtime.dart';
import 'package:pet_data/downtime/downtime_history.dart';
import 'package:http/http.dart' as http;
import 'package:pet_data/downtime/downtime_reason.dart';
import 'package:pet_data/downtime/downtime_type.dart';
import 'package:pet_data/downtime/subdowntime_reason.dart';

final equipmentID = GlobalConfiguration().getValue("equipmentID");
final apiBaseURL = GlobalConfiguration().getValue("apiBaseURL");

class DowntimesState extends ChangeNotifier {
  // late Future<Set<Object>> initAll;
  late Future<List<Downtime>> downtimes;
  // late Future<Map<int, DowntimeType>> downtimeTypes;
  late Future<List<dynamic>> downtimeTypesAll;
  //, downtimeReasonMap, subDowntimeReasonMap

  DowntimesState() {
    downtimes = fetchDowntimes();
    // downtimeTypes = fetchDowntimeTypes();
    downtimeTypesAll = fetchDowntimeTypesAll();

    // initAll = Future.wait([fetchDowntimes(), fetchDowntimeTypes()]).then((result) => {
    //   downtimes = result[0] as List<Downtime>,
    //   downtimeTypes = result[1] as Map<int, DowntimeType>,
    //   for (var dt in downtimes) {
    //     dt.donwtimeTypeName = downtimeTypes[dt.downTimeTypeID]!.downTimeTypeName
    //   },
    //   Future.value(result)
    // });
    notifyListeners();
  }

  Future<List<Downtime>> getUncommentedMicroDowntimes() {
    return fetchMicroDowntimes();
  }

  Future getDowntimeDetails(int dtID) {
    return fetchDowntimeHistories(dtID);
  }
}

Future<List<Downtime>> fetchDowntimes() async {
  final uri = '$apiBaseURL/DownTimes/AllDownTimesForLast24Hours/true/0/$equipmentID';

  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    print('fetchDowntimes');
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var dts = (json.decode(response.body) as List);
    var downtimes = dts.map((i) => Downtime.fromJson(i)).toList();

    return downtimes;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load Downtimes');
  }
}

Future<List<Downtime>> fetchMicroDowntimes() async {
  final uri = '$apiBaseURL/DownTimes/GetUncommentedMicroStopsInTheLast24Hours/$equipmentID';

  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    print('fetchMicroDowntimes');
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var dts = (json.decode(response.body) as List);
    var downtimes = dts.map((i) => Downtime.fromJson(i)).toList();

    return downtimes;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load Micro Downtimes');
  }
}

/*
Future<Map<int, DowntimeType>> fetchDowntimeTypes() async {
  final uri = '$apiBaseURL/DownTimes/GetDownTimeTypes/$equipmentID';

  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    print('fetchDowntimeTypes');
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var dts = (json.decode(response.body) as List);
    var downtimeTypes = dts.map((i) => DowntimeType.fromJson(i)).toList();

    Map<int, DowntimeType> downtimeTypesMap = {};
    for (var dt in downtimeTypes) {
      downtimeTypesMap[dt.downTimeTypeID] = dt;
    }

    return downtimeTypesMap;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load Downtimes');
  }
}
*/
Future<List<dynamic>> fetchDowntimeTypesAll() async {
  final uri = '$apiBaseURL/DownTimes/GetDownTimeTypesWithReasons/$equipmentID';

  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    print('fetchDowntimeTypesAll');
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var dts = (json.decode(response.body) as List);
    // var downtimeTypes = dts.map((i) => DowntimeType.fromJson(i)).toList();
    Map<int, DowntimeType> downtimeTypesMap = {};
    Map<int, DowntimeReason> downtimeReasonMap = {};
    Map<int, SubDowntimeReason> subDowntimeReasonMap = {};
    for (var dtmap in dts){
      DowntimeType dtype = DowntimeType.fromJson(dtmap);
      downtimeTypesMap[dtype.downTimeTypeID] = dtype;
      for (var drmap in dtmap['DownTimeReasons']){
        DowntimeReason dreason = DowntimeReason.fromJson(drmap);
        downtimeReasonMap[dreason.downTimeReasonID] = dreason;

        for (var dsubrmap in drmap['SubDownTimeReasons']){
          SubDowntimeReason dsubreason = SubDowntimeReason.fromJson(dsubrmap);
          subDowntimeReasonMap[dsubreason.subDownTimeReasonID] = dsubreason;
        } 
      }
    }
    
    return <dynamic>[downtimeTypesMap, downtimeReasonMap, subDowntimeReasonMap];
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load Downtimes');
  }
}

Future<List<DowntimeHistory>> fetchDowntimeHistories(int downtimeID) async {
  final uri = '$apiBaseURL/DownTimes/GetDownTimeDetails/$downtimeID/$equipmentID';

  final response = await http.get(Uri.parse(uri));

  try {
    if (response.statusCode == 200) {
      print('fetchDowntimeHistories');
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var dths = (json.decode(response.body)
        as Map<String, dynamic>)['DownTimeHistories'];
        List<DowntimeHistory> downtimeHistories = <DowntimeHistory>[];
      for (var dth in dths) {
        downtimeHistories.add(DowntimeHistory.fromJson(dth));
      }

      return downtimeHistories;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Downtime histories');
    }
  } catch (e) {
    print(e);
    rethrow;
  }
}
