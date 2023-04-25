import 'package:ams_dashboard/src/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

void main() async {
  runApp(ProviderScope(
    observers: [
      LoggerObserver(),
    ],
    child: const MyApp(),
  ));
}
