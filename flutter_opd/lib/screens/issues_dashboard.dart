import 'package:flutter/material.dart';
import 'package:flutter_opd/opd_appbar.dart';
import 'package:flutter_opd/screens/comment_page.dart';
import 'package:flutter_opd/screens/downtime_details_page.dart';
import 'package:flutter_opd/screens/downtime_edit.dart';
import 'package:flutter_opd/states/appstate.dart';
import 'package:flutter_opd/states/downtime_state.dart';
import 'package:flutter_opd/states/equipment_state.dart';
import 'package:flutter_opd/widgets/dt_listtile.dart';
import 'package:intl/intl.dart';
import 'package:pet_common/datetime_helper.dart';
import 'package:pet_data/downtime/downtime.dart';
import 'package:pet_data/downtime/downtime_reason.dart';
import 'package:pet_data/downtime/downtime_type.dart';
import 'package:pet_data/equipment.dart';
import 'package:pet_data/operation.dart';
import 'package:provider/provider.dart';

class IssuesDashboard extends StatelessWidget {
  const IssuesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var downtimeState = context.watch<DowntimesState>();
    var eqState = context.watch<EquipmentState>();

    return FutureBuilder(
        future: Future.wait([
          eqState.equipment,
          eqState.operations,
          downtimeState.downtimes,
          downtimeState.downtimeTypesAll,
          downtimeState.getUncommentedMicroDowntimes()
        ]),
        builder: (context, snapshot) {
          print('IssuesDashboard');
          if (snapshot.hasError) {
            return Scaffold(
                appBar: const OPDAppBar(title: 'Error'),
                body: Text('${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Scaffold(
                appBar: OPDAppBar(title: 'No equipment.'), body: Text(''));
          }

          void issueOnTap(downtimeID) {
            // print('ontapped $downtimeID');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DowntimeEdit(downtimeID: downtimeID)),
            );
          }

          void microDTOnTap(downtimeID) {
            // print('ontapped $downtimeID');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DowntimeDetailsPage(downtimeID: downtimeID)),
            );
          }

          Equipment equipment = snapshot.data![0] as Equipment;
          Map<int, Operation> operationMap =
              snapshot.data![1] as Map<int, Operation>;
          List<Downtime> downtimes = snapshot.data![2] as List<Downtime>;
          Map<int, DowntimeType> downtimeTypes =
              (snapshot.data![3] as List<dynamic>)[0] as Map<int, DowntimeType>;
          Map<int, DowntimeReason> downtimeReasons = (snapshot.data![3]
              as List<dynamic>)[1] as Map<int, DowntimeReason>;
          List<Downtime> microDowntimes = snapshot.data![4] as List<Downtime>;
          downtimes = downtimes
              .where((x) =>
                  x.downTimeReasonID !=
                      appState.srvSettings['MicroReasonID'] as int &&
                  (downtimeReasons[x.downTimeReasonID]!
                          .isDefaultDownTimeReason ||
                      x.end == null))
              .toList();

          // var MicroDTButtonState = 

          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      equipment.equipmentName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('yyyy.MM.dd kk:mm').format(DateTime.now()),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Pending issues')]),
                              ),
                              if (downtimes.isEmpty)
                                const Expanded(
                                  child: Center(
                                    child: Text('Nothing to display'),
                                  ),
                                )
                              else
                                for (var dt in downtimes)
                                  DTListTile(
                                    pair: dt,
                                    operation: operationMap[dt.operationID]!,
                                    dtType: downtimeTypes[dt.downTimeTypeID]!,
                                    onTap: issueOnTap,
                                  )
                              // DTCard(
                              //   operation:
                              //       operationMap[dt.operationID]!.name,
                              //   dtType: downtimeTypes[dt.downTimeTypeID]!
                              //       .downTimeTypeName,
                              //   dtReason: dt.downTimeReasonName,
                              //   dtSubReason: dt.subDownTimeReasonName,
                              //   status: dt.downTimeStatus,
                              //   duration: dt.duration(),
                              //   takeActionTime: dt.resolvingTime,
                              //   start: dt.start,
                              // ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          'Micro issues (${microDowntimes.length})'),
                                    ]),
                              ),
                              if (microDowntimes.isEmpty)
                                const Expanded(
                                  child: Center(
                                    child: Text('Nothing to display'),
                                  ),
                                )
                              else
                                Expanded(
                                  child: ListView(
                                    children: [
                                      for (var dt in microDowntimes)
                                        DTListTile(
                                          pair: dt,
                                          operation:
                                              operationMap[dt.operationID]!,
                                          dtType:
                                              downtimeTypes[dt.downTimeTypeID]!,
                                          onTap: microDTOnTap,
                                        )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: const Size.fromWidth(100),
                          padding: const EdgeInsets.all(10)),
                      onPressed: () {},
                      icon: const Icon(Icons.warning),
                      label: const Text('Downtime'),
                    ),
                    // ElevatedButton.icon(
                    //   style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.teal,
                    //       fixedSize: Size.fromWidth(100),
                    //       padding: EdgeInsets.all(10)),
                    //   onPressed: () {},
                    //   icon: Icon(Icons.book),
                    //   label: Text('Logbook'),
                    // ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: const Size.fromWidth(100),
                          padding: const EdgeInsets.all(10)),
                      onPressed: () {
                        // downtimeState.reloadDowntimes();
                        int totalSec = microDowntimes.fold(0, (sum, x) => sum + x.activeTime);
                        String title = 'Total micro downtimes: ${microDowntimes.length} ($totalSec sec)';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentPage(commentTitle: title,)),
                        );
                      },
                      icon: const Icon(Icons.comment),
                      label: const Text('Comment'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class DTCard extends StatelessWidget {
  const DTCard(
      {super.key,
      required this.operation,
      required this.dtType,
      required this.dtReason,
      required this.dtSubReason,
      required this.status,
      required this.duration,
      required this.takeActionTime,
      required this.start});

  final String operation;
  final String dtType;
  final String dtReason;
  final String? dtSubReason;
  final DowntimeStatus status;
  final Duration duration;
  final int takeActionTime;
  final DateTime start;

  @override
  Widget build(BuildContext context) {
    String textDT = '$dtType: $dtReason';
    if (dtSubReason != null && dtSubReason!.isNotEmpty) {
      textDT += ' / $dtSubReason';
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.blue),
        title: Text(operation),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(textDT),
            Text(
                '[${status.name}] (${DateFormat('yyyy.MM.dd kk:mm').format(start)})'),
            Text(
                'Time: ${DateTimeHelper.formatDuration(duration)}/{${DateTimeHelper.formatDuration(Duration(seconds: takeActionTime))}}'),
          ],
        ),
      ),
    );
  }
}
