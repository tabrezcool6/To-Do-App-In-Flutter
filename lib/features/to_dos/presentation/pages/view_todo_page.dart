import 'package:to_do_app_flutter/core/constants.dart';
import 'package:to_do_app_flutter/core/theme/app_pallete.dart';
import 'package:to_do_app_flutter/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/bloc/bloc/todo_bloc.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/pages/create_todo_page.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/pages/to_dos_page.dart';

class ViewTodoPage extends StatelessWidget {
  ///
  static route(
    // String userId,
    ToDoEntity todoEntity,
  ) =>
      MaterialPageRoute(
        builder: (context) => ViewTodoPage(
          // userId: userId,
          todoEntity: todoEntity,
        ),
      );

  // final String userId;
  final ToDoEntity todoEntity;
  const ViewTodoPage({
    // required this.userId,
    required this.todoEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("//// ${todoEntity.id}");
    return Scaffold(
      appBar: AppBar(
        actions: [
          /// Edit Todo Icon Button
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CreateTodoPage.route(todo: todoEntity),
                );
              },
              icon: const Icon(Icons.edit)),

          /// Delete Todo Icon Button
          IconButton(
            onPressed: () => Utils.singleBtnPopAlertDialogBox(
              context: context,
              title: 'Confirm delete?',
              desc: '',
              onTap1: () => context
                  .read<TodoBloc>()
                  .add(TodoDeleteEvent(todoId: todoEntity.id)),
            ),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoDeleteSuccess) {
            Utils.showSnackBar(context, 'Todo deleted successfully');

            Navigator.pushAndRemoveUntil(
              context,
              ToDosPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'To do',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = textGradient,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      todoEntity.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      Utils.formatDateBydMMMYYYY(todoEntity.updatedAt),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppPallete.greyColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      todoEntity.desc,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 2,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
