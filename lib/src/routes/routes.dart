import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../pages/pages.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: HomePage.routePath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: HomePage.routePath,
        name: HomePage.routeName,
        pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
      ),
      GoRoute(
        path: AttendancesPage.routePath,
        name: AttendancesPage.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: AttendancesPage()),
      ),
      GoRoute(
        path: AttendeesPage.routePath,
        name: AttendeesPage.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: AttendeesPage()),
      ),
      GoRoute(
        path: InstructorsPage.routePath,
        name: InstructorsPage.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: InstructorsPage()),
      ),
      GoRoute(
        path: SubjectsPage.routePath,
        name: SubjectsPage.routeName,
        pageBuilder: (context, state) =>
            const MaterialPage(child: SubjectsPage()),
      ),
    ],
  );
});
