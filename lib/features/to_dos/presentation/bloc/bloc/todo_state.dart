part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoFailure extends TodoState {
  final String error;
  TodoFailure(this.error);
}

final class TodoCreateSuccess extends TodoState {}

final class TodoReadSuccess extends TodoState {
  final List<ToDoEntity> todos;
  TodoReadSuccess(this.todos);
}

final class TodoUpdateSuccess extends TodoState {}

final class TodoDeleteSuccess extends TodoState {}
