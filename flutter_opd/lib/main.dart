// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_opd/states/downtime_state.dart';
import 'package:flutter_opd/states/equipment_state.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'screens/homepage.dart';
import 'states/appstate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(
    MultiProvider(
      providers: [ 
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => DowntimesState()),
        ChangeNotifierProvider(create: (_) => EquipmentState()),
      ],
      child: App()
    )
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter OPD App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0000FF)),  //FFEA8023
      ),
      home: MyHomePage(),
    );
  }
}

