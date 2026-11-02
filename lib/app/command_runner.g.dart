// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_runner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(commandRunner)
final commandRunnerProvider = CommandRunnerProvider._();

final class CommandRunnerProvider extends $FunctionalProvider<CommandRunner, CommandRunner, CommandRunner>
    with $Provider<CommandRunner> {
  CommandRunnerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commandRunnerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commandRunnerHash();

  @$internal
  @override
  $ProviderElement<CommandRunner> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  CommandRunner create(Ref ref) {
    return commandRunner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommandRunner value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CommandRunner>(value));
  }
}

String _$commandRunnerHash() => r'e5f6287cde6a0ea4901b7345bcaad0c48ca108d8';
