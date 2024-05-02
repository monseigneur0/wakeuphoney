import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/screen/user/user_repository.dart';

class UserController extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepositoryProvider);
  }

  Stream<UserModel> getUser(String uid) {
    return _repository.getUser(uid);
  }
}
