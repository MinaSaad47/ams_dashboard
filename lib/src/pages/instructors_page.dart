import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class InstructorsPage extends StatelessWidget {
  const InstructorsPage({super.key});

  static const String routePath = '/instructors';
  static const String routeName = 'instructors';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const DrawerWidget(),
      body: const Center(child: Text(routeName)),
    );
  }
}
