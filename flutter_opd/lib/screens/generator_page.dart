import 'package:flutter/material.dart';
import 'package:flutter_opd/opd_appbar.dart';
import 'package:flutter_opd/widgets/bigcard.dart';
import 'package:flutter_opd/widgets/historylistview.dart';
import 'package:provider/provider.dart';
import '../states/appstate.dart';

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      appBar: const OPDAppBar(title: "Generator"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              flex: 3,
              child: HistoryListView(),
            ),
            const SizedBox(height: 10),
            BigCard(pair: pair),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: const Text('Like'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      )
    );
  }
}
