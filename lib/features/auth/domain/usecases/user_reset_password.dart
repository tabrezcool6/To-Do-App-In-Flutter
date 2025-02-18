import 'package:fpdart/fpdart.dart';
import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/repository/auth_repository.dart';

class UserResetPassword implements UseCase<String, ResetPasswordParams> {
  AuthRepository authRepository;
  UserResetPassword(this.authRepository);

  @override
  Future<Either<Failure, String>> call(ResetPasswordParams params) async {
    return await authRepository.resetPassword(email: params.email);
  }
}

class ResetPasswordParams {
  final String email;
  ResetPasswordParams({required this.email});
}
