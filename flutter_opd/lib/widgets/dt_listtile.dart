import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_common/color_helper.dart';
import 'package:pet_common/datetime_helper.dart';
import 'package:pet_data/downtime/downtime.dart';
import 'package:pet_data/downtime/downtime_type.dart';
import 'package:pet_data/operation.dart';

class DTListTile extends StatelessWidget {
  const DTListTile({
    super.key,
    required this.pair,
    required this.dtType,
    required this.operation,
    required this.onTap,
  });

  final Downtime pair;
  final DowntimeType dtType;
  final Operation operation;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    var text1 = operation.name.toString();
    var text2 = '${dtType.downTimeTypeName}/${pair.downTimeReasonName}';
    if (pair.subDownTimeReasonName != null) {
      text2 += '/${pair.subDownTimeReasonName}';
    }
    var textStatus =
        '[${pair.downTimeStatus == DowntimeStatus.isNew ? 'New' : pair.downTimeStatus == DowntimeStatus.inProgress ? 'InProgress' : pair.downTimeStatus == DowntimeStatus.escalate ? 'Escalate' : pair.downTimeStatus == DowntimeStatus.closed ? 'Closed' : 'None'}]';
    var textStart = DateFormat('yyyy/MM/dd kk:mm:ss').format(pair.start);
    var textDuration =
        DateTimeHelper.formatDuration(Duration(seconds: pair.activeTime));
    final duration = Duration(seconds: pair.resolvingTime);
    if (duration > Duration.zero) {
      textDuration += '/${DateTimeHelper.formatDuration(duration)}';
    }

    Color bckgdColor = ColorHelper.hexToColor(dtType.color);
    TextStyle txtcolor = TextStyle(
      color: ColorHelper.getTextColorBasedOnBackground(bckgdColor),
    );

    Widget img;
    if (dtType.imageURL != null && dtType.imageURL != '') {
      // const uri = 'http://localhost:5125/';
      img = Image.network('http://localhost:5125/${dtType.imageURL}');
    } else {
      img = const Icon(Icons.timer, semanticLabel: 'Icon');
    }

    return Material(
        type: MaterialType.transparency,
        child: ListTile(
          leading: SizedBox(
            width: 36,
            height: 64,
            // child: DecoratedBox(
            //   decoration: BoxDecoration(color: Colors.red),
            child: img,
            // ),
          ),
          contentPadding: null, // EdgeInsets.symmetric(horizontal: 16.0),
          minVerticalPadding: 0,
          tileColor: bckgdColor,
          isThreeLine: false,
          selected: false,
          title: Text(
            text1,
            semanticsLabel: text1,
            style: txtcolor,
          ),
          subtitle: Text(
            text2,
            semanticsLabel: text2,
            maxLines: 1,
            style: txtcolor,
          ),
          trailing: SizedBox(
            width: 128,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  textStart,
                  style: txtcolor,
                ),
                Text(
                  textDuration,
                  style: txtcolor,
                ),
                Text(
                  textStatus,
                  style: txtcolor,
                ),
              ],
            ),
          ),
          onTap: () => onTap(pair.downTimeID),
        ));
  }
}
