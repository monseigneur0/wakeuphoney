import 'package:hooks_riverpod/hooks_riverpod.dart';

final numberProvider = Provider<int>((ref) {
  return 22;
});
final numberStateProvider = StateProvider<int>((ref) {
  return 42;
});
