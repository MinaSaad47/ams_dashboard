import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../controllers/controllers.dart';
import '../widgets/widgets.dart';

class InstructorsPage extends ConsumerStatefulWidget {
  const InstructorsPage({super.key});

  static const String routePath = '/instructors';
  static const String routeName = 'Instructors';

  @override
  ConsumerState<InstructorsPage> createState() => _InstructorsPageState();
}

class _InstructorsPageState extends ConsumerState<InstructorsPage> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(instructorsControleerProvider.notifier).retreive();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(instructorsControleerProvider);

    ref.listen(instructorsControleerProvider, (previous, next) {
      var submitted = false;
      next.whenOrNull(
        updated: (instructors, message) {
          submitted = true;
        },
        created: (instructors, message) {
          submitted = true;
        },
        initial: (instructors) {
          ref.read(instructorsControleerProvider.notifier).retreive();
        },
      );

      if (submitted) {
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(InstructorsPage.routeName),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                elevation: 100,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(20),
                  child: AttendeeCreateWidget(
                    onSubmit: ({
                      required String name,
                      required String email,
                      required String password,
                      required int number,
                      File? image,
                    }) {
                      ref.watch(instructorsControleerProvider.notifier).create(
                            name: name,
                            number: number,
                            email: email,
                            password: password,
                          );
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            onPressed:
                ref.read(instructorsControleerProvider.notifier).retreive,
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          ...?state.whenOrNull(
            failed: (attendees, error) => [
              ListTile(
                leading: const Icon(Icons.error),
                title: Text(error.toString()),
              ),
            ],
            loading: (attendees, message) => [
              ListTile(
                leading: const Icon(Icons.repeat),
                subtitle: Center(child: Text(message)),
                title: const LinearProgressIndicator(),
              ),
            ],
          ),
          Expanded(
            child: state.instructors.isEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.warning_amber_rounded),
                        Text('no data'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) => Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.2,
                        children: [
                          SlidableAction(
                            autoClose: true,
                            label: 'delete',
                            onPressed: (context) {
                              ref
                                  .read(instructorsControleerProvider.notifier)
                                  .delete(
                                    state.instructors[index].id,
                                  );
                            },
                            icon: Icons.delete,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          SlidableAction(
                            autoClose: true,
                            label: 'update',
                            onPressed: (context) {
                              showModalBottomSheet(
                                elevation: 100,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.all(20),
                                  child: InstructorUpdateWidget(
                                    instructor: state.instructors[index],
                                    onSubmit: ({email, image, name, password}) {
                                      ref
                                          .read(instructorsControleerProvider
                                              .notifier)
                                          .update(
                                            state.instructors[index].id,
                                            email: email,
                                            password: password,
                                            image: image,
                                            name: name,
                                          );
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: Icons.update,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.amber,
                          )
                        ],
                      ),
                      child: InstructorCardWidget(
                        state.instructors[index],
                      ),
                    ),
                    itemCount: state.instructors.length,
                  ),
          ),
        ],
      ),
    );
  }
}
