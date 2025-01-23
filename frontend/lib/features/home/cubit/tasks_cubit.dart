import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/repository/taskRemoteRepository.dart';
import 'package:frontend/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
  final taskremoterepository = Taskremoterepository();

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
      final taskModel = await taskremoterepository.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        uid: uid,
        dueAt: dueAt,
      );
      emit(AddNewTaskSuccess(taskModel));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getTasks({required String token}) async {
    try {
      emit(TasksLoading());
      final tasks = await taskremoterepository.getTasks(token: token);
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
}
