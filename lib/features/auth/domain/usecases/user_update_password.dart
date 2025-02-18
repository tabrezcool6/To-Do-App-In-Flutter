import 'package:fpdart/fpdart.dart';
import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/repository/auth_repository.dart';

class UserUpdatePassword implements UseCase<String, UserUpdatePasswordParams> {
  AuthRepository authRepository;
  UserUpdatePassword(this.authRepository);

  @override
  Future<Either<Failure, String>> call(UserUpdatePasswordParams params) async {
    return await authRepository.updatePassword(password: params.password);
  }
}

class UserUpdatePasswordParams {
  final String password;
  UserUpdatePasswordParams({required this.password});
}
