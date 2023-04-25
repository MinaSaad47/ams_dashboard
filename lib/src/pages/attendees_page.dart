import 'dart:io';

import 'package:ams_dashboard/src/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../widgets/widgets.dart';

class AttendeesPage extends ConsumerStatefulWidget {
  const AttendeesPage({super.key});

  static const String routePath = '/attendees';
  static const String routeName = 'Attendees';

  @override
  ConsumerState<AttendeesPage> createState() => _AttendeesPageState();
}

class _AttendeesPageState extends ConsumerState<AttendeesPage> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(attendeesControleerProvider.notifier).retreive();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendeesControleerProvider);

    ref.listen(attendeesControleerProvider, (previous, next) {
      var submitted = false;
      next.whenOrNull(
        updated: (attendees, message) {
          submitted = true;
        },
        created: (attendees, message) {
          submitted = true;
        },
      );

      if (submitted) {
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AttendeesPage.routeName),
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
                      ref.watch(attendeesControleerProvider.notifier).create(
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
            onPressed: ref.read(attendeesControleerProvider.notifier).retreive,
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
            child: state.attendees.isEmpty
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
                                  .read(attendeesControleerProvider.notifier)
                                  .delete(
                                    state.attendees[index].id,
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
                                  child: AttendeeUpdateWidget(
                                    attendee: state.attendees[index],
                                    onSubmit: ({email, image, name, password}) {
                                      ref
                                          .read(attendeesControleerProvider
                                              .notifier)
                                          .update(
                                            state.attendees[index].id,
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
                      child: AttendeeCardWidget(
                        state.attendees[index],
                      ),
                    ),
                    itemCount: state.attendees.length,
                  ),
          ),
        ],
      ),
    );
  }
}
