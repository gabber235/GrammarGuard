import "dart:ui";

import "package:flutter/material.dart";

import "../support/desktop.dart";

/// What a film shows around the app: a chat app where the text is written,
/// selected and pasted back, the app's window over it while it shows, and
/// the keys being pressed, so a viewer sees the whole story and not only
/// the window.
class Stage extends ChangeNotifier {
  Stage({required this.light});

  final bool light;

  /// The film's size, and where the app's window shows in it (the size the
  /// app opens at).
  static const size = Size(1280, 820);
  static final window = Rect.fromLTWH(140, 50, 1000, 600);

  /// The chat's messages, oldest first, and the text in its message box.
  final messages = <(String who, String text)>[
    ("Mara", "Build 1.4 is green on CI, thanks everyone."),
    ("Jonas", "Did the login fix make it in, or does it wait for Monday?"),
  ];
  String draft = "";
  bool selected = false;

  /// Whether the app's window shows. Films follow the app's own window.
  bool windowShown = false;

  /// The keys pressed last, and whether they still show.
  List<String> keys = const [];
  bool get keysShown => _keysLeft > Duration.zero;
  Duration _keysLeft = Duration.zero;

  ({String text, int cps, Future<void> Function(String typed) onType})? _typing;
  Duration _typed = Duration.zero;

  /// Shows [keys] as pressed, for a moment.
  void show(List<String> keys) {
    this.keys = keys;
    _keysLeft = const Duration(milliseconds: 900);
    notifyListeners();
  }

  /// Types [text] at [cps] characters a second, into the chat's message box
  /// unless [onType] takes the text so far.
  void type(String text, {int cps = 70, Future<void> Function(String typed)? onType}) {
    _typing = (text: text, cps: cps, onType: onType ?? (typed) async => draft = typed);
    _typed = Duration.zero;
  }

  void selectAll() {
    selected = true;
    notifyListeners();
  }

  /// The app pasted [text] over the selection.
  void paste(String text) {
    draft = text;
    selected = false;
    notifyListeners();
  }

  /// Enter in the chat: the message box is sent.
  void send() {
    messages.add(("You", draft));
    draft = "";
    notifyListeners();
  }

  /// Moves time on by [step]: typing goes on and pressed keys fade.
  Future<void> tick(Duration step) async {
    if (keysShown) _keysLeft -= step;
    if (_typing case (:final text, :final cps, :final onType)) {
      _typed += step;
      final count = (_typed.inMilliseconds * cps ~/ 1000).clamp(0, text.length);
      await onType(text.substring(0, count));
      if (count == text.length) _typing = null;
    }
    notifyListeners();
  }
}

class StageView extends StatelessWidget {
  const StageView({required this.stage, required this.app, super.key});

  final Stage stage;
  final Widget app;

  @override
  Widget build(BuildContext context) {
    final light = stage.light;
    final colors = wallpaper(light: light);
    // The app is built once and stays mounted; only the frame around it
    // follows the stage.
    final window = MediaQuery(
      data: MediaQuery.of(context).copyWith(size: Stage.window.size),
      child: app,
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: colors.base),
        for (final (i, color) in colors.blobs.indexed)
          Positioned(
            left: [-80.0, 700.0, 220.0, 960.0][i],
            top: [-80.0, -140.0, 420.0, 360.0][i],
            child: Container(
              width: 640,
              height: 520,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
        BackdropFilter(filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60), child: const SizedBox.expand()),
        Positioned(left: 40, top: 20, right: 40, bottom: 84, child: _Chat(stage)),
        ListenableBuilder(
          listenable: stage,
          builder: (context, child) => Positioned.fromRect(
            rect: Stage.window,
            child: AnimatedOpacity(
              opacity: stage.windowShown ? 1 : 0,
              duration: const Duration(milliseconds: 120),
              child: child,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40), child: window),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 18,
          height: 48,
          child: ListenableBuilder(
            listenable: stage,
            builder: (context, _) => AnimatedOpacity(
              opacity: stage.keysShown ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: _Keys(stage.keys, light: light),
            ),
          ),
        ),
      ],
    );
  }
}

/// A plain chat app: a channel, its messages, and the message box.
class _Chat extends StatelessWidget {
  const _Chat(this.stage);

  final Stage stage;

  @override
  Widget build(BuildContext context) {
    final light = stage.light;
    final ink = light ? const Color(0xFF1D2330) : const Color(0xFFE6E8EE);
    final quiet = light ? const Color(0xFF6B7280) : const Color(0xFF9AA0AE);
    final text = TextStyle(fontFamily: "Atkinson Hyperlegible Next", fontSize: 16, height: 1.45, color: ink);
    return ListenableBuilder(
      listenable: stage,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          color: light ? const Color(0xFFFFFFFF) : const Color(0xFF1E212A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: light ? const Color(0x22000000) : const Color(0x22FFFFFF)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 200,
              padding: const EdgeInsets.fromLTRB(20, 22, 12, 0),
              decoration: BoxDecoration(
                color: light ? const Color(0xFFF2F3F6) : const Color(0xFF181A21),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Launch team", style: text.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 18),
                  for (final channel in ["general", "release", "random"])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text("# $channel", style: text.copyWith(color: channel == "release" ? ink : quiet)),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("# release", style: text.copyWith(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    for (final (who, message) in stage.messages)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: switch (who) {
                                "You" => const Color(0xFFFFC94D),
                                "Mara" => const Color(0xFF6C8EEF),
                                _ => const Color(0xFF4FB39A),
                              },
                              child: Text(who[0], style: text.copyWith(color: const Color(0xFF1D2330))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(who, style: text.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                                  Text(message, style: text),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 48),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: light ? const Color(0xFFF2F3F6) : const Color(0xFF2A2E39),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text.rich(
                        stage.draft.isEmpty
                            ? TextSpan(
                                text: "Message #release",
                                style: text.copyWith(color: quiet),
                              )
                            : TextSpan(
                                children: [
                                  TextSpan(
                                    text: stage.draft,
                                    style: stage.selected
                                        ? text.copyWith(
                                            backgroundColor: light ? const Color(0xFFB3D4FF) : const Color(0xFF2F5FA8),
                                          )
                                        : text,
                                  ),
                                  if (!stage.selected)
                                    TextSpan(
                                      text: "|",
                                      style: text.copyWith(color: quiet),
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The keys being pressed, as keycaps.
class _Keys extends StatelessWidget {
  const _Keys(this.keys, {required this.light});

  final List<String> keys;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final ink = light ? const Color(0xFF1D2330) : const Color(0xFFF4F5F8);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final key in keys)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: light ? const Color(0xEEFFFFFF) : const Color(0xEE2A2E39),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: light ? const Color(0x33000000) : const Color(0x44FFFFFF)),
            ),
            child: Text(
              key,
              style: TextStyle(fontFamily: "Atkinson Hyperlegible Mono", fontSize: 20, color: ink, height: 1.2),
            ),
          ),
      ],
    );
  }
}
