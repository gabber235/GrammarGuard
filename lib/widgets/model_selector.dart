import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.provider.displayName,
            style: TextStyle(
              color: isFocused
                  ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            "Input: \$${model.pricePerMillionInputTokens}/1M tokens, "
            "Output: \$${model.pricePerMillionOutputTokens}/1M tokens",
            style: TextStyle(
              color: isFocused
                  ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                  : null,
            ),
          ),
        ],
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

class ModelSelector extends HookConsumerWidget {
  const ModelSelector({super.key});

  void _handleNextFocus(FocusNode focusNode, List<FocusNode> tileFocusNodes) {
    if (focusNode.hasFocus) {
      if (tileFocusNodes.isNotEmpty) {
        tileFocusNodes.first.requestFocus();
      }
    } else {
      final focusedIndex = tileFocusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1) {
        if (focusedIndex < tileFocusNodes.length - 1) {
          tileFocusNodes[focusedIndex + 1].requestFocus();
        } else {
          focusNode.requestFocus();
        }
      }
    }
  }

  void _handlePreviousFocus(
    FocusNode focusNode,
    List<FocusNode> tileFocusNodes,
  ) {
    if (focusNode.hasFocus) {
      if (tileFocusNodes.isNotEmpty) {
        tileFocusNodes.last.requestFocus();
      }
    } else {
      final focusedIndex = tileFocusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1) {
        if (focusedIndex > 0) {
          tileFocusNodes[focusedIndex - 1].requestFocus();
        } else {
          focusNode.requestFocus();
        }
      }
    }
  }

  void _handleActivate(
    BuildContext context,
    WidgetRef ref,
    FocusNode focusNode,
    List<FocusNode> tileFocusNodes,
    List<AiModel> filteredModels,
  ) {
    if (focusNode.hasFocus) {
      if (tileFocusNodes.isNotEmpty) {
        tileFocusNodes.first.requestFocus();
      }
    } else {
      final focusedIndex = tileFocusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1) {
        final model = filteredModels[focusedIndex];
        ref.read(selectedModelProvider.notifier).select(model);
        Navigator.of(context).pop();
        focusNode.requestFocus();
      }
    }
  }

  void _handleDismiss(BuildContext context, FocusNode focusNode) {
    if (focusNode.hasFocus) {
      Navigator.of(context).pop();
    } else {
      focusNode.requestFocus();
    }
  }

  void _openConfiguration(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ProviderConfiguration(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final focusNode = useFocusNode();
    final tileFocusNodes = useRef<List<FocusNode>>([]).value;
    final searchQuery = useState("");
    final scrollController = useScrollController();

    useEffect(
      () {
        focusNode.requestFocus();
        return null;
      },
      const [],
    );

    useEffect(
      () {
        return () {
          for (final node in tileFocusNodes) {
            node.dispose();
          }
        };
      },
      const [],
    );

    final models = ref.watch(modelRegistryProvider).value ?? [];

    final filteredModels = useMemoized(
      () {
        if (searchQuery.value.isEmpty) return models;
        return models.where((model) {
          return model.displayName
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              model.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase());
        }).toList();
      },
      [models, searchQuery.value],
    );

    useEffect(
      () {
        while (tileFocusNodes.length > filteredModels.length) {
          tileFocusNodes.removeLast().dispose();
        }
        return null;
      },
      [filteredModels],
    );

    if (models.isEmpty) {
      return _NoProvidersConfigured(
        onConfigure: () => _openConfiguration(context),
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
              _handleNextFocus(focusNode, tileFocusNodes);
              return null;
            },
          ),
          PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
            onInvoke: (_) {
              _handlePreviousFocus(focusNode, tileFocusNodes);
              return null;
            },
          ),
          DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
            onInvoke: (intent) {
              if (intent.direction == TraversalDirection.up) {
                _handlePreviousFocus(focusNode, tileFocusNodes);
              } else if (intent.direction == TraversalDirection.down) {
                _handleNextFocus(focusNode, tileFocusNodes);
              }
              return null;
            },
          ),
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleActivate(
                context,
                ref,
                focusNode,
                tileFocusNodes,
                filteredModels,
              );
              return null;
            },
          ),
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              _handleDismiss(context, focusNode);
              return null;
            },
          ),
          ConfigureIntent: CallbackAction<ConfigureIntent>(
            onInvoke: (_) {
              _openConfiguration(context);
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
                  _ModelSearchField(
                    searchController: searchController,
                    focusNode: focusNode,
                    onChanged: (value) {
                      searchQuery.value = value;
                    },
                    onSubmitted: (value) {
                      searchQuery.value = value;
                      _handleActivate(
                        context,
                        ref,
                        focusNode,
                        tileFocusNodes,
                        filteredModels,
                      );
                    },
                    onConfigure: () => _openConfiguration(context),
                  ),
                  const Divider(),
                  Flexible(
                    child: ListView.separated(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: filteredModels.length,
                      itemBuilder: (context, index) {
                        while (tileFocusNodes.length <= index) {
                          final node = FocusNode();
                          node.addListener(() {
                            if (!node.hasFocus || node.context == null) {
                              return;
                            }
                            Scrollable.ensureVisible(
                              node.context!,
                              alignment: 0.5,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );
                          });
                          tileFocusNodes.add(node);
                        }
                        final model = filteredModels[index];
                        final isSelected =
                            model == ref.watch(selectedModelProvider).value;
                        final isFocused = tileFocusNodes[index].hasFocus;
                        return ModelListTile(
                          model: model,
                          isSelected: isSelected,
                          isFocused: isFocused,
                          focusNode: tileFocusNodes[index],
                          onTap: () {
                            ref
                                .read(selectedModelProvider.notifier)
                                .select(model);
                            Navigator.of(context).pop();
                            focusNode.requestFocus();
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

class _NoProvidersConfigured extends StatelessWidget {
  const _NoProvidersConfigured({required this.onConfigure});

  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
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
                onPressed: onConfigure,
                child: const Text("Configure Providers"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModelSearchField extends StatelessWidget {
  const _ModelSearchField({
    required this.searchController,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onConfigure,
  });

  final TextEditingController searchController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search models...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onConfigure,
            icon: const Icon(Icons.settings),
            tooltip: "Configure Providers (Ctrl+C)",
          ),
        ],
      ),
    );
  }
}

class ConfigureIntent extends Intent {
  const ConfigureIntent();
}
