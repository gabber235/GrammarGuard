import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/actions/grammar_intents.dart";
import "package:grammar_guard/hooks/focus_change.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ModelListTile extends HookConsumerWidget {
  const ModelListTile({
    required this.model,
    required this.focusNode,
    required this.onTap,
    super.key,
  });

  final Model model;
  final FocusNode focusNode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSelected = model == ref.watch(selectedModelProvider);

    final isFocused = useState(focusNode.hasFocus);

    useFocusedChange(
      focusNode,
      ({required hasFocus}) => isFocused.value = hasFocus,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          model.displayName,
          style: TextStyle(
            color:
                isFocused.value
                    ? theme.cardColor
                    : isSelected
                    ? ListTileTheme.of(context).selectedColor
                    : ListTileTheme.of(context).textColor,
          ),
        ),
        subtitle: Text(
          "Input: \$${model.pricePerMillionInputTokens}/1M tokens, "
          "Output: \$${model.pricePerMillionOutputTokens}/1M tokens",
          style: TextStyle(
            color:
                isFocused.value
                    ? theme.cardColor
                    : isSelected
                    ? ListTileTheme.of(context).selectedColor
                    : ListTileTheme.of(context).textColor,
          ),
        ),
        // selected: isSelected,
        focusNode: focusNode,
        tileColor:
            isFocused.value
                ? theme.colorScheme.primary.withValues(alpha: 1)
                : isSelected
                ? ListTileTheme.of(context).selectedTileColor
                : ListTileTheme.of(context).tileColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: onTap,
      ),
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
  final _focusNode = FocusNode(debugLabel: "ModelSelector");
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

  List<Model> get _filteredModels {
    if (_searchQuery.isEmpty) return Model.values;
    return Model.values.where((model) {
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

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.keyN, control: true):
            NextFocusIntent(),
        const SingleActivator(LogicalKeyboardKey.keyP, control: true):
            PreviousFocusIntent(),
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
        },
        child: Material(
          color: Colors.black54,
          child: Center(
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                // color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
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
                          // Clean up excess focus nodes
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
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredModels.length,
                      itemBuilder: (context, index) {
                        while (_tileFocusNodes.length <= index) {
                          _tileFocusNodes.add(FocusNode());
                        }
                        final model = _filteredModels[index];
                        return ModelListTile(
                          model: model,
                          focusNode: _tileFocusNodes[index],
                          onTap: () {
                            ref
                                .read(selectedModelProvider.notifier)
                                .select(model);
                            Navigator.of(context).pop();
                          },
                        );
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
