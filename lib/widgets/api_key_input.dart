import "package:flutter/material.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:url_launcher/url_launcher.dart";

class ApiKeyInput extends ConsumerStatefulWidget {
  const ApiKeyInput({super.key});

  @override
  ConsumerState<ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends ConsumerState<ApiKeyInput> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _submitApiKey() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(apiKeyStateProvider.notifier)
          .setApiKey("gemini", _apiKeyController.text);
    }
  }

  Future<void> _launchUrl() async {
    final url = Uri.parse("https://makersuite.google.com/app/apikey");
    if (!await launchUrl(url)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not launch API key page"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Welcome to GrammarGuard!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "To get started, you need to provide your Google AI (Gemini) API key. You can get one from:",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _launchUrl,
                    child: const Text(
                      "https://makersuite.google.com/app/apikey",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: "API Key",
                      hintText: "Enter your Gemini API key",
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your API key";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submitApiKey(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitApiKey,
                    child: const Text("Save API Key"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
