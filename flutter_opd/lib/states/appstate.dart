import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

final apiBaseURL = GlobalConfiguration().getValue("apiBaseURL");

class AppState extends ChangeNotifier {
  Map<String, dynamic> srvSettings = <String, dynamic>{};
  var current = WordPair.random();
  var history = <WordPair>[];
  // var pageDowntimesListCount = 0;

  AppState(){
    fetchSRVSettings().then((value) => srvSettings = value);
  }

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  // void setDTPageListCount(int newVal) {
  //   if (pageDowntimesListCount != newVal) {
  //     pageDowntimesListCount = newVal;
  //     notifyListeners();
  //   }
  // }

}

Future<Map<String, dynamic>> fetchSRVSettings() async {
  final uri = '$apiBaseURL/OPDSettings/ServerSettings';

  try{

  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load Server settings');
  }
  }
  catch(e){
    print(e);
    rethrow;
  }

}
