import 'package:to_do_app_flutter/core/theme/app_pallete.dart';
import 'package:to_do_app_flutter/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/pages/view_todo_page.dart';

class TodoCard extends StatelessWidget {
  final ToDoEntity todo;
  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, ViewTodoPage.route(todo)),
      child: Container(
        margin: const EdgeInsets.all(16).copyWith(
          bottom: 4,
          left: 24.0,
          right: 24.0,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppPallete.gradient2,
            // width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    todo.desc,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
