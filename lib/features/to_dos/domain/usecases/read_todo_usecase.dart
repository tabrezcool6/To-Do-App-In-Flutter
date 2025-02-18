import 'package:fpdart/fpdart.dart';
import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/repositories/todo_repository.dart';

class ReadTodoUsecase implements UseCase<List<ToDoEntity>, ReadTodoParams> {
  final TodoRepository todoRepository;
  ReadTodoUsecase(this.todoRepository);

  @override
  Future<Either<Failure, List<ToDoEntity>>> call(ReadTodoParams params) async {
    return await todoRepository.readTodo(posterId: params.posterId);
  }
}

class  ReadTodoParams {
  final String posterId;

  ReadTodoParams({required this.posterId});
} 
