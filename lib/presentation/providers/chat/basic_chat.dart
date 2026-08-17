import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writting.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';

part 'basic_chat.g.dart';

final uuid = Uuid();

@Riverpod(keepAlive: true)
class BasicChat extends _$BasicChat {
  final gemini = GeminiImpl();
  late User geminiUser;

  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    return [];
  }

  void addMessage({required String text, required User user}) {
    //TODO: Add condition when an image is comming

    _addTextMessage(text, user);
  }

  void _addTextMessage(String text, User author) {
    _createTextMessage(text, author.id);
    // _geminiTextResponse(text);
  }

  Future<String> geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);

    final textResponse = await gemini.getResponse(prompt);

    _setGeminiWritingStatus(false);
    _createTextMessage(textResponse, geminiUser.id);

    return textResponse;
  }

  Future<String> geminiStreamResponse(String prompt) async {
    _setGeminiWritingStatus(true);

    String updatedMessage = '';

    final subscription = gemini.getStreamResponse(prompt).listen((
      responseChunk,
    ) {
      if (responseChunk.isNotEmpty) {
        updatedMessage = responseChunk;
      }
    });

    await subscription.asFuture();
    _createTextMessage(updatedMessage, geminiUser.id);
    _setGeminiWritingStatus(false);
    return updatedMessage;
  }

  // Helper methods
  void _createTextMessage(String text, String author) {
    final message = TextMessage(
      id: uuid.v4(),
      authorId: author,
      text: text,
      createdAt: DateTime.now(),
    );

    state = [message, ...state];
  }

  void _setGeminiWritingStatus(bool isWriting) {
    final isGeminiWriting = ref.read(isGeminiWrittingProvider.notifier);
    isWriting
        ? isGeminiWriting.setIsGeminiWritting()
        : isGeminiWriting.setIsGeminiNotWritting();
  }
}
