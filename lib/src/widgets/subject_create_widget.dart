import 'package:easy_cron/easy_cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SubjectCreateWidget extends StatelessWidget {
  const SubjectCreateWidget({
    super.key,
    this.onSubmit,
  });

  final void Function({
    required String name,
    required String cronExpr,
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
                        labelText: 'cron expr',
                      ),
                      name: 'cronExpr',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          try {
                            UnixCronParser().parse(value!);
                          } catch (error, __) {
                            return error.toString();
                          }
                          return null;
                        }
                      ]),
                    ),
                    if (onSubmit != null) ...[
                      const Spacer(),
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
