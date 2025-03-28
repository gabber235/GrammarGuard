import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grammar_guard/state/api_key_state.dart';
import 'package:grammar_guard/widgets/api_key_input.dart';

class ApiKeyChecker extends ConsumerWidget {
  final Widget child;

  const ApiKeyChecker({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKeyAsync = ref.watch(apiKeyStateProvider);

    return apiKeyAsync.when(
      data: (apiKey) {
        if (apiKey == null) {
          return const ApiKeyInput();
        }
        return child;
      },
      loading:
          () =>
              Scaffold(body: const Center(child: CircularProgressIndicator())),
      error:
          (error, stack) =>
              Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
