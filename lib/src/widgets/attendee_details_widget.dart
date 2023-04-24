import 'dart:io';

import 'package:ams_dashboard/src/common/env.dart';
import 'package:ams_dashboard/src/services/AMSService/dtos/dtos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AttendeeDetailsWidget extends StatelessWidget {
  const AttendeeDetailsWidget({super.key, required this.attendee, this.onEdit});

  final UserDto attendee;

  final void Function({
    String? name,
    String? email,
    String? password,
    File? image,
  })? onEdit;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Card(
      child: Row(
        children: [
          if (attendee.image != null)
            Image.network(
              '${EnvVars.apiUrl}/${attendee.image}',
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'name',
                      ),
                      name: 'name',
                      initialValue: attendee.name,
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'email',
                      ),
                      name: 'email',
                      initialValue: attendee.email,
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'password',
                      ),
                      name: 'password',
                    ),
                    if (onEdit != null) ...[
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          final state = formKey.currentState;
                          if (state != null) {
                            state.save();
                            onEdit?.call(
                              name: state.value['name'],
                              email: state.value['email'],
                              password: state.value['password'],
                            );
                          }
                        },
                        child: const ListTile(
                          title: Center(child: Text('update')),
                          leading: Icon(Icons.done_all),
                          trailing: Icon(Icons.done_all),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
