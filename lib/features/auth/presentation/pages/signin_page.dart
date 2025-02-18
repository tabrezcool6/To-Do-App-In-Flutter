import 'package:to_do_app_flutter/core/theme/app_pallete.dart';
import 'package:to_do_app_flutter/core/common/widgets/loader.dart';
import 'package:to_do_app_flutter/core/utils.dart';
import 'package:to_do_app_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app_flutter/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:to_do_app_flutter/features/auth/presentation/pages/signup_page.dart';
import 'package:to_do_app_flutter/features/auth/presentation/widgets/auth_field.dart';
import 'package:to_do_app_flutter/features/auth/presentation/widgets/auth_gradient_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/pages/to_dos_page.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignInPage(),
      );
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showPassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void loginOnTap() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthSignIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Shader textGradient = const LinearGradient(
      colors: <Color>[AppPallete.gradient1, AppPallete.gradient2],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              Utils.showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                ToDosPage.route(),
                (route) => false,
              );
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
                children: [
                  Text(
                    'Sign In.',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = textGradient,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 18.0),
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
                  const SizedBox(height: 48.0),
                  AuthGradientButton(
                    buttonText: 'Sign in',
                    onPressed: loginOnTap,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      SignUpPage.route(),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                      onTap: () => Navigator.push(
                            context,
                            ForgotPasswordPage.route(),
                          ),
                      child: Text(
                        'Forgot Password? ',
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
