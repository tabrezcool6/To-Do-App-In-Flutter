part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

final class TodoCreateEvent extends TodoEvent {
  final String posterId;
  final String title;
  final String desc;
  // final File imageUrl;
  // final List<String> topics;

  TodoCreateEvent({
    required this.posterId,
    required this.title,
    required this.desc,
    // required this.imageUrl,
    // required this.topics,
  });
}

final class TodoReadEvent extends TodoEvent {
  final String posterId;

  TodoReadEvent({required this.posterId});
}

// Event to update the existing todo, since all paramneters are not mandatory they are nullable
final class TodoUpdateEvent extends TodoEvent {
  final String todoId;
  final ToDoEntity todoEntity;
  String? title;
  String? desc;
  // File? imageUrl;
  // List<String>? topics;

  TodoUpdateEvent({
    required this.todoEntity,
    required this.todoId,
    this.title,
    this.desc,
    // this.imageUrl,
    // this.topics,
  });
}

final class TodoDeleteEvent extends TodoEvent {
  final String todoId;
  TodoDeleteEvent({required this.todoId});
}
