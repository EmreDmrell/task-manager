import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/core/widgets/snackbars.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
import 'package:frontend/features/home/repository/task_local_repository.dart';
import 'package:frontend/generated/l10n.dart';
import 'package:frontend/models/task_model.dart';
import 'package:path/path.dart';

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

  Future<void> getTasks({required String token, required String uid}) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(token: token, uid: uid);
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> deleteTask({
    required String token,
    required String taskId,
    required String uid,
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
          final tasks =
              await taskRemoteRepository.getTasks(token: token, uid: uid);
          emit(GetTasksSuccess(tasks));
          return;
        }
      }

      // If offline or remote delete failed, do soft delete
      await taskLocalRepository.softDeleteTask(taskId);
      // Get updated tasks (will not include soft-deleted tasks)
      final tasks = await taskLocalRepository.getTasks(uid: uid);
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      print('deleteTasks taskCubit: $e');
      emit(TasksError(e.toString()));
    }
  }

  Future<void> syncTasks({
    required BuildContext context,
    required String token,
    required String uid,
  }) async {
    try {
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
        AppSnackbars.showSuccessSnackbar(context,
            message: S.current.tasksSynced);
        print('Tasks synced');

        // Fetch updated tasks from remote and update state
        final tasks =
            await taskRemoteRepository.getTasks(token: token, uid: uid);
        emit(GetTasksSuccess(tasks));
      }
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> syncDeletedTasks({
    required BuildContext context,
    required String token,
    required String uid,
  }) async {
    try {
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
        AppSnackbars.showSuccessSnackbar(context,
            message: S.current.syncDeleted);
        print('Deleted Tasks synced');
        // after deletion from remote database gets tasks to refresh the taskList
        final tasks =
            await taskRemoteRepository.getTasks(token: token, uid: uid);
        emit(GetTasksSuccess(tasks));
      }
    } catch (e) {
      print('syncDeletedTasks taskCubit: $e');
      emit(TasksError(e.toString()));
    }
  }
}
