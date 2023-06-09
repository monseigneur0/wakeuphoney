import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providerModels/Suggestion.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  Future<Suggestion> getSuggestion() async {
    try {
      final res = await Dio().get('https://www.boredapi.com/api/activity');
      return Suggestion.fromJson(res.data);
    } catch (e) {
      throw Exception('Error getting suggestion: $e');
    }
  }
}
