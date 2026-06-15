import 'package:flclashx/models/models.dart';

/// Legacy navigation source. The redesigned UI (ADR 0013) supplies its own
/// 5-section shell (`lib/views/redesign/shell.dart`), so this returns no items.
/// The provider chain in `providers/state.dart` still references it but is no
/// longer consumed by any live UI; kept as a thin stub to avoid touching the
/// generated providers.
class Navigation {
  factory Navigation() {
    _instance ??= Navigation._internal();
    return _instance!;
  }

  Navigation._internal();
  static Navigation? _instance;

  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) =>
      const [];
}

final navigation = Navigation();
