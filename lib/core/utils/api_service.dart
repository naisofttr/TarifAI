import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3000',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<Map<String, dynamic>> getRecipes(String ingredients, String languageCode) async {
    try {
      final response = await _dio.post('/api/prompt/getPrompt',
          data: {
            'prompt': ingredients,
            'languageCode': languageCode,
          });
      return response.data;
    } catch (e) {
      throw Exception('Failed to get recipes: $e');
    }
  }
} 