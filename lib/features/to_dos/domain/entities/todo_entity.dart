class ToDoEntity {
  final String id;
  final String posterId;
  final String title;
  final String desc;
  final DateTime updatedAt;

  ToDoEntity({
    required this.id,
    required this.posterId,
    required this.title,
    required this.desc,
    required this.updatedAt,
  });
}
