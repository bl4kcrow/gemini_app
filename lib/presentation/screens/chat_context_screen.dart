import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:gemini_app/presentation/providers/chat/chat_with_context.dart';
import 'package:gemini_app/presentation/providers/chat/is_gemini_writting.dart';
import 'package:gemini_app/presentation/providers/users/user_provider.dart';

class ChatContextScreen extends ConsumerStatefulWidget {
  const ChatContextScreen({super.key});

  @override
  ConsumerState<ChatContextScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatContextScreen> {
  final ChatController _chatController = InMemoryChatController();
  final _uuid = const Uuid();
  List<XFile> images = [];

  @override
  void initState() {
    super.initState();
    final chatMessages = ref.read(chatWithContextProvider);
    _chatController.setMessages(chatMessages);
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGeminiWritting = ref.watch(isGeminiWrittingProvider);
    final user = ref.watch(userProvider);
    final geminiUser = ref.watch(geminiUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Context'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(chatWithContextProvider.notifier).newChat();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Stack(
        children: [
          Chat(
            currentUserId: user.id,
            resolveUser: (id) async {
              return id == geminiUser.id
                  ? User(
                      id: geminiUser.id,
                      name: geminiUser.name,
                      imageSource: geminiUser.imageSource,
                    )
                  : User(
                      id: user.id,
                      name: user.name,
                      imageSource: user.imageSource,
                    );
            },
            chatController: _chatController,
            onMessageSend: (text) async {
              for (final image in images) {
                _chatController.insertMessage(
                  ImageMessage(
                    id: _uuid.v4(),
                    authorId: user.id,
                    source: image.path,
                  ),
                );
              }
              _chatController.insertMessage(
                TextMessage(id: _uuid.v4(), authorId: user.id, text: text),
              );

              ref
                  .read(chatWithContextProvider.notifier)
                  .addMessage(text: text, user: user, images: images);

              final geminiResponse = await ref
                  .read(chatWithContextProvider.notifier)
                  .geminiStreamResponse(text, images: images);
              if (geminiResponse.isNotEmpty) {
                _chatController.insertMessage(
                  TextMessage(
                    id: _uuid.v4(),
                    authorId: geminiUser.id,
                    text: geminiResponse,
                  ),
                );
              }
            },
            onAttachmentTap: () async {
              images = [];
              ImagePicker picker = ImagePicker();
              images = await picker.pickMultiImage(limit: 4);
            },
            builders: Builders(
              imageMessageBuilder:
                  (
                    context,
                    message,
                    index, {
                    required bool isSentByMe,
                    MessageGroupStatus? groupStatus,
                  }) => FlyerChatImageMessage(message: message, index: index),
            ),
            theme: ChatTheme.light(),
          ),
          if (isGeminiWritting)
            Positioned(
              bottom: 100,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IsTypingIndicator(color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Gemini is typing...',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
