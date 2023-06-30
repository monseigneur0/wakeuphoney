import 'package:hooks_riverpod/hooks_riverpod.dart';

final steamServiceProvider = Provider<StreamService>((ref) => StreamService());

class StreamService {
  Stream<int> getStream() {
    return Stream.periodic(const Duration(seconds: 1), (i) => i).take(10);
  }
}
