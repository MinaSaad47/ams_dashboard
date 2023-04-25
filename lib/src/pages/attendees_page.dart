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
  String query = '';

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(attendeesControleerProvider.notifier).retreive();
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(attendeesControleerProvider);
    final attendees = state.attendees
        .where((e) => e.name.toLowerCase().contains(query))
        .toList();

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

    return LayoutBuilder(
      builder: (context, constraints) {
        const drawer = DrawerWidget();
        final showDrawer = constraints.minWidth > 600;
        final mobileDrawer = showDrawer ? null : drawer;
        final desktopDrawer = showDrawer ? [drawer] : null;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 80,
            title: Row(
              children: [
                const Expanded(
                  child: Text(AttendeesPage.routeName),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        label: const Text('search'),
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          query = value.trim().toLowerCase();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
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
                          ref
                              .watch(attendeesControleerProvider.notifier)
                              .create(
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
                    ref.read(attendeesControleerProvider.notifier).retreive,
                icon: const Icon(Icons.download_outlined),
              ),
            ],
          ),
          drawer: mobileDrawer,
          body: Row(
            children: [
              ...?desktopDrawer,
              Expanded(
                child: Column(
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
                      child: attendees.isEmpty
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
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      autoClose: true,
                                      label: 'delete',
                                      onPressed: (context) {
                                        ref
                                            .read(attendeesControleerProvider
                                                .notifier)
                                            .delete(
                                              attendees[index].id,
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
                                              attendee: attendees[index],
                                              onSubmit: (
                                                  {email,
                                                  image,
                                                  name,
                                                  password}) {
                                                ref
                                                    .read(
                                                        attendeesControleerProvider
                                                            .notifier)
                                                    .update(
                                                      attendees[index].id,
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
                                  attendees[index],
                                ),
                              ),
                              itemCount: attendees.length,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
