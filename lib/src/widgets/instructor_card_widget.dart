import 'package:flutter/material.dart';

import '../common/env.dart';
import '../services/services.dart';
import 'widgets.dart';

class InstructorCardWidget extends StatelessWidget {
  const InstructorCardWidget(this.instructor, {super.key});

  final UserDto instructor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: instructor.image != null
                ? CircleAvatar(
                    radius: 30,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.network(
                          '${EnvVars.apiUrl}/${instructor.image!}'),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        size: 40,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 20),
          Expanded(
              child: ListTile(
            title: CopiableText(instructor.name),
            subtitle: CopiableText(instructor.id),
          ))
        ],
      ),
    );
  }
}
