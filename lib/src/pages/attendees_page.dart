import 'dart:io';
import 'dart:math';

import 'package:ams_dashboard/src/controllers/controllers.dart';
import 'package:ams_dashboard/src/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        final pageController = PageController(
          viewportFraction: showDrawer ? 1 / 2 : 1,
        );
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
                          : _AttendeesBoardWidget(
                              key: Key(Random.secure().nextDouble().toString()),
                              hPageController: pageController,
                              attendees: attendees,
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

class _AttendeesBoardWidget extends ConsumerStatefulWidget {
  const _AttendeesBoardWidget({
    Key? key,
    required this.hPageController,
    required this.attendees,
  }) : super(key: key);

  final PageController hPageController;
  final List<UserDto> attendees;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AttendeesBoardWidgetState();
}

class _AttendeesBoardWidgetState extends ConsumerState<_AttendeesBoardWidget> {
  late var selectedAttendee = widget.attendees[0];

  @override
  Widget build(BuildContext context) {
    final vPageController = PageController(initialPage: 0);

    return PageView(
      controller: widget.hPageController,
      physics: const NeverScrollableScrollPhysics(),
      padEnds: false,
      children: [
        _AttendeesListWidget(
          attendees: widget.attendees,
          onSelected: (attendee) {
            setState(() {
              widget.hPageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
              );
              selectedAttendee = attendee;
            });
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).cardColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: PageView(
            controller: vPageController,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Row(
                      children: [
                        if (widget.hPageController.viewportFraction == 1)
                          IconButton(
                            onPressed: () {
                              widget.hPageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.linear,
                              );
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        Expanded(
                          child: ListTile(
                            onTap: () {
                              vPageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.linear,
                              );
                            },
                            leading: const Icon(Icons.subject_outlined),
                            title: const Text('Add Subjects'),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(attendeesControleerProvider.notifier)
                                .delete(selectedAttendee.id);
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AttendeeUpdateWidget(
                      attendee: selectedAttendee,
                      onSubmit: ({email, image, name, password}) {
                        ref.read(attendeesControleerProvider.notifier).update(
                              selectedAttendee.id,
                              name: name,
                              email: email,
                              password: password,
                              image: image,
                            );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Card(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            vPageController.animateToPage(
                              0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.linear,
                            );
                          },
                          icon: const Icon(Icons.arrow_upward),
                        ),
                        const Text('Drag & Drop'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _AttendeeSubjectsWidget(
                      attendeeId: selectedAttendee.id,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttendeeSubjectsWidget extends ConsumerStatefulWidget {
  const _AttendeeSubjectsWidget({
    required this.attendeeId,
  });

  final String attendeeId;

  @override
  ConsumerState<_AttendeeSubjectsWidget> createState() =>
      _AttendeeSubjectsWidgetState();
}

class _AttendeeSubjectsWidgetState
    extends ConsumerState<_AttendeeSubjectsWidget> {
  @override
  void didUpdateWidget(covariant _AttendeeSubjectsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future(() {
      ref
          .read(
            attendeeSubjectsControllerProvider(
              attendeeId: widget.attendeeId,
            ).notifier,
          )
          .retrieve();
    });
  }

  @override
  void initState() {
    super.initState();
    Future(() {
      ref
          .read(
            attendeeSubjectsControllerProvider(
              attendeeId: widget.attendeeId,
            ).notifier,
          )
          .retrieve();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      attendeeSubjectsControllerProvider(attendeeId: widget.attendeeId),
    );

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[400],
                width: double.infinity,
                height: 2,
              ),
            ),
            const Text('Attendee Subjects'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[400],
                width: double.infinity,
                height: 2,
              ),
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: DragTarget<SubjectDto>(
            onWillAccept: (data) => !state.self.contains(data),
            onAccept: (subject) {
              ref
                  .read(
                    attendeeSubjectsControllerProvider(
                      attendeeId: widget.attendeeId,
                    ).notifier,
                  )
                  .add(subject);
            },
            builder: (context, candidateData, rejectedData) => ListView.builder(
              itemBuilder: (context, index) => Draggable(
                data: state.self[index],
                feedback: Card(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.subject_outlined),
                      SizedBox(width: 5),
                      Text('Remove from attendee'),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_downward),
                    ],
                  ),
                ),
                child: SubjectCardWidget(state.self[index]),
              ),
              itemCount: state.self.length,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[400],
                width: double.infinity,
                height: 2,
              ),
            ),
            const Text('All Subjects'),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[400],
                width: double.infinity,
                height: 2,
              ),
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: DragTarget<SubjectDto>(
            onWillAccept: (data) => !state.other.contains(data),
            onAccept: (subject) {
              ref
                  .read(
                    attendeeSubjectsControllerProvider(
                      attendeeId: widget.attendeeId,
                    ).notifier,
                  )
                  .remove(subject);
            },
            builder: (context, candidateData, rejectedData) => ListView.builder(
              itemBuilder: (context, index) => Draggable<SubjectDto>(
                data: state.other[index],
                feedback: Card(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.subject_outlined),
                      SizedBox(width: 5),
                      Text('Add to attendee'),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_upward),
                    ],
                  ),
                ),
                child: SubjectCardWidget(state.other[index]),
              ),
              itemCount: state.other.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _AttendeesListWidget extends StatelessWidget {
  const _AttendeesListWidget({
    required this.attendees,
    required this.onSelected,
  });

  final List<UserDto> attendees;

  final Function(UserDto attendee) onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => InkWell(
        onTap: () => onSelected(attendees[index]),
        child: AttendeeCardWidget(attendees[index]),
      ),
      itemCount: attendees.length,
    );
  }
}
