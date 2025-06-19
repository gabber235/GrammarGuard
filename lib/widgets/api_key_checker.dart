import "package:flutter/material.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:grammar_guard/widgets/api_key_input.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ApiKeyChecker extends ConsumerWidget {
  const ApiKeyChecker({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKeyAsync = ref.watch(apiKeyStateProvider);

    return apiKeyAsync.when(
      data: (apiKeys) {
        if (apiKeys.isEmpty) {
          return const ApiKeyInput();
        }
        return child;
      },
      loading: () =>
          Scaffold(body: const Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text("Error: $error"))),
    );
  }
}
