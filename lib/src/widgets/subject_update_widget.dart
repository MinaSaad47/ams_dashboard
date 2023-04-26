import 'package:ams_dashboard/src/services/AMSService/dtos/dtos.dart';
import 'package:easy_cron/easy_cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SubjectUpdateWidget extends StatelessWidget {
  const SubjectUpdateWidget({
    super.key,
    required this.subject,
    this.onSubmit,
  });

  final SubjectDto subject;

  final void Function({
    String? name,
    String? cronExpr,
  })? onSubmit;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Card(
      child: Row(
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
                      initialValue: subject.name,
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'cron expr',
                      ),
                      name: 'cronExpr',
                      initialValue: subject.cronExpr.toString(),
                      validator: (value) {
                        try {
                          UnixCronParser().parse(value!);
                        } catch (error, __) {
                          return error.toString();
                        }
                        return null;
                      },
                    ),
                    if (onSubmit != null) ...[
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          final state = formKey.currentState;
                          if (state == null || !state.saveAndValidate()) return;
                          onSubmit?.call(
                            name: state.value['name'],
                            cronExpr: state.value['cronExpr'],
                          );
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
