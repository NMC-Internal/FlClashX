# VPN-клиент (FlClashX)

Десктопный и мобильный VPN-клиент — форк [FlClash](https://github.com/chen08209/FlClash)
на движке [mihomo](https://github.com/metacubex/mihomo) (Clash.Meta). Часть нашего
self-hosted VPN: подключается к нашему бэкенду, авторизуется и сам тянет подписку.

Платформы: **Android, Windows, macOS, Linux**.

## Сборка

SDK Flutter зафиксирован в `.fvmrc` через [fvm](https://fvm.app) — все команды гоняем
через `fvm`. На свежем клоне один раз:

```bash
fvm install
```

Сборка идёт через `setup.dart` (он кросс-компилирует Go-ядро mihomo и пакует
приложение), а не через сырой `flutter build`:

```bash
# Android  (нужен ANDROID_NDK)
fvm dart ./setup.dart android --arch arm64      # или: make android_arm64

# macOS
fvm dart ./setup.dart macos --arch arm64         # или: make macLocal

# Windows / Linux
fvm dart ./setup.dart {windows|linux} --arch {amd64|arm64}
```

Адрес бэкенда задаётся при сборке/запуске через `--dart-define`:

```bash
fvm flutter run -d macos --dart-define=BACKEND_URL=http://127.0.0.1:8080
```

> Ядро (`core/`) должно быть собрано хотя бы раз, иначе приложение не стартует.

## Кодогенерация и локализация

После правок в `lib/models/` или `lib/providers/` — перегенерировать freezed/riverpod:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

Строки локализации — в `arb/intl_{en,ru,zh_CN,ja}.arb`; ключ добавляется во **все** файлы.

## Особенности форка

- Подписка может управлять UI через кастомные `flclashx-*` заголовки (виджеты, имя/лого
  сервиса, тема, кнопка смены сервера). Справочник — в vault:
  `vault/30-resources/wiki/flclashx-subscription-headers.md`.
- Передача HWID и анонсов в панель (работает с [Remnawave](https://github.com/remnawave/panel)).

## Подробнее

- `CLAUDE.md` — гайд по архитектуре и сборке для этого репозитория.
- Контекст продукта и решения — в Obsidian-vault workspace (каталог `vault/`).

Основано на [FlClash](https://github.com/chen08209/FlClash) (mihomo / Clash.Meta).
