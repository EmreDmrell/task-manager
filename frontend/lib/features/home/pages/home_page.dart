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

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TasksCubit>().getTasks(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((event) async {
      if (event.contains(ConnectivityResult.wifi) ||
          event.contains(ConnectivityResult.mobile)) {
        // ignore: use_build_context_synchronously
        await context.read<TasksCubit>().syncTasks(token: user.user.token);

        // ignore: use_build_context_synchronously
        await context
            .read<TasksCubit>()
            .syncDeletedTasks(token: user.user.token);
      }
    });
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
                            AuthLoggedIn user =
                                context.read<AuthCubit>().state as AuthLoggedIn;
                            context.read<TasksCubit>().deleteTask(
                                  token: user.user.token,
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
