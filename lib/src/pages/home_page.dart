import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routePath = '/';
  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: const [
          DrawerWidget(),
          Expanded(child: Center(child: Text(routeName))),
        ],
      ),
    );
  }
}
