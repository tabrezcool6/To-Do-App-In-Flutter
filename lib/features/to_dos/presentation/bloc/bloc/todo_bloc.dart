
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/usecases/create_todo_usecase.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/usecases/delete_todo_usecase.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/usecases/read_todo_usecase.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/usecases/update_todo_usecase.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final CreateTodoUsecase _createTodoUsecase;
  final ReadTodoUsecase _readTodoUsecase;
  final UpdateTodoUsecase _updateTodoUsecase;
  final DeleteTodoUsecase _deleteTodoUsecase;
  TodoBloc({
    required CreateTodoUsecase createTodoUsecase,
    required ReadTodoUsecase readTodoUsecase,
    required UpdateTodoUsecase updateTodoUsecase,
    required DeleteTodoUsecase deleteTodoUsecase,
  })  : _createTodoUsecase = createTodoUsecase,
        _readTodoUsecase = readTodoUsecase,
        _updateTodoUsecase = updateTodoUsecase,
        _deleteTodoUsecase = deleteTodoUsecase,
        super(
          TodoInitial(),
        ) {
    on<TodoEvent>((event, emit) => emit(TodoLoading()));

    on<TodoCreateEvent>(_onTodoCreaete);

    on<TodoReadEvent>(_onTodoRead);

    on<TodoUpdateEvent>(_onTodoUpdate);

    on<TodoDeleteEvent>(_onTodoDelete);
  }

  void _onTodoCreaete(
    TodoCreateEvent event,
    Emitter<TodoState> emit,
  ) async {
    final response = await _createTodoUsecase(
      CreateTodoParams(
        posterId: event.posterId,
        title: event.title,
        desc: event.desc,
        // imageUrl: event.imageUrl,
        // topics: event.topics,
      ),
    );

    response.fold(
      (l) => emit(TodoFailure(l.message)),
      (r) => emit(TodoCreateSuccess()),
    );
  }

  void _onTodoRead(
    TodoReadEvent event,
    Emitter<TodoState> emit,
  ) async {
    final response = await _readTodoUsecase(
      ReadTodoParams(posterId:event.posterId),
    );

    response.fold(
      (l) => emit(TodoFailure(l.message)),
      (todos) => emit(TodoReadSuccess(todos)),
    );
  }

  /// Update Todo
  void _onTodoUpdate(
    TodoUpdateEvent event,
    Emitter<TodoState> emit,
  ) async {
    final response = await _updateTodoUsecase(
      UpdateTodoParams(
        todoEntity: event.todoEntity,
        todoId: event.todoId,
        title: event.title,
        desc: event.desc,
        // topics: event.topics,
        // imageUrl: event.imageUrl,
      ),
    );

    response.fold(
      (l) => emit(TodoFailure(l.message)),
      (r) => emit(TodoUpdateSuccess()),
    );
  }

  ///

  void _onTodoDelete(
    TodoDeleteEvent event,
    Emitter<TodoState> emit,
  ) async {
    final result = await _deleteTodoUsecase(
      DeleteTodoParams(todoId: event.todoId),
    );
    result.fold(
      (l) => emit(TodoFailure(l.message)),
      (todos) => emit(TodoDeleteSuccess()),
    );
  }
}
