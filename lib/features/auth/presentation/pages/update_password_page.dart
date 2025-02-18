import 'package:to_do_app_flutter/core/common/services/deeplink_config.dart';
import 'package:to_do_app_flutter/core/constants.dart';
import 'package:to_do_app_flutter/core/common/widgets/loader.dart';
import 'package:to_do_app_flutter/core/utils.dart';
import 'package:to_do_app_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app_flutter/features/auth/presentation/pages/signin_page.dart';
import 'package:to_do_app_flutter/features/auth/presentation/widgets/auth_field.dart';
import 'package:to_do_app_flutter/features/auth/presentation/widgets/auth_gradient_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// final Shader textGradient = const LinearGradient(
//   colors: <Color>[AppPallete.gradient1, AppPallete.gradient2],
// ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

class UpdatePasswordPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const UpdatePasswordPage(),
      );
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;

  void onTap() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthUpdatePassword(
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              Utils.showSnackBar(context, state.message);
            } else if (state is AuthUpdatePasswordSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                SignInPage.route(),
                (route) => false,
              );
              Utils.showSnackBar(context, "Password Updated Successfully");
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Update\nPassword.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = textGradient,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                    inputAction: TextInputAction.done,
                    showPassword: showPassword,
                    obsecureOnTap: () {
                      if (showPassword == false) {
                        showPassword = true;
                      } else {
                        showPassword = false;
                      }

                      setState(() {});
                    },
                  ),
                  // const SizedBox(height: 15),
                  // AuthField(
                  //   hintText: 'Password',
                  //   controller: passwordController,
                  //   isObscureText: true,
                  // ),
                  const SizedBox(height: 48),
                  AuthGradientButton(
                    buttonText: 'Continue',
                    onPressed: onTap,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
