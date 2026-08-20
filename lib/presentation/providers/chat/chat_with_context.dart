import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:gemini_app/config/gemini/gemini_impl.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writting.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';

part 'chat_with_context.g.dart';

final uuid = Uuid();

@Riverpod(keepAlive: true)
class ChatWithContext extends _$ChatWithContext {
  final gemini = GeminiImpl();
  late User geminiUser;
  late String chatId;

  @override
  List<Message> build() {
    geminiUser = ref.read(geminiUserProvider);
    chatId = uuid.v4();
    return [];
  }

  void addMessage({
    required String text,
    required User user,
    List<XFile> images = const [],
  }) {
    if (images.isNotEmpty) {
      _addTextMessageWithImages(text, user, images);
      return;
    }

    _addTextMessage(text, user);
  }

  void _addTextMessage(String text, User author) {
    _createTextMessage(text, author.id);
  }

  void _addTextMessageWithImages(
    String text,
    User author,
    List<XFile> images,
  ) async {
    for (XFile image in images) {
      _createImageMessage(image, author);
    }

    await Future.delayed(Duration(milliseconds: 10));

    _createTextMessage(text, author.id);
  }

  Future<String> geminiTextResponse(String prompt) async {
    _setGeminiWritingStatus(true);

    final textResponse = await gemini.getResponse(prompt);

    _setGeminiWritingStatus(false);
    _createTextMessage(textResponse, geminiUser.id);

    return textResponse;
  }

  Future<String> geminiStreamResponse(
    String prompt, {
    List<XFile> images = const [],
  }) async {
    _setGeminiWritingStatus(true);

    String updatedMessage = '';

    final subscription = gemini
        .getChatStream(prompt, files: images, chatId: chatId)
        .listen((responseChunk) {
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
  void newChat() {
    chatId = uuid.v4();
    state = [];
  }
  
  void _createTextMessage(String text, String author) {
    final message = TextMessage(
      id: uuid.v4(),
      authorId: author,
      text: text,
      createdAt: DateTime.now(),
    );

    state = [message, ...state];
  }

  Future<void> _createImageMessage(XFile image, User author) async {
    final message = ImageMessage(
      id: uuid.v4(),
      authorId: author.id,
      createdAt: DateTime.now(),
      source: image.path,
      size: await image.length(),
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
