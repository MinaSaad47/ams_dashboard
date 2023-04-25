import 'package:flutter/material.dart';

import '../services/services.dart';
import 'widgets.dart';

class SubjectCardWidget extends StatelessWidget {
  const SubjectCardWidget(this.subject, {super.key});

  final SubjectDto subject;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: CopiableText(subject.name),
              subtitle: CopiableText(subject.id),
            ),
          )
        ],
      ),
    );
  }
}
