import 'package:ams_dashboard/src/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../routes/routes.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(goRouterProvider).location;

    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.inversePrimary;

    final instructorsColor =
        location == InstructorsPage.routePath ? primaryColor : secondaryColor;

    final attendeesColor =
        location == AttendeesPage.routePath ? primaryColor : secondaryColor;

    final subjectsColor =
        location == SubjectsPage.routePath ? primaryColor : secondaryColor;

    final attendancesColor =
        location == AttendancesPage.routePath ? primaryColor : secondaryColor;

    return Drawer(
      child: Column(
        children: [
          ListTile(
            title: const Text(HomePage.routeName),
            onTap: () {
              context.replaceNamed(HomePage.routeName);
            },
          ),
          ListTile(
            iconColor: attendeesColor,
            textColor: attendeesColor,
            leading: const Icon(Icons.person),
            title: const Text(AttendeesPage.routeName),
            onTap: () {
              context.replaceNamed(AttendeesPage.routeName);
            },
          ),
          ListTile(
            iconColor: instructorsColor,
            textColor: instructorsColor,
            leading: const Icon(Icons.person),
            title: const Text(InstructorsPage.routeName),
            onTap: () {
              context.replaceNamed(InstructorsPage.routeName);
            },
          ),
          ListTile(
            iconColor: subjectsColor,
            textColor: subjectsColor,
            leading: const Icon(Icons.subject),
            title: const Text(SubjectsPage.routeName),
            onTap: () {
              context.replaceNamed(SubjectsPage.routeName);
            },
          ),
          ListTile(
            iconColor: attendancesColor,
            textColor: attendancesColor,
            leading: const Icon(Icons.task),
            title: const Text(AttendancesPage.routeName),
            onTap: () {
              context.replaceNamed(AttendancesPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
