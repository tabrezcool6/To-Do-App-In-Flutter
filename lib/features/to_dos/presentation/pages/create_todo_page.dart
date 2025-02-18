import 'package:to_do_app_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:to_do_app_flutter/core/common/widgets/loader.dart';
import 'package:to_do_app_flutter/core/constants.dart';
import 'package:to_do_app_flutter/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/features/auth/presentation/pages/signin_page.dart';
import 'package:to_do_app_flutter/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/bloc/bloc/todo_bloc.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/pages/to_dos_page.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/widgets/text_field.dart';

class CreateTodoPage extends StatefulWidget {
  /// route function to navigate to this page,
  /// requiring the todo object from the homepage, i.e the todos page
  static route({todo}) => MaterialPageRoute(
        builder: (context) => CreateTodoPage(toDoEntity: todo),
      );

  final ToDoEntity? toDoEntity;

  const CreateTodoPage({super.key, this.toDoEntity});

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  ToDoEntity? toDoEntity;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    /// initializing Todo Data values to the local varibales in page
    if (widget.toDoEntity != null) {
      toDoEntity = widget.toDoEntity;
      titleController = TextEditingController(text: widget.toDoEntity!.title);
      descController = TextEditingController(text: widget.toDoEntity!.desc);

      super.initState();
    }
  }

  void uploadTodoOnTap() {
    print('///// upload');
    if (formKey.currentState!.validate()) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<TodoBloc>().add(
            TodoCreateEvent(
              posterId: posterId,
              title: titleController.text.trim(),
              desc: descController.text.trim(),
            ),
          );
    }
  }

  void updateTodoOnTap() async {
    print('///// update');

    final String title = titleController.text.trim();
    final String content = descController.text.trim();

    /// if none value is changed,
    ///  just Navigating back to Home Screen without any API call
    if (title == toDoEntity!.title && content == toDoEntity!.desc) {
      Utils.showSnackBar(context, 'Todo updated successfully');
      Navigator.pushAndRemoveUntil(
        context,
        ToDosPage.route(),
        (route) => false,
      );
      return;
    }

    /// Else validating the data
    if (formKey.currentState!.validate()) {
      final String title = titleController.text.trim();
      final String desc = descController.text.trim();

      /// esle making an API call with passing the changed values
      context.read<TodoBloc>().add(
            TodoUpdateEvent(
              todoEntity: toDoEntity!,
              todoId: toDoEntity!.id,
              title: title,
              desc: desc,
            ),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text((toDoEntity == null) ? 'New Todo' : 'Edit Todo'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: toDoEntity == null ? uploadTodoOnTap : updateTodoOnTap,
        //     icon: const Icon(Icons.done_rounded),
        //   ),
        // ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoFailure) {
            Utils.showSnackBar(context, state.error);
          } else if (state is TodoCreateSuccess) {
            Utils.showSnackBar(context, 'Todo uploaded successfully');

            Navigator.pushAndRemoveUntil(
              context,
              ToDosPage.route(),
              (route) => false,
            );
          } else if (state is TodoUpdateSuccess) {
            Utils.showSnackBar(context, 'Todo updated successfully');

            Navigator.pushAndRemoveUntil(
              context,
              ToDosPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    ///
                    Text(
                      (toDoEntity == null) ? 'Add To do' : 'Edit To do',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = textGradient,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TodoTextField(
                      controller: titleController,
                      hintText: 'Title',
                    ),
                    const SizedBox(height: 10),
                    TodoTextField(
                      controller: descController,
                      hintText: 'Description',
                      inputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 32.0),

                    AuthGradientButton(
                      buttonText: 'Save',
                      onPressed: toDoEntity == null
                          ? uploadTodoOnTap
                          : updateTodoOnTap,
                    ),
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
