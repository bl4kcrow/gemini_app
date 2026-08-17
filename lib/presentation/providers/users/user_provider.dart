import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
User geminiUser(Ref ref) {
  final geminiUser = User(
    id: 'gemini-id',
    name: 'Gemini',
    imageSource: 'https://picsum.photos/id/179/200/200',
  );

  return geminiUser;
}

@riverpod
User user(Ref ref) {
  final user = User(
    id: 'user-id',
    name: 'Blakcrow',
    imageSource: 'https://picsum.photos/id/177/200/200',
  );

  return user;
}
