import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/messages/message_model.dart';
import 'package:wakeuphoney/features/messages/messgaes_repo.dart';

final messageProvider = StateProvider<MessageModel?>((ref) => null);

final messageControllerProvider =
    StateNotifierProvider<MessageController, bool>(
  (ref) => MessageController(
    messagesRepo: ref.watch(steamMessageServiceProvider),
    ref: ref,
  ),
);

final getMessageOfDayProvider = StreamProvider.family((ref, String date) =>
    ref.watch(messageControllerProvider.notifier).getMessageOfDay(date));

class MessageController extends StateNotifier<bool> {
  final MessagesRepo _messagesRepo;
  final Ref _ref;
  MessageController({
    required MessagesRepo messagesRepo,
    required Ref ref,
  })  : _messagesRepo = messagesRepo,
        _ref = ref,
        super(false);

  Stream<List<MessageModel>> getMessageOfDay(String date) {
    return _messagesRepo.getMessageOfDay(date);
  }
}
