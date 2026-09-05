import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

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

  Stream<String> getBasicStreamResponse(
    String prompt, {
    List<XFile> files = const [],
  }) async* {
    yield* _getStreamResponse(
      endpoint: '/basic-prompt-stream',
      prompt: prompt,
      files: files,
    );
  }

  Stream<String> getChatStream(
    String prompt, {
    required String chatId,
    List<XFile> files = const [],
  }) async* {
    yield* _getStreamResponse(
      endpoint: '/chat-stream',
      prompt: prompt,
      files: files,
      additionalFormFields: {'chatId': chatId},
    );
  }

  Stream<String> _getStreamResponse({
    required String endpoint,
    required String prompt,
    List<XFile> files = const [],
    Map<String, dynamic> additionalFormFields = const {},
  }) async* {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('prompt', prompt));

      for (final entry in additionalFormFields.entries) {
        formData.fields.add(MapEntry(entry.key, entry.value));
      }

      if (files.isNotEmpty) {
        for (final file in files) {
          formData.files.add(
            MapEntry(
              'files',
              await MultipartFile.fromFile(file.path, filename: file.name),
            ),
          );
        }
      }

      final response = await _http.post(
        endpoint,
        data: formData,
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
