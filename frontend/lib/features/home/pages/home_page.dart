import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/home/cubit/tasks_cubit.dart';
import 'package:frontend/features/home/widgets/date_selector.dart';
import 'package:frontend/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

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
  StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    // Get references safely at initialization
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    if (authCubit.state is AuthLoggedIn) {
      final user = (authCubit.state as AuthLoggedIn).user;
      userToken = user.token;
      tasksCubit = context.read<TasksCubit>();

      // Initial tasks fetch
      tasksCubit.getTasks(token: userToken);

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
        await tasksCubit.syncDeletedTasks(token: userToken);
        if (mounted) {
          await tasksCubit.syncTasks(token: userToken);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sync tasks: ${e.toString()}')),
          );
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
        appBar: AppBar(
          title: const Text("My Tasks"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addNewTask');
              },
              icon: const Icon(Icons.add),
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
                  DateSelector(
                    selectedDate: selectedDate,
                    onTap: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Dismissible(
                          key: Key(task.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            context.read<TasksCubit>().deleteTask(
                                  token: userToken,
                                  taskId: task.id,
                                );
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
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ));
  }
}
