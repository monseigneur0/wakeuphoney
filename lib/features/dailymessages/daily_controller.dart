import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';

import '../../core/providers/providers.dart';
import 'daily_model.dart';
import 'daily_repo.dart';

final dailyControllerProvider =
    StateNotifierProvider<DailyController, bool>((ref) => DailyController(
          dailyRepository: ref.watch(dailyRepositoryProvider),
          ref: ref,
        ));

final getDailyMessageProvider = StreamProvider.family((ref, String date) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.getDailyMessage(date);
});

class DailyController extends StateNotifier<bool> {
  final DailyRepository _dailyRepository;

  final Ref _ref;

  DailyController({required DailyRepository dailyRepository, required Ref ref})
      : _dailyRepository = dailyRepository,
        _ref = ref,
        super(false); //loading

  Stream<DailyMessageModel> getDailyMessage(String date) {
    final uid = _ref.watch(authProvider).currentUser!.uid;
    return _dailyRepository.getDailyMessage(uid, date);
  }

  void createDailyMessage(message, uid) async {
    await _dailyRepository.createDailyMessage(
        message, _ref.watch(selectedDate), _ref.watch(selectedDateTime), uid);
    // res.fold((l)=> showSnackBar(context, l.message))
  }
}
