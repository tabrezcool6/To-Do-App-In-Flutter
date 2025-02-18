import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/repositories/todo_repository.dart';

class DeleteTodoUsecase implements UseCase<String, DeleteTodoParams> {
  final TodoRepository todoRepository;
  DeleteTodoUsecase(this.todoRepository);

  @override
  Future<Either<Failure, String>> call(DeleteTodoParams params) async {
    return await todoRepository.deleteTodo(todoId: params.todoId);
  }
}

class DeleteTodoParams {
  final String todoId;

  DeleteTodoParams({required this.todoId});
}
