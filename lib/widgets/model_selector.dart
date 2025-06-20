import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:grammar_guard/widgets/provider_configuration.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ModelListTile extends HookConsumerWidget {
  const ModelListTile({
    required this.model,
    required this.focusNode,
    required this.onTap,
    required this.isSelected,
    required this.isFocused,
    super.key,
  });

  final AiModel model;
  final bool isSelected;
  final bool isFocused;
  final FocusNode focusNode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        model.displayName,
        style: TextStyle(
          color: isFocused ? theme.colorScheme.onPrimary : null,
        ),
      ),
      subtitle: Text(
        "Input: \$${model.pricePerMillionInputTokens}/1M tokens, "
        "Output: \$${model.pricePerMillionOutputTokens}/1M tokens",
        style: TextStyle(
          color: isFocused
              ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
              : null,
        ),
      ),
      selected: isSelected,
      focusNode: focusNode,
      tileColor:
          isFocused ? theme.colorScheme.primary.withValues(alpha: 0.3) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onTap,
    );
  }
}

class ModelSelector extends ConsumerStatefulWidget {
  const ModelSelector({super.key});

  @override
  ConsumerState<ModelSelector> createState() => _ModelSelectorState();
}

class _ModelSelectorState extends ConsumerState<ModelSelector> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final List<FocusNode> _tileFocusNodes = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    for (final node in _tileFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  List<AiModel> get _filteredModels {
    final models = ref.watch(modelRegistryProvider).value ?? [];
    if (_searchQuery.isEmpty) return models;
    return models.where((model) {
      return model.displayName.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
          model.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _handleNextFocus() {
    if (_focusNode.hasFocus) {
      if (_tileFocusNodes.isNotEmpty) {
        _tileFocusNodes[0].requestFocus();
      }
    } else {
      final focusedIndex = _tileFocusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1) {
        if (focusedIndex < _tileFocusNodes.length - 1) {
          _tileFocusNodes[focusedIndex + 1].requestFocus();
        } else {
          _focusNode.requestFocus();
        }
      }
    }
  }

  void _handlePreviousFocus() {
    if (_focusNode.hasFocus) {
      if (_tileFocusNodes.isNotEmpty) {
        _tileFocusNodes.last.requestFocus();
      }
    } else {
      final focusedIndex = _tileFocusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1) {
        if (focusedIndex > 0) {
          _tileFocusNodes[focusedIndex - 1].requestFocus();
        } else {
          _focusNode.requestFocus();
        }
      }
    }
  }

  void _handleActivate() {
    if (_focusNode.hasFocus) {
      if (_tileFocusNodes.isNotEmpty) {
        _tileFocusNodes[0].requestFocus();
      }
    } else {
      final focusedIndex = _tileFocusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1) {
        final model = _filteredModels[focusedIndex];
        ref.read(selectedModelProvider.notifier).select(model);
        Navigator.of(context).pop();
        _focusNode.requestFocus();
      }
    }
  }

  void _handleDismiss() {
    if (_focusNode.hasFocus) {
      Navigator.of(context).pop();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _openConfiguration() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ProviderConfiguration(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final models = ref.watch(modelRegistryProvider).value ?? [];

    if (models.isEmpty) {
      return Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning, size: 48, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  "No AI Providers Configured",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You need to configure at least one AI provider to use models.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _openConfiguration,
                  child: const Text("Configure Providers"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Shortcuts(
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.keyN, control: true):
            NextFocusIntent(),
        const SingleActivator(LogicalKeyboardKey.keyP, control: true):
            PreviousFocusIntent(),
        const SingleActivator(LogicalKeyboardKey.keyC, control: true):
            ConfigureIntent(),
      },
      child: Actions(
        actions: {
          NextFocusIntent: CallbackAction<NextFocusIntent>(
            onInvoke: (_) {
              _handleNextFocus();
              return null;
            },
          ),
          PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
            onInvoke: (_) {
              _handlePreviousFocus();
              return null;
            },
          ),
          DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
            onInvoke: (intent) {
              if (intent.direction == TraversalDirection.up) {
                _handlePreviousFocus();
              } else if (intent.direction == TraversalDirection.down) {
                _handleNextFocus();
              }
              return null;
            },
          ),
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleActivate();
              return null;
            },
          ),
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              _handleDismiss();
              return null;
            },
          ),
          ConfigureIntent: CallbackAction<ConfigureIntent>(
            onInvoke: (_) {
              _openConfiguration();
              return null;
            },
          ),
        },
        child: Material(
          color: Colors.black54,
          child: Center(
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: "Search models...",
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                                while (_tileFocusNodes.length >
                                    _filteredModels.length) {
                                  _tileFocusNodes.removeLast().dispose();
                                }
                              });
                            },
                            onSubmitted: (value) {
                              _searchQuery = value;
                              _handleActivate();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _openConfiguration,
                          icon: const Icon(Icons.settings),
                          tooltip: "Configure Providers (Ctrl+C)",
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _filteredModels.length,
                      itemBuilder: (context, index) {
                        while (_tileFocusNodes.length <= index) {
                          _tileFocusNodes.add(FocusNode());
                        }
                        final model = _filteredModels[index];
                        final isSelected =
                            model == ref.watch(selectedModelProvider).value;
                        final isFocused = _tileFocusNodes[index].hasFocus;
                        return ModelListTile(
                          model: model,
                          isSelected: isSelected,
                          isFocused: isFocused,
                          focusNode: _tileFocusNodes[index],
                          onTap: () {
                            ref
                                .read(selectedModelProvider.notifier)
                                .select(model);
                            Navigator.of(context).pop();
                            _focusNode.requestFocus();
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                    ),
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

class ConfigureIntent extends Intent {
  const ConfigureIntent();
}
