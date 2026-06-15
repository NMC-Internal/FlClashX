// THROWAWAY SPIKE (branch spike/forui). Two purposes:
//  1) Prove forui compiles & renders in-project (run `flutter analyze` on this file).
//  2) Reproduce application.dart's macOS path — the whole UI scaled inside a
//     FittedBox(BoxFit.contain, 500x800) — so we can eyeball whether forui OVERLAYS
//     (modal sheet, toast) anchor/scale correctly. The sheet is pushed on the
//     Navigator (above MaterialApp.builder, i.e. OUTSIDE the FittedBox), which is
//     exactly the case the redesign spike must verify on macOS.
//
// Run:  fvm flutter run -t lib/spike/forui_smoke.dart -d macos
// (Pure-Flutter smoke — does NOT touch the mihomo core, so no setup.dart build needed.)
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

void main() => runApp(const _SpikeApp());

class _SpikeApp extends StatelessWidget {
  const _SpikeApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => FTheme(
          // .desktop is a lazy getter resolving FPlatformThemeData -> FThemeData.
          data: FThemes.zinc.dark.desktop,
          child: FToaster(child: child!),
        ),
        home: const _Scaled(child: _SmokeScreen()),
      );
}

/// Mirrors application.dart's macOS path (FittedBox 500x800 over the whole UI).
class _Scaled extends StatelessWidget {
  const _Scaled({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 500,
          height: 800,
          // Green frame marks the FittedBox 500x800 bounds. An overlay that
          // escapes it (spans the full window) reveals the anchoring problem.
          child: Container(
            foregroundDecoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF40C987), width: 2),
            ),
            child: child,
          ),
        ),
      );
}

class _SmokeScreen extends StatelessWidget {
  const _SmokeScreen();

  @override
  Widget build(BuildContext context) => FScaffold(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text('forui spike — inside FittedBox 500x800'),
              FButton(
                onPress: () => showFSheet<void>(
                  context: context,
                  side: FLayout.btt,
                  // Decorated panel so the sheet's surface + width are visible:
                  // its width should match the green 500x800 frame, NOT the window.
                  builder: (context) => Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF18293D),
                      border: Border(top: BorderSide(color: Color(0xFFF2A93B), width: 3)),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5A6B7E),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'forui modal bottom sheet',
                          style: TextStyle(color: Color(0xFFE6ECF2), fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Width should match the GREEN 500×800 frame,\nnot the full window',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF9DA8B7), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                child: const Text('Open bottom sheet'),
              ),
              FButton(
                onPress: () => showFToast(
                  context: context,
                  title: const Text('forui toast'),
                ),
                child: const Text('Show toast'),
              ),
            ],
          ),
        ),
      );
}
