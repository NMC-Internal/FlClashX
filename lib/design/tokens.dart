import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Single source of truth for the Fantomask "Stealth" palette (variant B) and
/// shape tokens (ADR 0013 redesign). Both the Material [ColorScheme] (legacy
/// widgets that remain during the migration) and the forui [FThemeData] (the new
/// UI) are derived from these constants so the two styling systems never drift.
///
/// Hex values mirror the Figma mockups (file fYnzeAX9FfwBbOKqB0RKnX). See
/// `vault/30-resources/wiki/client-redesign-ux.md` for the inventory.
abstract final class AppTokens {
  // ── Palette B — stealth dark ──────────────────────────────────────────────
  /// App background.
  static const bg = Color(0xFF0F1B2A);

  /// Elevated surface: cards, nav bar, fields.
  static const surface = Color(0xFF18293D);

  /// Borders and dividers.
  static const border = Color(0xFF2A3B4F);

  /// Segmented-control inactive fill.
  static const segment = Color(0xFF1F3349);

  /// Brand accent (mint) — primary actions, active state, switches.
  static const accent = Color(0xFF40C987);

  /// Text/icon color on top of [accent].
  static const onAccent = Color(0xFF04342C);

  /// Warning / usage highlight (amber).
  static const amber = Color(0xFFF2A93B);

  /// Primary text.
  static const text = Color(0xFFE6ECF2);

  /// Secondary / muted text.
  static const muted = Color(0xFF7E8C9C);

  /// Outline-button border.
  static const secondaryBorder = Color(0xFF5A6B7E);

  /// Destructive action (log out, delete) — a muted red that reads on the
  /// stealth-dark background without screaming.
  static const danger = Color(0xFFE5675C);

  // ── Radii ─────────────────────────────────────────────────────────────────
  static const rCard = 16.0;
  static const rButton = 14.0;
  static const rField = 12.0;
  static const rSegment = 9.0;
  static const rPill = 999.0;

  /// Translucent accent fill for badges/CTA pills (accent @ 16%).
  static Color get accentTint => accent.withValues(alpha: 0.16);

  /// Material dark [ColorScheme] derived from the tokens. Used by the legacy
  /// Material widgets still on screen during the migration, and as the bridge
  /// source for the forui theme.
  static ColorScheme materialDark() => ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.dark,
      ).copyWith(
        primary: accent,
        onPrimary: onAccent,
        secondary: accent,
        onSecondary: onAccent,
        surface: bg,
        onSurface: text,
        surfaceContainerLowest: bg,
        surfaceContainerLow: surface,
        surfaceContainer: surface,
        surfaceContainerHigh: surface,
        surfaceContainerHighest: surface,
        onSurfaceVariant: muted,
        outline: border,
        outlineVariant: border,
        error: amber,
      );

  /// forui [FThemeData] derived from the same tokens. [touch] selects
  /// touch-optimized sizing (mobile) vs compact (desktop).
  static FThemeData forui({required bool touch}) {
    final colors = FColors.slateDark.copyWith(
      background: bg,
      foreground: text,
      primary: accent,
      primaryForeground: onAccent,
      secondary: surface,
      secondaryForeground: text,
      muted: surface,
      mutedForeground: muted,
      card: surface,
      border: border,
    );
    return FThemeData(colors: colors, touch: touch);
  }
}
