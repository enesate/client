import 'package:client/src/auth/data/user_model.dart';

abstract class BaseAuthRepository {
  Future<void> registerWithUsers({required User user});
  Future<void> signInWithUserNameAndPassword({
    required String userName,
    required String password,
  });
  Future<void> updateUser({
    required String userName,
    required String password,
    required User newUser,
  });
}
