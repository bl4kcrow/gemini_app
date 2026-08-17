// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_gemini_writting.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IsGeminiWritting)
const isGeminiWrittingProvider = IsGeminiWrittingProvider._();

final class IsGeminiWrittingProvider
    extends $NotifierProvider<IsGeminiWritting, bool> {
  const IsGeminiWrittingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isGeminiWrittingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isGeminiWrittingHash();

  @$internal
  @override
  IsGeminiWritting create() => IsGeminiWritting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isGeminiWrittingHash() => r'84651248d08214b4855138205731dc940430d417';

abstract class _$IsGeminiWritting extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
