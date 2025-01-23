part of 'tasks_cubit.dart';

sealed class TasksState {
  const TasksState();
}

final class TasksInitial extends TasksState {}

final class TasksLoading extends TasksState {}

final class TasksError extends TasksState {
  final String error;
  TasksError(this.error);
}

final class AddNewTaskSuccess extends TasksState {
  final TaskModel task;
  const AddNewTaskSuccess(this.task);
}

final class GetTasksSuccess extends TasksState {
  final List<TaskModel> tasks;
  const GetTasksSuccess(this.tasks);
}
