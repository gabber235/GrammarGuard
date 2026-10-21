// Every color, size and duration in one place.
import "package:flutter/material.dart";
import "package:grammar_guard/ui/motion.dart";

/// The Rail palette. A ThemeExtension rather than a Freezed class, because
/// Flutter's ThemeExtension contract needs its own copyWith and lerp.
///
/// Surfaces stack in three levels, the same everywhere:
/// the window ([glass] or [surface]), a [raised] panel on it, and a
/// [floating] layer over everything (dialogs, toasts, the reason note).
@immutable
class GgTheme extends ThemeExtension<GgTheme> {
  const GgTheme({
    required this.surface,
    required this.glass,
    required this.raised,
    required this.floating,
    required this.shadow,
    required this.ink,
    required this.muted,
    required this.hairline,
    required this.highlighter,
    required this.added,
    required this.removed,
    required this.profile,
    required this.you,
    required this.model,
    required this.pin,
    required this.textSize,
  });

  /// Solid window color where the OS has no blur (Linux, normal window).
  final Color surface;

  /// The tint over the blurred desktop in popup mode.
  final Color glass;

  /// Panels on the window: cards, fields, list groups.
  final Color raised;

  /// Layers above the window content: the bar, dialogs, toasts.
  final Color floating;
  final Color shadow;
  final Color ink;
  final Color muted;
  final Color hairline;

  /// The current thing, everywhere: the change under review, the bar row,
  /// the proposal line, the settings page. Painted as a pill and a tint.
  final Color highlighter;
  final Color added;
  final Color removed;

  /// Origin colors: from a profile, picked by you, the model.
  final Color profile;
  final Color you;
  final Color model;

  /// Rail dots for changes that are not current.
  final Color pin;

  /// The review text. Large on purpose; Settings has a reading size.
  final double textSize;

  /// The tint behind the current row or change.
  Color get current => highlighter.withValues(alpha: 0.16);

  static const radius = 12.0;
  static const smallRadius = 8.0;

  static const dark = GgTheme(
    surface: Color(0xFF22262E),
    glass: Color(0xB822262E),
    raised: Color(0x12FFFFFF),
    floating: Color(0xF22A2F38),
    shadow: Color(0x73000000),
    ink: Color(0xFFEDEFF3),
    muted: Color(0xFFA9B1C1),
    hairline: Color(0x1FFFFFFF),
    highlighter: Color(0xFFFFC94D),
    added: Color(0xFF5EE0C2),
    removed: Color(0xFFF08AA8),
    profile: Color(0xFF8C9BFF),
    you: Color(0xFFFFC94D),
    model: Color(0xFF5FC8E8),
    pin: Color(0xFF4A5263),
    textSize: 19,
  );

  /// Light needs darker inks for contrast and a deeper, softer highlighter.
  static const light = GgTheme(
    surface: Color(0xFFF6F7F9),
    // Whiter and a little more see-through than the dark glass: over the
    // light popover material it reads as frosted, not grey.
    glass: Color(0xBFFAFAFB),
    raised: Color(0x0D1D2330),
    floating: Color(0xF7FFFFFF),
    shadow: Color(0x2E1D2330),
    ink: Color(0xFF1D2330),
    muted: Color(0xFF5B6475),
    hairline: Color(0x1A1D2330),
    highlighter: Color(0xFFE8A800),
    added: Color(0xFF0E7F69),
    removed: Color(0xFFB8325D),
    profile: Color(0xFF4B5BD6),
    you: Color(0xFFA87400),
    model: Color(0xFF1C7FA3),
    pin: Color(0xFFC3C9D4),
    textSize: 19,
  );

  /// Material widgets restyled to the three surface levels, so a ListTile,
  /// Switch or dialog looks like it belongs here without per screen code.
  ThemeData toThemeData(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: highlighter,
      brightness: brightness,
      primary: highlighter,
      onPrimary: const Color(0xFF1D2330),
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: muted,
      outline: hairline,
      outlineVariant: hairline,
      tertiary: added,
      error: removed,
      surfaceTint: Colors.transparent,
    );
    final rounded = RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    final small = RoundedRectangleBorder(borderRadius: BorderRadius.circular(smallRadius));
    final field = OutlineInputBorder(
      borderRadius: BorderRadius.circular(smallRadius),
      borderSide: BorderSide(color: hairline),
    );
    // Every component style starts from this, or it falls back to the
    // system font and the screens stop matching.
    final base = TextStyle(fontFamily: "Atkinson Hyperlegible Next", color: ink);
    final text = Typography.material2021(platform: TargetPlatform.macOS).black
        .apply(fontFamily: "Atkinson Hyperlegible Next", bodyColor: ink, displayColor: ink);
    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: "Atkinson Hyperlegible Next",
      textTheme: text.copyWith(
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 15, height: 1.45),
        bodySmall: text.bodySmall?.copyWith(fontSize: 13, color: muted),
        labelMedium: text.labelMedium?.copyWith(fontSize: 13, color: muted, fontWeight: FontWeight.w600),
        titleMedium: text.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      // The window itself is glass or [surface] (GlassSurface); pages are
      // see-through so every page shares it.
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: floating,
      splashFactory: NoSplash.splashFactory,
      hoverColor: raised,
      focusColor: current,
      highlightColor: Colors.transparent,
      dividerTheme: DividerThemeData(color: hairline, thickness: 1, space: 1),
      cardTheme: CardThemeData(color: raised, elevation: 0, margin: EdgeInsets.zero, shape: rounded),
      listTileTheme: ListTileThemeData(
        shape: small,
        selectedColor: ink,
        selectedTileColor: current,
        iconColor: muted,
        subtitleTextStyle: base.copyWith(fontSize: 13, color: muted, height: 1.4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: muted,
        collapsedIconColor: muted,
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: raised,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: field,
        enabledBorder: field,
        focusedBorder: field.copyWith(borderSide: BorderSide(color: highlighter, width: 1.5)),
        hintStyle: base.copyWith(color: muted),
        labelStyle: base.copyWith(color: muted),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? surface : muted),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? highlighter : raised),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: raised,
        selectedColor: current,
        side: BorderSide(color: hairline),
        shape: small,
        labelStyle: base.copyWith(fontSize: 14, color: ink),
        deleteIconColor: muted,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        showCheckmark: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: floating,
        elevation: 24,
        shadowColor: shadow,
        shape: rounded,
        titleTextStyle: base.copyWith(fontSize: 17, fontWeight: FontWeight.w600, color: ink),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: floating,
        contentTextStyle: base.copyWith(fontSize: 15),
        elevation: 12,
        shape: rounded.copyWith(side: BorderSide(color: hairline)),
        width: 460,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: floating, borderRadius: BorderRadius.circular(smallRadius)),
        textStyle: base.copyWith(fontSize: 13, color: ink),
        waitDuration: const Duration(milliseconds: 400),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: ink, shape: small, padding: const EdgeInsets.all(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: highlighter,
          foregroundColor: const Color(0xFF1D2330),
          shape: small,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: base.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: muted, shape: small),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: highlighter,
        linearTrackColor: raised,
        linearMinHeight: 2,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: highlighter,
        inactiveTrackColor: raised,
        thumbColor: highlighter,
        overlayShape: SliderComponentShape.noOverlay,
      ),
      // Pages share one glass window, so a page lifts in once the one below
      // has sunk away, instead of sliding a see-through page over another.
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {for (final platform in TargetPlatform.values) platform: const LiftPageTransitionsBuilder()},
      ),
      extensions: [this],
    );
  }

  @override
  GgTheme copyWith({double? textSize}) => GgTheme(
    surface: surface,
    glass: glass,
    raised: raised,
    floating: floating,
    shadow: shadow,
    ink: ink,
    muted: muted,
    hairline: hairline,
    highlighter: highlighter,
    added: added,
    removed: removed,
    profile: profile,
    you: you,
    model: model,
    pin: pin,
    textSize: textSize ?? this.textSize,
  );

  @override
  GgTheme lerp(GgTheme? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return GgTheme(
      surface: c(surface, other.surface),
      glass: c(glass, other.glass),
      raised: c(raised, other.raised),
      floating: c(floating, other.floating),
      shadow: c(shadow, other.shadow),
      ink: c(ink, other.ink),
      muted: c(muted, other.muted),
      hairline: c(hairline, other.hairline),
      highlighter: c(highlighter, other.highlighter),
      added: c(added, other.added),
      removed: c(removed, other.removed),
      profile: c(profile, other.profile),
      you: c(you, other.you),
      model: c(model, other.model),
      pin: c(pin, other.pin),
      textSize: textSize + (other.textSize - textSize) * t,
    );
  }
}

extension GgThemeContext on BuildContext {
  GgTheme get gg => Theme.of(this).extension<GgTheme>()!;
}
