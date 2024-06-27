import 'package:flutter/material.dart';
import 'package:flutter_opd/screens/downtime_details_page.dart';
import 'package:flutter_opd/opd_appbar.dart';
import 'package:flutter_opd/states/downtime_state.dart';
import 'package:flutter_opd/states/equipment_state.dart';
import 'package:flutter_opd/widgets/dt_listtile.dart';
import 'package:pet_data/downtime/downtime.dart';
import 'package:pet_data/downtime/downtime_type.dart';
import 'package:pet_data/operation.dart';
import 'package:pet_data/equipment.dart';
import 'package:provider/provider.dart';

class DowntimesPage extends StatefulWidget {
  const DowntimesPage({super.key});

  @override
  State<DowntimesPage> createState() => _DowntimesPageState();
}

class _DowntimesPageState extends State<DowntimesPage> {
  bool isMicro = true;
  int donwtimesCount = 0;

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    // var appState = context.watch<AppState>();
    var downtimesState = context.watch<DowntimesState>();
    var eqState = context.watch<EquipmentState>();

    callback(newValue) {
      if (donwtimesCount != newValue) {
        setState(() {
          // print('newValue $newValue');
          donwtimesCount = newValue;
        });
      }
    }

    return FutureBuilder(
        future: Future.wait([
          downtimesState.downtimes,
          downtimesState.downtimeTypesAll,
          eqState.operations,
          eqState.equipment
        ]),
        builder: (context, snapshot) {
          void dtOnTap(downtimeID) {
            // print('ontapped $downtimeID');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DowntimeDetailsPage(downtimeID: downtimeID)),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
                appBar: const OPDAppBar(title: 'Error'),
                body: Text('${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Scaffold(
                appBar: OPDAppBar(title: 'Error'),
                body: Text('No downtimes yet.'));
          }

          var downtimes = snapshot.data![0] as List<Downtime>;
          var downtimeTypes = (snapshot.data![1] as List<dynamic>)[0] as Map<int, DowntimeType>;
          var operations = snapshot.data![2] as Map<int, Operation>;
          var equipment =
              '${(snapshot.data![3] as Equipment).equipmentGroupName}/${(snapshot.data![3] as Equipment).equipmentName}';
          var microStopInterval =
              (snapshot.data![3] as Equipment).microstopInterval;

          var dtList = DTListView(
              isMicro: isMicro,
              microStopInterval: microStopInterval,
              downtimes: downtimes,
              downtimeTypes: downtimeTypes,
              operations: operations,
              dtOnTap: dtOnTap,
              initCallback: callback);

          return Scaffold(
            appBar: OPDAppBar(title: equipment),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(children: [
                      if (donwtimesCount > 0)
                        Text(donwtimesCount.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      else
                        const Text('No downtimes yet.'),
                      if (donwtimesCount > 0)
                        const Text(' downtimes in the last 24 hours'),
                      const Spacer(),
                      const Text('Include short:'),
                      Switch(
                        // This bool value toggles the switch.
                        value: isMicro,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          setState(() {
                            isMicro = value;
                          });
                        },
                      )
                    ])),
                Expanded(child: dtList),
              ],
            ),
          );
        });
  }
}

class DTListView extends StatelessWidget {
  const DTListView(
      {super.key,
      required this.isMicro,
      required this.microStopInterval,
      required this.downtimes,
      required this.downtimeTypes,
      required this.operations,
      required this.dtOnTap,
      required this.initCallback});

  final Function initCallback;
  final Function dtOnTap;
  final List<Downtime> downtimes;
  final bool isMicro;
  final int microStopInterval;
  final Map<int, DowntimeType> downtimeTypes;
  final Map<int, Operation> operations;

  @override
  Widget build(BuildContext context) {
    List<Widget> downtimesListTiles = [];

    var count = 0;
    for (var pair in downtimes) {
      if (isMicro || pair.activeTime > microStopInterval) {
        downtimesListTiles.add(DTListTile(
          pair: pair,
          dtType: downtimeTypes[pair.downTimeTypeID]!,
          operation: operations[pair.operationID]!,
          onTap: dtOnTap,
        ));
        count++;
      }
    }
    // right solution
    Future.delayed(Duration.zero, () async {
      initCallback(count);
    });

    // wrong
    // appState.setDTPageListCount(count);

    // not quite right
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   initCallback(count);
    // });

    return ListView(
      children: downtimesListTiles,
    );
  }
}
