import 'package:hooks_riverpod/hooks_riverpod.dart';

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
final getDailyMessagesListStreamProvider =
    StreamProvider.family((ref, String date) {
  final dailyController = ref.watch(dailyControllerProvider.notifier);
  return dailyController.getDailyMessagesListStream(date);
});

class DailyController extends StateNotifier<bool> {
  final DailyRepository _dailyRepository;
  final Ref _ref;

  DailyController({required DailyRepository dailyRepository, required Ref ref})
      : _dailyRepository = dailyRepository,
        _ref = ref,
        super(false); //loading

  Stream<DailyMessageModel> getDailyMessage(String date) {
    return _dailyRepository.getDailyMessage(date);
  }

  Stream<List<DailyMessageModel>> getDailyMessagesListStream(String date) {
    return _dailyRepository.getDailyMessagesListStream(date);
  }
}
