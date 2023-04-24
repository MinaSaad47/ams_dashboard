import 'package:ams_dashboard/src/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../widgets/widgets.dart';

class AttendeesPage extends ConsumerWidget {
  const AttendeesPage({super.key});

  static const String routePath = '/attendees';
  static const String routeName = 'Attendees';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendeesControleerProvider);

    ref.listen(attendeesControleerProvider, (previous, next) {
      next.whenOrNull(
        updated: (attendees, message) {
          context.pop();
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(routeName),
        actions: [
          IconButton(
            onPressed: () {},
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
            child: ListView.builder(
              itemBuilder: (context, index) => Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.2,
                  children: [
                    SlidableAction(
                      autoClose: true,
                      label: 'delete',
                      onPressed: (context) {
                        ref.read(attendeesControleerProvider.notifier).delete(
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
                                topLeft: Radius.circular(100),
                                topRight: Radius.circular(100),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.all(20),
                            child: AttendeeDetailsWidget(
                              attendee: state.attendees[index],
                              onEdit: ({email, image, name, password}) {
                                ref
                                    .read(attendeesControleerProvider.notifier)
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
