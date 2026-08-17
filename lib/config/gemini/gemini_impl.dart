import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiImpl {
  final Dio _http = Dio(
    BaseOptions(
      baseUrl: dotenv.get('ENDPOINT_API'),
      // connectTimeout: const Duration(seconds: 10),
    ),
  );

  Future<String> getResponse(String prompt) async {
    try {
      final body = jsonEncode({'prompt': prompt});

      final response = await _http.post('/basic-prompt', data: body);
      return response.data;
    } catch (error) {
      throw Exception('Failed to get response: $error');
    }
  }

  Stream<String> getStreamResponse(String prompt) async* {
    try {
      final body = jsonEncode({'prompt': prompt});
      final response = await _http.post(
        '/basic-prompt-stream',
        data: body,
        options: Options(responseType: ResponseType.stream),
      );

      final responseData = response.data.stream as Stream<List<int>>;
      String responseStream = '';

      await for (final chunk in responseData) {
        final chunkString = utf8.decode(chunk, allowMalformed: true);
        responseStream += chunkString;
        yield responseStream;
      }
    } catch (error) {
      throw Exception('Failed to get stream response: $error');
    }
  }
}
