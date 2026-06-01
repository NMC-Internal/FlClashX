# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

FlClashX is a Flutter-based multi-platform proxy client (Android, Windows, macOS, Linux) and a fork of FlClash. It bundles the [mihomo](https://github.com/metacubex/mihomo) (Clash.Meta) engine as a Go binary/library under `core/` and exposes it to the Flutter UI through two different integration paths depending on platform.

## Build & dev commands

The Flutter SDK version is pinned in `.fvmrc` (via [fvm](https://fvm.app)). **Run all Flutter/Dart tooling through `fvm`** (`fvm flutter`, `fvm dart`, `fvm dart run ...`) so you get the pinned version, not whatever is on `PATH`. `setup.dart` additionally prepends the fvm SDK (`.fvm/flutter_sdk/bin`) to `PATH` for every process it spawns — so internal `flutter`/`dart`/`flutter_distributor` calls use the pinned SDK even if `setup.dart` itself is launched with a different Dart. On a fresh clone run `fvm install` once to materialize `.fvm/flutter_sdk`.

All build orchestration goes through `fvm dart ./setup.dart`, not raw `flutter build`. It:
1. Reads the mihomo version from `core/constant/version.go` and writes `lib/core_version.dart` (single source of truth — do **not** edit `lib/core_version.dart` by hand).
2. Cross-compiles the Go `core/` (as `.so`/`.dll`/`.dylib` for Android via cgo, or as a standalone `FlClashCore` executable for desktop).
3. On Windows, also builds the Rust helper service under `services/helper/`.
4. Invokes Flutter / `flutter_distributor` to package the app.

Common invocations:

```bash
# Android (all ABIs by default; pass --arch to build one ABI)
fvm dart ./setup.dart android --arch arm64
make android_arm64                          # equivalent (make targets call fvm dart)
make android_arm64_core                     # core only (--out core)

# macOS (uses create-dmg, builds .dmg under dist/)
fvm dart ./setup.dart macos --arch arm64 --env stable
make macLocal                                # convenience: cleans dist/build first

# Windows / Linux: fvm dart ./setup.dart {windows|linux} --arch {amd64|arm64}
# --env defaults to "pre"; pass "stable" for stable builds.
# --out app (default when host==target) | core (just compile the Go side).
```

`ANDROID_NDK` must be set for Android cgo builds. Linux builds install apt deps automatically (see `_getLinuxDependencies` in `setup.dart`). macOS notarization is wired via the `notarizeLocal` make target (keychain profile `flclash-notarization`).

Flutter run/test/analyze use the standard CLI via fvm (`fvm flutter run`, `fvm flutter analyze`, `fvm flutter test`) but **you must build the Go core at least once first** so the dynamic library / executable is staged into `libclash/<target>/...` where the app expects it.

### Code generation

The repo relies on `build_runner` for freezed models, `json_serializable`, and `riverpod_generator`. After editing anything under `lib/models/` or `lib/providers/`, regenerate:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

`build.yaml` routes generated files into `lib/models/generated/` and `lib/providers/generated/` (not next to the source). `ffigen` regenerates `lib/clash/generated/clash_ffi.dart` from `libclash/android/arm64-v8a/libclash.h` — only needed when the C ABI of the core changes.

### Localization

Translation strings live in `arb/intl_{en,ru,zh_CN,ja}.arb` and are compiled into `lib/l10n/` (excluded from analyzer). Add keys to **all** ARB files; the generated `AppLocalizations` class is the API.

## Architecture

### Flutter ↔ Core: two paths, one interface

`lib/clash/` defines `ClashHandlerInterface` and selects the implementation in `ClashCore._internal()` based on platform:

- **Android** → `ClashLib` (`lib/clash/lib.dart`): loads `libclash.so` via `dart:ffi` (FFI bindings in `lib/clash/generated/clash_ffi.dart`). Runs in a dedicated **VPN service isolate** entered via the `@pragma('vm:entry-point') _service` function in `lib/main.dart`. The main isolate talks to the service isolate via `IsolateNameServer` ports (see `_handleMainIpc`). `globalState.isService` distinguishes the two.
- **Desktop (Win/Mac/Linux)** → `ClashService` (`lib/clash/service.dart`): spawns the `FlClashCore` executable as a child process and communicates over a Unix socket (or TCP on Windows). The protocol is line-delimited JSON `Action` / `ActionResult` messages defined in `lib/models/core.dart` and mirrored in `core/action.go`.

Both paths converge on `ClashCore` (`lib/clash/core.dart`), so feature code should call `clashCore.*` and stay agnostic of the transport.

### Go core (`core/`)

A thin wrapper around `github.com/metacubex/mihomo`. Build tags `with_gvisor,cmfa` are mandatory (see `Build.tags` in `setup.dart`). Two build modes:
- **lib mode** (`-buildmode=c-shared`, cgo on, Android only) → `libclash.so` + headers exported to `libclash/android/<abi>/includes/`.
- **core mode** (cgo off) → standalone `FlClashCore` binary for desktop.

`core/constant/version.go` is the single source of truth for the embedded mihomo version. `setup.dart` injects it via `-ldflags "-X github.com/metacubex/mihomo/constant.Version=<v>"` and also writes it into `lib/core_version.dart` so the UI can display it.

### Rust helper (`services/helper/`)

A Windows-only privileged helper service used to manage TUN/system-proxy state. Built with `cargo build --release --features windows-service`. The compiled binary's SHA-256 is computed at build time and passed to the Flutter app as `--dart-define=CORE_SHA256=...` for integrity verification.

### State management

Uses **Riverpod** (`flutter_riverpod`) with code-generated providers (`riverpod_annotation` / `riverpod_generator`). Models use **freezed** + `json_serializable`. A `GlobalState` singleton (`lib/state.dart`) holds non-reactive runtime state and the active `AppController`. Long-lived platform side effects (tray, hotkeys, window, proxy, VPN, theme, connectivity, etc.) are composed as widget "managers" in `lib/manager/` and stacked in `Application._buildPlatformState` / `_buildState`.

### Subscription header customization

A major fork-specific feature: subscription endpoints can return `flclashx-*` HTTP headers (`flclashx-widgets`, `flclashx-view`, `flclashx-settings`, `flclashx-background`, `flclashx-servicename`, `flclashx-serverinfo`, etc.) that drive UI layout, server selection widgets, and which settings the subscription is allowed to override. Logic for parsing/applying these headers lives in the profile and dashboard view layers (`lib/views/profiles/`, `lib/views/dashboard/`). See `README_EN.md` for the full header reference before changing this behavior — these are part of the public contract with panel providers (Remnawave).

### Plugins / FFI bridges

Local Flutter plugins under `plugins/` (`proxy`, `window_ext`) are referenced via `path:` in `pubspec.yaml`. `plugins/flutter_distributor` is a **git submodule** (custom fork) — clone with `--recurse-submodules`. Native channels for Android (tile/VPN) and desktop (tray/window) sit in `lib/plugins/`.

## Conventions

- Lint rules in `analysis_options.yaml` are strict (extends `flutter_lints` with many extras enabled, including `unawaited_futures`, `directives_ordering`, `prefer_const_*`, `sort_pub_dependencies`). Run `flutter analyze` before committing.
- Generated dirs (`lib/clash/generated/`, `lib/l10n/`, `lib/models/generated/`, `lib/providers/generated/`) are excluded from analysis — don't hand-edit them.
- Logging in core paths uses `commonPrint.log` (file logger) rather than `print` (the `avoid_print` lint is on).
- When changing the FFI surface, update both `core/lib_android.go` and the Dart side (`lib/clash/lib.dart`); regenerate `clash_ffi.dart` only if the C header actually changed.
