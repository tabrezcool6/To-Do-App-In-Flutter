import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignOut implements UseCase<String, NoParams> {
  AuthRepository authRepository;
  UserSignOut(this.authRepository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}
