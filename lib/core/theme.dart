import 'package:flutter/material.dart';

import '../data/models.dart';

/// "Night facade" identity: a deep navy night, cobalt for actions and the warm
/// light of occupied windows for the numbers that matter. Light mode swaps the
/// night for limestone.
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.bg,
    required this.surface,
    required this.raised,
    required this.ink,
    required this.muted,
    required this.line,
    required this.cobalt,
    required this.cobaltSoft,
    required this.glow,
    required this.paid,
    required this.soon,
    required this.late,
    required this.vacant,
    required this.glass,
  });

  final Color bg;
  final Color surface;
  final Color raised;
  final Color ink;
  final Color muted;
  final Color line;
  final Color cobalt;
  final Color cobaltSoft;
  final Color glow;
  final Color paid;
  final Color soon;
  final Color late;
  final Color vacant;

  /// Unlit window glass on the facade.
  final Color glass;

  static const dark = Palette(
    bg: Color(0xFF0A0F1C),
    surface: Color(0xFF121A2B),
    raised: Color(0xFF1A2338),
    ink: Color(0xFFEEF1F7),
    muted: Color(0xFF8E98AD),
    line: Color(0xFF232D44),
    cobalt: Color(0xFF4A6CFF),
    cobaltSoft: Color(0xFF1B2550),
    glow: Color(0xFFFFB547),
    paid: Color(0xFF2DD4A7),
    soon: Color(0xFFFFB547),
    late: Color(0xFFFF5C7A),
    vacant: Color(0xFF3A4560),
    glass: Color(0xFF1C2740),
  );

  static const light = Palette(
    bg: Color(0xFFEEEAE2),
    surface: Color(0xFFFFFFFF),
    raised: Color(0xFFF6F3ED),
    ink: Color(0xFF0D1324),
    muted: Color(0xFF5B6377),
    line: Color(0xFFDCD6CA),
    cobalt: Color(0xFF2F52F0),
    cobaltSoft: Color(0xFFE2E7FF),
    glow: Color(0xFFF2A93B),
    paid: Color(0xFF0F9F78),
    soon: Color(0xFFC98008),
    late: Color(0xFFD93A58),
    vacant: Color(0xFFB9BFCC),
    glass: Color(0xFF2B3550),
  );

  Color status(UnitStatus s) => switch (s) {
    UnitStatus.paid => paid,
    UnitStatus.dueSoon => soon,
    UnitStatus.late => late,
    UnitStatus.vacant => muted,
  };

  /// The card gradient behind the tenant's key card.
  List<Color> get keyGradient => const [
    Color(0xFF7088FF),
    Color(0xFF2F52F0),
    Color(0xFF101A4A),
  ];

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(Palette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return Palette(
      bg: l(bg, other.bg),
      surface: l(surface, other.surface),
      raised: l(raised, other.raised),
      ink: l(ink, other.ink),
      muted: l(muted, other.muted),
      line: l(line, other.line),
      cobalt: l(cobalt, other.cobalt),
      cobaltSoft: l(cobaltSoft, other.cobaltSoft),
      glow: l(glow, other.glow),
      paid: l(paid, other.paid),
      soon: l(soon, other.soon),
      late: l(late, other.late),
      vacant: l(vacant, other.vacant),
      glass: l(glass, other.glass),
    );
  }
}

class Insets {
  Insets._();
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const page = 20.0;
}

class Radii {
  Radii._();
  static const card = 22.0;
  static const control = 16.0;
  static const pill = 100.0;
}

extension ThemeX on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class AppTheme {
  AppTheme._();

  static const body = 'IBMPlexSansArabic';
  static const display = 'Alexandria';
  static const mono = 'PlexMono';

  static ThemeData build(Brightness brightness) {
    final p = brightness == Brightness.dark ? Palette.dark : Palette.light;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.cobalt,
      onPrimary: Colors.white,
      secondary: p.glow,
      onSecondary: const Color(0xFF0A0F1C),
      error: p.late,
      onError: Colors.white,
      surface: p.bg,
      onSurface: p.ink,
      surfaceContainerLowest: p.bg,
      surfaceContainerLow: p.surface,
      surfaceContainer: p.surface,
      surfaceContainerHigh: p.raised,
      surfaceContainerHighest: p.raised,
      outline: p.line,
      outlineVariant: p.line,
      onSurfaceVariant: p.muted,
    );

    TextStyle d(double size, FontWeight w, {double height = 1.2}) => TextStyle(
      fontFamily: display,
      fontSize: size,
      fontWeight: w,
      height: height,
      color: p.ink,
    );
    TextStyle b(double size, FontWeight w, {double height = 1.55, Color? c}) =>
        TextStyle(
          fontFamily: body,
          fontSize: size,
          fontWeight: w,
          height: height,
          color: c ?? p.ink,
        );

    final text = TextTheme(
      displayLarge: d(44, FontWeight.w800, height: 1.05),
      displayMedium: d(36, FontWeight.w800, height: 1.1),
      displaySmall: d(30, FontWeight.w700, height: 1.15),
      headlineMedium: d(24, FontWeight.w700),
      headlineSmall: d(20, FontWeight.w700),
      titleLarge: d(18, FontWeight.w700),
      titleMedium: b(16, FontWeight.w600, height: 1.4),
      titleSmall: b(14, FontWeight.w600, height: 1.4),
      bodyLarge: b(16, FontWeight.w400),
      bodyMedium: b(14, FontWeight.w400),
      bodySmall: b(12.5, FontWeight.w400, c: p.muted),
      labelLarge: b(15, FontWeight.w600, height: 1.2),
      labelMedium: b(13, FontWeight.w500, height: 1.2),
      labelSmall: b(11.5, FontWeight.w500, height: 1.2, c: p.muted),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      fontFamily: body,
      textTheme: text,
      extensions: [p],
      splashFactory: InkSparkle.splashFactory,
      dividerTheme: DividerThemeData(color: p.line, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: p.ink,
        titleTextStyle: text.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: p.muted),
        labelStyle: text.bodyMedium?.copyWith(color: p.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.control),
          borderSide: BorderSide(color: p.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.control),
          borderSide: BorderSide(color: p.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.control),
          borderSide: BorderSide(color: p.cobalt, width: 1.6),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.line,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.raised,
        contentTextStyle: text.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.control),
          side: BorderSide(color: p.line),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : p.muted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.cobalt : p.raised,
        ),
        trackOutlineColor: WidgetStatePropertyAll(p.line),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
