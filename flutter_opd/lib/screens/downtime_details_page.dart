import 'package:flutter/material.dart';
import 'package:flutter_opd/opd_appbar.dart';
import 'package:flutter_opd/states/downtime_state.dart';
import 'package:flutter_opd/states/equipment_state.dart';
import 'package:intl/intl.dart';
import 'package:pet_common/datetime_helper.dart';
import 'package:pet_data/downtime/downtime.dart';
import 'package:pet_data/downtime/downtime_history.dart';
import 'package:pet_data/downtime/downtime_reason.dart';
import 'package:pet_data/downtime/downtime_type.dart';
import 'package:pet_data/downtime/subdowntime_reason.dart';
import 'package:pet_data/operation.dart';
import 'package:provider/provider.dart';

class DowntimeDetailsPage extends StatelessWidget {
  const DowntimeDetailsPage({super.key, required this.downtimeID});

  final int downtimeID;

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    // var appState = context.watch<AppState>();
    var downtimesState = context.watch<DowntimesState>();
    var eqState = context.watch<EquipmentState>();

    return FutureBuilder(
        future: Future.wait([
          downtimesState.getDowntimeDetails(downtimeID),
          downtimesState.downtimes,
          downtimesState.downtimeTypesAll,
          eqState.operations
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                appBar: const OPDAppBar(title: 'Error'),
                body: Text('${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Scaffold(
                appBar: const OPDAppBar(title: 'Downtime not found.'),
                body: Text('Downtime $downtimeID not found.'));
          }
          List<DowntimeHistory> dtHistories = snapshot.data![0];
          var downtimes = snapshot.data![1] as List<Downtime>;
          var downtimeTypesAll = snapshot.data![2] as List<dynamic>;
          var operations = snapshot.data![3] as Map<int, Operation>;

          var downtimeTypes = downtimeTypesAll[0] as Map<int, DowntimeType>;
          var downtimeReasons = downtimeTypesAll[1] as Map<int, DowntimeReason>;
          var downtimeSubReasons = downtimeTypesAll[2] as Map<int, SubDowntimeReason>;

          var currentDT =
              downtimes.firstWhere((x) => x.downTimeID == downtimeID);
          var textReason =
              '${downtimeTypes[currentDT.downTimeTypeID]!.downTimeTypeName} / ${currentDT.downTimeReasonName}';
          if (currentDT.subDownTimeReasonName != null) {
            textReason += ' / ${currentDT.subDownTimeReasonName}';
          }

          var lastTime = currentDT.start;
          List<Widget> dthistoriesGrids = <Widget>[];
          for (var history in dtHistories) {
            var timeDiff = history.time.difference(lastTime);
            dthistoriesGrids.add(buildStatusGrid(
              DateFormat('yyyy.MM.dd kk:mm:ss').format(history.time),
              '[${history.oldStatus.name}] -> [${history.newStatus.name}]',
              history.currentOperationID != null
                  ? operations[history.currentOperationID]!.name
                  : ' - ',
              history.comment ?? '',
              history.currentSubReasonID != null
                  ? '${downtimeReasons[history.currentReasonID]!.downTimeName} / ${downtimeSubReasons[history.currentSubReasonID]!.name}'
                  : downtimeReasons[history.currentReasonID]?.downTimeName ?? ' - ',
              DateTimeHelper.formatDuration(timeDiff < Duration.zero ? Duration.zero : timeDiff),
              history.escalationDescription,
            ));
            lastTime = history.time;
          }

          return Scaffold(
            appBar: const OPDAppBar(title: "Downtime details"),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reason: $textReason',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Operation: ${operations[currentDT.operationID]!.name}'),
                      Text(
                          'Status: [${currentDT.downTimeStatus.name}]',
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Start: ${DateFormat('yyyy.MM.dd kk:mm:ss').format(currentDT.start)}'),
                      Text(
                          'Duration: ${DateTimeHelper.formatDuration(Duration(seconds: currentDT.activeTime))}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  // SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        for (var grid in dthistoriesGrids)
                          grid,
                        // buildStatusGrid(
                        //   '2024.06.20 12:43',
                        //   '[New] -> [Escalated]',
                        //   'Balanta',
                        //   null,
                        //   'Undefined',
                        //   '46:15:48',
                        //   'Ambalare - LVL2',
                        // ),
                        // buildStatusGrid(
                        //   '2024.06.20 13:16',
                        //   '[Escalated] -> [Escalated]',
                        //   'Balanta',
                        //   '',
                        //   'Reprocesare',
                        //   '00:32:09',
                        //   '',
                        // ),
                        // buildStatusGrid(
                        //   '2024.06.20 13:16',
                        //   '[Escalated] -> [Closed]',
                        //   'Balanta',
                        //   'Comment 2',
                        //   'Reprocesare',
                        //   '00:00:00',
                        //   '',
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

Widget buildStatusGrid(
  String date,
  String status,
  String operation,
  String? comment,
  String downtimeType,
  String duration,
  String? escalation,
) {
  return Column(
    children: [
      Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FixedColumnWidth(120),
        },
        children: <TableRow>[
          TableRow(
            children: [
              Text(date),
              Text('Operation: $operation'),
              Text('Comment: $comment'),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('Duration: $duration',
                      style: const TextStyle(color: Colors.orange))),
            ],
          ),
          TableRow(children: <Text>[
            Text(status, style: const TextStyle(color: Colors.orange)),
            Text('Downtime reason: $downtimeType'),
            if (escalation != null && escalation.isNotEmpty)
              Text('Escalation: $escalation')
            else
              const Text(""),
            const Text("")
          ]),
        ],
      ),
      const Divider()
    ],
  );
}

Widget buildStatusRow(
  String date,
  String status,
  String operation,
  String downtimeType,
  String duration,
  String escalation,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date),
            Text('Operation: $operation'),
            Text('Comment: $operation'),
            Text('Duration: $duration', style: const TextStyle(color: Colors.orange)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(status, style: const TextStyle(color: Colors.orange)),
            Text('Downtime type: $downtimeType'),
            if (escalation.isNotEmpty)
              Text('Escalation: $escalation')
            else
              const Text(""),
            const Text("")
          ],
        ),
        const Divider(),
      ],
    ),
  );
}
