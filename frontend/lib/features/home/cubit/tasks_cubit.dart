import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
import 'package:frontend/features/home/repository/task_local_repository.dart';
import 'package:frontend/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        uid: uid,
        dueAt: dueAt,
      );
      await taskLocalRepository.insertTask(taskModel);
      emit(AddNewTaskSuccess(taskModel));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getTasks({required String token}) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(token: token);
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> deleteTask({
    required String token,
    required String taskId,
  }) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        final success =
            await taskRemoteRepository.deleteTask(token: token, taskId: taskId);
        if (success) {
          await taskLocalRepository
              .deleteTask(taskId); // Hard delete if online delete successful
          final tasks = await taskLocalRepository.getTasks();
          emit(GetTasksSuccess(tasks));
          return;
        }
      }

      // If offline or remote delete failed, do soft delete
      await taskLocalRepository.softDeleteTask(taskId);
      // Get updated tasks (will not include soft-deleted tasks)
      final tasks = await taskLocalRepository.getTasks();
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      print('deleteTasks taskCubit: $e');
      emit(TasksError(e.toString()));
    }
  }

  Future<void> syncTasks({required String token}) async {
    final unsyncedTasks = await taskLocalRepository.getUnsyncedTasks();

    if (unsyncedTasks.isEmpty) {
      return;
    }

    final isSynced = await taskRemoteRepository.syncTasks(
        token: token, tasks: unsyncedTasks);
    if (isSynced) {
      for (final task in unsyncedTasks) {
        await taskLocalRepository.updateRowValue(task.id, 1);
      }
      print('Tasks synced');
    }
  }

  Future<void> syncDeletedTasks({required String token}) async {
    final unsyncedDeletedTasks =
        await taskLocalRepository.getUnsyncedDeletedTasks();

    if (unsyncedDeletedTasks.isEmpty) {
      return;
    }

    final isSynced = await taskRemoteRepository.syncDeletedTasks(
        token: token, tasks: unsyncedDeletedTasks);
    if (isSynced) {
      for (final task in unsyncedDeletedTasks) {
        await taskLocalRepository.deleteTask(task.id);
      }
      print('Deleted Tasks synced');
    }
  }
}
