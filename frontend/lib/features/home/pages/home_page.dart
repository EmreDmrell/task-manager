import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/core/widgets/snackbars.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/login_page.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:frontend/features/home/pages/add_new_task_page.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:frontend/features/settings/language_settings_page.dart';
import 'package:frontend/features/settings/theme_settings_page.dart';
import 'package:frontend/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  late TasksCubit tasksCubit;
  late String userToken;
  late String userUid;
  StreamSubscription? _connectivitySubscription;
  final GlobalKey _addTaskKey = GlobalKey();
  final GlobalKey _dateFilterKey = GlobalKey();
  final GlobalKey _listTasksKey = GlobalKey();
  final Map<String, GlobalKey> _deleteTaskKeys = {};
  bool _showShowcase = false;
  bool _showDeletion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeState();
      _checkAndShowShowcase();
    });
  }

  Future<void> _checkAndShowShowcase() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    _showShowcase = !(prefs.getBool('hasSeenShowcase') ?? false);
    _showDeletion = !(prefs.getBool('hasSeenDeletion') ?? false);

    if (_showShowcase || _showDeletion) {
      // Add a small delay to ensure the widget tree is built
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          final state = context.read<TasksCubit>().state;
          final hasTasksToShow =
              state is GetTasksSuccess && state.tasks.isNotEmpty;

          final showcaseKeys = [
            _addTaskKey,
            _dateFilterKey,
            _listTasksKey,
          ];

          if (hasTasksToShow) {
            if (_deleteTaskKeys.isNotEmpty) {
              ShowCaseWidget.of(context)
                  .startShowCase([_deleteTaskKeys.values.first]);
            }
            prefs.setBool('hasSeenDeletion', true);
          } else {
            ShowCaseWidget.of(context).startShowCase(showcaseKeys);
            prefs.setBool('hasSeenShowcase', true);
          }
        }
      });
    }
  }

  void _initializeState() {
    // Get references safely at initialization
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    if (authCubit.state is AuthLoggedIn) {
      final user = (authCubit.state as AuthLoggedIn).user;
      userToken = user.token;
      userUid = user.id;
      tasksCubit = context.read<TasksCubit>();

      // Initial tasks fetch
      tasksCubit.getTasks(token: userToken, uid: userUid);

      // Setup connectivity listener
      _setupConnectivityListener();
    }
  }

  Future<void> _setupConnectivityListener() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> event) {
      _handleConnectivityChange(event);
    });
  }

  bool _isSyncing = false;

  Future<void> _handleConnectivityChange(List<ConnectivityResult> event) async {
    if (!mounted || _isSyncing) return;

    final hasInternet = event.contains(ConnectivityResult.wifi) ||
        event.contains(ConnectivityResult.mobile);

    if (hasInternet) {
      try {
        _isSyncing = true;
        await tasksCubit.syncDeletedTasks(
          context: context,
          token: userToken,
          uid: userUid,
        );
        if (mounted) {
          await tasksCubit.syncTasks(
            context: context,
            token: userToken,
            uid: userUid,
          );
        }
      } catch (e) {
        if (mounted) {
          AppSnackbars.showErrorSnackbar(context,
              message: '${S.current.syncTaskError}: ${e.toString()}');
        }
      } finally {
        _isSyncing = false;
      }
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                ),
                child: Center(
                  child: Text(
                    S.current.appTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(S.current.themeSettings),
                onTap: () {
                  Navigator.pushNamed(context, ThemeSettingsPage.routeName);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(S.current.languageSettings),
                onTap: () {
                  Navigator.pushNamed(context, LanguageSettingsPage.routeName);
                },
              ),
              const Spacer(),
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthInitial) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginPage.routeName,
                      (route) => false,
                    );
                  }
                },
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(S.current.logOut),
                  onTap: () {
                    context.read<AuthCubit>().logout();
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(S.current.tasks),
          actions: [
            Showcase(
              key: _addTaskKey,
              description: S.current.addTaskShowcase,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddNewTaskPage.routeName);
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            if (state is TasksLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is TasksError) {
              return Center(
                child: Text(state.error),
              );
            }
            if (state is GetTasksSuccess) {
              final tasks = state.tasks
                  .where(
                    (elem) =>
                        DateFormat('d').format(elem.dueAt) ==
                            DateFormat('d').format(selectedDate) &&
                        selectedDate.month == elem.dueAt.month &&
                        selectedDate.year == elem.dueAt.year,
                  )
                  .toList();
              return Column(
                children: [
                  Showcase(
                    key: _dateFilterKey,
                    description: S.current.selectDateShowcase,
                    child: DateSelector(
                      selectedDate: selectedDate,
                      onTap: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        _deleteTaskKeys.putIfAbsent(task.id, () => GlobalKey());
                        return Showcase(
                          key: _deleteTaskKeys[task.id]!,
                          description: S.current.deleteTaskShowcase,
                          child: Dismissible(
                            key: Key(task.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              context.read<TasksCubit>().deleteTask(
                                  token: userToken,
                                  taskId: task.id,
                                  uid: userUid);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: TaskCard(
                                    color: task.color,
                                    headerText: task.title,
                                    descriptionText: task.description,
                                  ),
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: strengthenColor(
                                      task.color,
                                      0.69,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    DateFormat.jm().format(task.dueAt),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            return Showcase(
              key: _listTasksKey,
              description: S.current.listTaskShowcase,
              child: const SizedBox(),
            );
          },
        ));
  }
}
