import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    final state = ref.watch(subjectsControleerProvider);
    final subjects = state.subjects
        .where((e) => e.name.toLowerCase().contains(query))
        .toList();

    ref.listen(subjectsControleerProvider, (previous, next) {
      var submitted = false;
      next.whenOrNull(
        updated: (subjects, message) {
          submitted = true;
        },
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
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
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
                                            .read(subjectsControleerProvider
                                                .notifier)
                                            .delete(
                                              subjects[index].id,
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
                                            child: SubjectUpdateWidget(
                                              subject: subjects[index],
                                              onSubmit: ({name, cronExpr}) {
                                                ref
                                                    .read(
                                                        subjectsControleerProvider
                                                            .notifier)
                                                    .update(
                                                      subjects[index].id,
                                                      name: name,
                                                      cronExpr: cronExpr,
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
                                child: SubjectCardWidget(
                                  subjects[index],
                                ),
                              ),
                              itemCount: subjects.length,
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
