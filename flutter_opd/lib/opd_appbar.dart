import 'package:flutter/material.dart';

class OPDAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OPDAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return AppBar(
      title: Text(title),
      backgroundColor: Colors.red,
      // leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       appState.goBack();
      //     }),
      automaticallyImplyLeading: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
