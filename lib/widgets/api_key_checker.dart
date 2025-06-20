import "package:flutter/material.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/widgets/provider_configuration.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ConfigurationChecker extends ConsumerWidget {
  const ConfigurationChecker({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(modelRegistryProvider);

    return models.when(
      data: (models) {
        if (models.isEmpty) {
          return const ProviderConfiguration();
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
