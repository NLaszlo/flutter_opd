import 'package:flutter/material.dart';
import 'package:flutter_opd/opd_appbar.dart';

class DowntimeEdit extends StatelessWidget {
  final int? downtimeID;

  const DowntimeEdit({super.key, this.downtimeID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OPDAppBar(
        title: 'Downtime Reason select/change',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderSection(),
            SizedBox(height: 16),
            ChangeOperationSection(),
            NavigationArrows(),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2.0), // Bordered box
        borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AMBACAM1 / Blisterizare',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Downtime type: Undefined'),
            Text('Downtime reason: Undefined'),
            Text('Status: Closed', style: TextStyle(color: Colors.red)),
            Text('Time: 00:49:38/00:01:00'),
          ],
        ),
      ),
    );
  }
}

class ChangeOperationSection extends StatelessWidget {
  final List<Map<String, dynamic>> operations = [
    {'title': 'Alim folie Prim', 'icon': Icons.build, 'color': Colors.grey},
    {'title': 'Termo-formare', 'icon': Icons.warning, 'color': Colors.orange},
    {'title': 'Termo-formare', 'icon': Icons.build, 'color': Colors.grey},
    {
      'title': 'Alimentare Produs',
      'icon': Icons.local_shipping,
      'color': Colors.purple
    },
    {
      'title': 'Alimentare Produs',
      'icon': Icons.warning,
      'color': Colors.orange
    },
    {
      'title': 'Camera de detectie',
      'icon': Icons.warning,
      'color': Colors.orange
    },
    {'title': 'Tragere folie', 'icon': Icons.build, 'color': Colors.grey},
    {'title': 'Alim Folie Sec', 'icon': Icons.build, 'color': Colors.grey},
  ];

  ChangeOperationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: operations.length,
        itemBuilder: (context, index) {
          return OperationCard(
            title: operations[index]['title'],
            icon: operations[index]['icon'],
            color: operations[index]['color'],
          );
        },
      ),
    );
  }
}

class OperationCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color? color;

  const OperationCard({
    super.key,
    this.title,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: color?.withOpacity(0.1) ?? Colors.red,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title ?? '-'),
      ),
    );
  }
}

class InkWellExample extends StatelessWidget {
  final double sideLength = 50;

  const InkWellExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // height: sideLength,
      // width: sideLength,
      duration: const Duration(seconds: 2),
      curve: Curves.easeIn,
      child: Material(
        color: Colors.yellow,
        child: InkWell(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColoredBox(
                  color: Colors.orange, child: SizedBox(width: sideLength))
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}

class NavigationArrows extends StatelessWidget {
  const NavigationArrows({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back navigation
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // Handle forward navigation
          },
        ),
      ],
    );
  }
}
