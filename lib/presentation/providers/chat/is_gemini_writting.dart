import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_gemini_writting.g.dart';

@riverpod
class IsGeminiWritting extends _$IsGeminiWritting {
  @override
  bool build() {
    return false;
  }

  void setIsGeminiWritting() {
    state = true;
  }

  void setIsGeminiNotWritting() {
    state = false;
  }
}
