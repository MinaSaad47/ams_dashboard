import 'dart:io';

import 'package:ams_dashboard/src/services/AMSService/dtos/dtos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../common/common.dart';

class AttendeeUpdateWidget extends StatefulWidget {
  const AttendeeUpdateWidget({
    super.key,
    required this.attendee,
    this.onSubmit,
  });

  final UserDto attendee;

  final void Function({
    String? name,
    String? email,
    String? password,
    File? image,
  })? onSubmit;

  @override
  State<AttendeeUpdateWidget> createState() => _AttendeeUpdateWidgetState();
}

class _AttendeeUpdateWidgetState extends State<AttendeeUpdateWidget> {
  File? changedImage;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final imageHeight = MediaQuery.of(context).size.height / 4;
    return Card(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                height: imageHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 7,
                  ),
                  color: Colors.transparent,
                ),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: Colors.transparent,
                  ),
                  child: changedImage != null
                      ? Image.file(changedImage!)
                      : widget.attendee.image != null
                          ? Image.network(
                              '${EnvVars.apiUrl}/${widget.attendee.image}')
                          : Icon(
                              Icons.person_outline,
                              size: imageHeight,
                            ),
                ),
              ),
              Positioned(
                bottom: -15,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: IconButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        allowedExtensions: ['png'],
                      );
                      if (result == null) return;
                      setState(() {
                        changedImage = File(result.files[0].path!);
                      });
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
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
                      initialValue: widget.attendee.name,
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'email',
                      ),
                      name: 'email',
                      initialValue: widget.attendee.email,
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'password',
                      ),
                      name: 'password',
                    ),
                    const SizedBox(height: 10),
                    if (widget.onSubmit != null) ...[
                      ElevatedButton(
                        onPressed: () {
                          final state = formKey.currentState;
                          if (state == null || !state.saveAndValidate()) return;
                          widget.onSubmit?.call(
                            name: state.value['name'],
                            email: state.value['email'],
                            password: state.value['password'],
                            image: changedImage,
                          );
                          setState(() {
                            changedImage = null;
                          });
                        },
                        child: const ListTile(
                          title: Center(child: Text('update')),
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
