import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';
import 'package:wakeuphoney/features/profile/profile_repo.dart';

import '../auth/auth_controller.dart';

final getUserProfileStreamProvider = StreamProvider<UserModel>((ref) {
  return ref.watch(profileControllerProvider.notifier).getUserProfileStream();
});

final getUserProfileStreamByIdProvider =
    StreamProvider.family((ref, String uid) {
  return ref
      .watch(profileControllerProvider.notifier)
      .getUserProfileStreamById(uid);
});

final getCoupleProfileStreamProvider = StreamProvider((ref) {
  return ref.watch(profileControllerProvider.notifier).getCoupleProfileStream();
});

////////////////////////////////////////////////////
final coupleIdProvider = StateProvider((ref) {
  return ref.watch(profileControllerProvider.notifier).getCoupleUidWow();
});

final coupleIdStateProvider = StateProvider<String>((ref) {
  String gogogo = ref.watch(profileControllerProvider.notifier).getCoupleUid();
  return gogogo;
});

final coupleIdFutureProvider = FutureProvider((ref) {
  var gogogo =
      ref.watch(profileControllerProvider.notifier).getCoupleUiFuture();
  return gogogo;
});

final StateNotifierProvider<ProfileController, bool> profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return ProfileController(profileRepo: profileRepo, ref: ref);
});

class ProfileController extends StateNotifier<bool> {
  final ProfileRepo _profileRepo;
  final Ref _ref;
  ProfileController({
    required ProfileRepo profileRepo,
    required Ref ref,
  })  : _profileRepo = profileRepo,
        _ref = ref,
        super(false);

  Stream<UserModel> getUserProfileStream() {
    String uid = "39xWyVZmEqRxPmmSsOVSE2UvQnE2";
    return _profileRepo.getUserProfileStream(uid);
  }

  Stream<UserModel> getUserProfileStreamById(String uid) {
    return _profileRepo.getUserProfileStream(uid);
  }

  Stream<UserModel> getCoupleProfileStream() {
    final uid = _ref
        .watch(getUserDataProvider("39xWyVZmEqRxPmmSsOVSE2UvQnE2"))
        .value!
        .couple;
    return _profileRepo.getUserProfileStream(uid);
  }

  String getCoupleUid() {
    String uid = "39xWyVZmEqRxPmmSsOVSE2UvQnE2";
    String ghghgh = _profileRepo.getCoupleUid(uid);

    return ghghgh;
  }

  getCoupleUiFuture() {
    String uid = "39xWyVZmEqRxPmmSsOVSE2UvQnE2";
    var ghghgh = _profileRepo.getCoupleUidFuture(uid);
    return ghghgh;
  }

  getCoupleUidWow() {
    String uid = "39xWyVZmEqRxPmmSsOVSE2UvQnE2";

    return _ref.watch(getUserDataProvider(uid)).when(
        data: (data) {
          _ref.watch(coupleIdProvider.notifier).state = data.couple;
          return data.couple;
        },
        error: (error, stackTrace) {
          return "error getUserDataProvider ${_ref.watch(coupleIdProvider)}";
        },
        loading: () =>
            "loading getUserDataProvider ${_ref.watch(coupleIdProvider)}");
  }
}
