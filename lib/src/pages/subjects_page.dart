import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  static const String routePath = '/subjects';
  static const String routeName = 'subjects';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const DrawerWidget(),
      body: const Center(child: Text(routeName)),
    );
  }
}
