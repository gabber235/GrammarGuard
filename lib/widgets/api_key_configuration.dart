import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:url_launcher/url_launcher.dart";

/// A generic configuration widget for AI providers that require API keys.
///
/// This widget provides a reusable interface for configuring API keys for any
/// AI provider that implements the [AiProvider] interface. It includes:
/// - API key input field with visibility toggle
/// - Save and delete functionality
/// - Help button to open the provider's API key URL
/// - Loading states and error handling
/// - Success/error feedback via snackbars
class ApiKeyConfiguration extends HookConsumerWidget {
  const ApiKeyConfiguration({
    required this.providerName,
    required this.providerDisplayName,
    required this.apiKeyUrl,
    required this.apiKeyHint,
    super.key,
  });

  final String providerName;
  final String providerDisplayName;
  final String apiKeyUrl;
  final String apiKeyHint;

  void _showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _saveApiKey(
    WidgetRef ref,
    TextEditingController apiKeyController,
    ValueNotifier<bool> isLoading,
    BuildContext context,
  ) async {
    final apiKey = apiKeyController.text.trim();
    if (apiKey.isEmpty) return;

    isLoading.value = true;

    try {
      await ref.read(apiKeyStateProvider.notifier).setApiKey(
            providerName,
            apiKey,
          );
      ref.invalidate(modelRegistryProvider);
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "$providerDisplayName API key saved",
        Colors.green,
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "Failed to save API key: $e",
        Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _deleteApiKey(
    WidgetRef ref,
    TextEditingController apiKeyController,
    ValueNotifier<bool> isLoading,
    BuildContext context,
  ) async {
    isLoading.value = true;

    try {
      await ref.read(apiKeyStateProvider.notifier).deleteApiKey(
            providerName,
          );
      apiKeyController.clear();
      ref.invalidate(modelRegistryProvider);
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "$providerDisplayName API key deleted",
        Colors.orange,
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "Failed to delete API key: $e",
        Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _openApiKeyUrl() async {
    final url = Uri.parse(apiKeyUrl);
    await launchUrl(url);
  }

  Widget _buildActionButtons(
    TextEditingController apiKeyController,
    ValueNotifier<bool> isLoading,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading.value
                ? null
                : () => _saveApiKey(ref, apiKeyController, isLoading, context),
            child: isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Save API Key"),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: isLoading.value
              ? null
              : () => _deleteApiKey(ref, apiKeyController, isLoading, context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text("Delete"),
        ),
      ],
    );
  }

  Widget _buildApiKeyField(
    TextEditingController apiKeyController,
    ValueNotifier<bool> isObscured,
  ) {
    return TextField(
      controller: apiKeyController,
      obscureText: isObscured.value,
      decoration: InputDecoration(
        labelText: apiKeyHint,
        hintText: "Enter your $providerDisplayName API key",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured.value ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => isObscured.value = !isObscured.value,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "$providerDisplayName Configuration",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: _openApiKeyUrl,
          tooltip: "Get API key from $providerDisplayName",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiKeyController = useTextEditingController();
    final isLoading = useState(false);
    final isObscured = useState(true);
    final apiKey = ref.watch(apiKeyProvider(providerName));

    useEffect(
      () {
        apiKeyController.text = apiKey.value ?? "";
        return null;
      },
      [apiKey.value],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        _buildHeader(context),
        _buildApiKeyField(apiKeyController, isObscured),
        _buildActionButtons(apiKeyController, isLoading, ref, context),
      ],
    );
  }
}
