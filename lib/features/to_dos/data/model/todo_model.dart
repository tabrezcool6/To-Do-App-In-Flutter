import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';

class ToDoModel extends ToDoEntity {
  ToDoModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.desc,
    required super.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'descp': desc,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ToDoModel.fromJson(Map<String, dynamic> map) {
    return ToDoModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      title: map['title'] as String,
      desc: map['descp'] as String,
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  ToDoModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? desc,
    DateTime? updatedAt,
  }) {
    return ToDoModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
