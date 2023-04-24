import 'package:ams_dashboard/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AttendancesPage extends StatelessWidget {
  const AttendancesPage({super.key});

  static const String routePath = '/attendances';
  static const String routeName = 'attendances';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const DrawerWidget(),
      body: const Center(child: Text(routeName)),
    );
  }
}
