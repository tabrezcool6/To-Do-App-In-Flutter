import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:to_do_app_flutter/core/common/entities/user.dart';
import 'package:to_do_app_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository authRepository;
  UserSignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}

// create sign in parameters class
class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
