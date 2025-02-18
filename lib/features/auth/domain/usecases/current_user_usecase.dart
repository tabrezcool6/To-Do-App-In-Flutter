import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:to_do_app_flutter/core/common/entities/user.dart';
import 'package:to_do_app_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}

// This "NoParams" should me declared here as per the flow,
// but multiples classes or functions make use of this "NoParams" class,
// hence declared in the Universal "UseCase" class
// This is class => " class NoParams {} "

