import 'dart:math';

import 'package:ams_dashboard/src/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/widgets.dart';
import '../controllers/controllers.dart';

class SubjectsPage extends ConsumerStatefulWidget {
  const SubjectsPage({super.key});

  static const String routePath = '/subjects';
  static const String routeName = 'Subjects';

  @override
  ConsumerState<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends ConsumerState<SubjectsPage> {
  String query = '';

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(subjectsControleerProvider.notifier).retreive();
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(subjectsControleerProvider);
    final subjects = state.subjects
        .where((e) => e.name.toLowerCase().contains(query))
        .toList();

    ref.listen(subjectsControleerProvider, (previous, next) {
      var submitted = false;
      next.whenOrNull(
        created: (subjects, message) {
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
                  child: Text(SubjectsPage.routeName),
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
                      child: SubjectCreateWidget(
                        onSubmit: ({
                          required String name,
                          required String cronExpr,
                        }) {
                          ref.watch(subjectsControleerProvider.notifier).create(
                                name: name,
                                cronExpr: cronExpr,
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
                    ref.read(subjectsControleerProvider.notifier).retreive,
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
                      failed: (subjects, error) => [
                        ListTile(
                          leading: const Icon(Icons.error),
                          title: Text(error.toString()),
                        ),
                      ],
                      loading: (subjects, message) => [
                        ListTile(
                          leading: const Icon(Icons.repeat),
                          subtitle: Center(child: Text(message)),
                          title: const LinearProgressIndicator(),
                        ),
                      ],
                    ),
                    Expanded(
                      child: subjects.isEmpty
                          ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.warning_amber_rounded),
                                  Text('no data'),
                                ],
                              ),
                            )
                          : _SubjectsBoardWidget(
                              key: Key(Random.secure().nextDouble().toString()),
                              pageController: pageController,
                              subjects: subjects,
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

class _SubjectsBoardWidget extends ConsumerStatefulWidget {
  const _SubjectsBoardWidget({
    Key? key,
    required this.pageController,
    required this.subjects,
  }) : super(key: key);

  final PageController pageController;
  final List<SubjectDto> subjects;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubjectsBoardWidgetState();
}

class _SubjectsBoardWidgetState extends ConsumerState<_SubjectsBoardWidget> {
  late var selectedSubject = widget.subjects[0];

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      physics: const NeverScrollableScrollPhysics(),
      padEnds: false,
      children: [
        _SubjectsListWidget(
          subjects: widget.subjects,
          onSelected: (subject) {
            setState(() {
              widget.pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
              );
              selectedSubject = subject;
            });
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          color: Theme.of(context).cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Row(
                  children: [
                    if (widget.pageController.viewportFraction == 1)
                      IconButton(
                        onPressed: () {
                          widget.pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear,
                          );
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(subjectsControleerProvider.notifier)
                            .delete(selectedSubject.id);
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
                child: SubjectUpdateWidget(
                  subject: selectedSubject,
                  onSubmit: ({name, cronExpr}) {
                    ref.read(subjectsControleerProvider.notifier).update(
                          selectedSubject.id,
                          name: name,
                          cronExpr: cronExpr,
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubjectsListWidget extends StatelessWidget {
  const _SubjectsListWidget({
    required this.subjects,
    required this.onSelected,
  });

  final List<SubjectDto> subjects;

  final Function(SubjectDto subject) onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => InkWell(
        onTap: () => onSelected(subjects[index]),
        child: SubjectCardWidget(subjects[index]),
      ),
      itemCount: subjects.length,
    );
  }
}
