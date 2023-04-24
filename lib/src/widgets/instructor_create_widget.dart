import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class InstructorCreateWidget extends StatelessWidget {
  const InstructorCreateWidget({
    super.key,
    this.onSubmit,
  });

  final void Function({
    required String name,
    required String email,
    required String password,
    required int number,
    File? image,
  })? onSubmit;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'email',
                      ),
                      name: 'email',
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'number',
                      ),
                      name: 'number',
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'password',
                      ),
                      name: 'password',
                      validator: FormBuilderValidators.required(),
                    ),
                    if (onSubmit != null) ...[
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          final state = formKey.currentState;
                          if (state != null) {
                            state.save();
                            onSubmit?.call(
                              name: state.value['name'],
                              email: state.value['email'],
                              password: state.value['password'],
                              number: int.parse(state.value['number']),
                            );
                          }
                        },
                        child: const ListTile(
                          title: Center(child: Text('create')),
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
