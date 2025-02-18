import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

// TODO : STEP 7 - Use case Interface class
// every use case has just one function, because it needs to do one single task
// Expose the high level functionaluty of any process
abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

// This comes from "CurrentUser" UseCase class
class NoParams {}
