import "package:flutter/material.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/provider_registry.dart";
import "package:grammar_guard/state/provider_settings_state.dart";
import "package:grammar_guard/widgets/always_focused.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ProviderConfiguration extends ConsumerStatefulWidget {
  const ProviderConfiguration({super.key});

  @override
  ConsumerState<ProviderConfiguration> createState() =>
      _ProviderConfigurationState();
}

class _ProviderConfigurationState extends ConsumerState<ProviderConfiguration> {
  final Map<String, bool> _expandedProviders = {};

  @override
  void initState() {
    super.initState();
    final providers = ref.read(providerRegistryProvider);
    for (final provider in providers) {
      _expandedProviders[provider.name] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providers = ref.watch(providerRegistryProvider);

    return Actions(
      actions: {
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (intent) {
            Navigator.of(context).pop();
            return null;
          },
        ),
      },
      child: AlwaysFocused(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("AI Provider Configuration"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Configure AI Providers",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Set up your AI providers to use different models. Each provider may require different configuration.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ...providers.map(_buildProviderCard),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderCard(AiProvider provider) {
    final isExpanded = _expandedProviders[provider.name] ?? false;
    final settings = ref.watch(
      providerSettingsForProviderProvider(provider.name),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              provider.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: Switch(
          value: settings.enabled,
          onChanged: (enabled) async {
            await ref
                .read(providerSettingsStateProvider.notifier)
                .setEnabled(provider.name, enabled: enabled);
            ref.invalidate(modelRegistryProvider);
          },
        ),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedProviders[provider.name] = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: provider.buildConfigurationWidget(ref: ref),
          ),
        ],
      ),
    );
  }
}
