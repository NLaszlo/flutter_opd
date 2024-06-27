import 'package:flutter/material.dart';
import 'package:flutter_opd/screens/downtimes_page.dart';
import 'package:flutter_opd/screens/issues_dashboard.dart';
import 'favorites_page.dart';
import 'generator_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    // var appstate = context.watch<MyAppState>();
    // var selectedIndex = appstate.currentPage;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
      case 1:
        page = const IssuesDashboard();
      case 2:
        page = const DowntimesPage();
      case 3:
        page = const FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard),
                        label: 'Dashbaord',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.front_hand),
                        label: 'Downtimes',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    // backgroundColor: Colors.grey[200],  //Color(0xeeff851b), //Color.fromARGB(255, 255, 255, 200), const Color(0xFF333333), 
                    extended: constraints.maxWidth >= 1000,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        selectedIcon: Icon(Icons.home_outlined),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.dashboard),
                        selectedIcon: Icon(Icons.dashboard_outlined),
                        label: Text('Dashboard'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.front_hand),
                        selectedIcon: Icon(Icons.front_hand_outlined),
                        label: Text('Downtimes'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        selectedIcon: Icon(Icons.favorite_outline),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1, color: null),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
