import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers/firebase_providers.dart';
import '../oldauth/user_model.dart';
import 'main_repository.dart';

final getMeUserModelProvider =
    FutureProvider.autoDispose((ref) => ref.watch(mainControllerProvider.notifier).getMeUserModel());

final mainControllerProvider = StateNotifierProvider<MainController, bool>((ref) => MainController(
      ref.watch(mainRepositoryProvider),
      ref,
    ));

class MainController extends StateNotifier<bool> {
  final MainRepository _mainRepository;
  final Ref _ref;

  MainController(this._mainRepository, this._ref) : super(false);

  Future<UserModel> getMeUserModel() async {
    User? auser = _ref.watch(authProvider).currentUser;
    String uid;
    auser != null ? uid = auser.uid : uid = "PyY5skHRgPJP0CMgI2Qp";
    return await _mainRepository.getMeUserModel(uid);
  }
}
