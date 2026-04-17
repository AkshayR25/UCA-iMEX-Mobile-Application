# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Flutter Version

This project uses Flutter **3.29.0** (pinned via `.fvmrc`). Use `fvm flutter` if FVM is installed, otherwise ensure `flutter --version` matches.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (after adding/modifying models, BLoCs, or Freezed classes)
flutter pub run build_runner build --delete-conflicting-outputs

# Generate localization files (after editing lib/l10n/*.arb)
flutter gen-l10n

# Run the app
flutter run

# Run tests
flutter test
flutter test test/core/noauth/switch_endpoint_test.dart  # single test file

# Static analysis
flutter analyze
dart format lib/

# Run custom lint rules
flutter pub run custom_lint

# Build release
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
```

## Architecture Overview

This is a ThingsBoard IoT platform mobile client (Flutter/Dart) for UAV/drone management. It connects to a ThingsBoard backend to display devices, assets, dashboards, alarms, and supports ESP device provisioning via BLE/WiFi/SoftAP.

### Module Structure (Feature-Based Clean Architecture)

Each feature lives under `lib/modules/<feature>/` and follows this layout:

```
module/
├── data/
│   ├── datasource/       # Remote/local data sources
│   ├── models/           # JSON serializable models (generated)
│   └── repository/       # Repository implementation
├── domain/
│   ├── entities/         # Domain models (often Freezed)
│   └── repository/       # Abstract repository interface
├── presentation/
│   ├── bloc/             # BLoC (events, states, bloc class)
│   └── view/             # Pages and widgets
├── di/                   # GetIt registrations for this module
└── {module}_routes.dart  # Fluro route registration
```

### State Management: BLoC

All complex state uses `flutter_bloc`. Events are dispatched to BLoCs which emit states. `AppBlocObserver` logs transitions in debug mode. Simple widget-local state may use `StatefulWidget` or `flutter_hooks`.

### Routing: Fluro

Routes are defined per-module in `*_routes.dart` files and registered centrally in `lib/config/routes/router.dart`. All pages that need navigation/services extend `TbContextWidget` / `TbContextState`.

### Dependency Injection: GetIt

Root dependencies registered in `lib/locator.dart::setUpRootDependencies()`. Module-specific DI is in each module's `di/` folder. Access via `locator<ServiceType>()`.

### TbContext Pattern

`TbContext` is an app-wide context singleton (not Flutter's `BuildContext`). Pages extend `TbContextWidget`/`TbContextState` to access routing, services, and the ThingsBoard client. It is the primary way features access the API client and navigate.

### ThingsBoard Client

Wraps the `thingsboard_client` package. Configured via `IEndpointService` which persists the server URL in Hive. The client handles auth tokens, REST calls, and WebSocket connections to the platform.

### Services Layer (`lib/utils/services/`)

| Service | Purpose |
|---|---|
| `IEndpointService` | Manages API base URL, supports endpoint switching |
| `LocalDatabaseService` | Hive-based local storage |
| `TbSecureStorage` | Keychain/keystore for credentials |
| `CommunicationService` | EventBus for cross-module events |
| `OverlayService` | Toast/snackbar notifications |
| `UserService` | Current user state |
| `LayoutService` | Screen size/responsive layout |

### Code Generation

The project uses:
- **Freezed** — immutable models and unions (`*.freezed.dart`)
- **json_serializable** — JSON models (`*.g.dart`)
- **flutter_gen** — typed asset accessors (`lib/generated/assets.gen.dart`)
- **intl/gen-l10n** — localization (`lib/generated/l10n/`)

Always run `build_runner build` after modifying any file annotated with `@freezed`, `@JsonSerializable`, or similar.

### Localization

Supported languages: English, Arabic, Chinese. Source files in `lib/l10n/*.arb`. Generated classes in `lib/generated/l10n/`. Run `flutter gen-l10n` after editing `.arb` files.

### Environment Variables (Compile-Time)

Defined in `lib/constants/enviroment_variables.dart`:
- `API_CALLS` — logs API calls (debug)
- `VERBOSE` — verbose logging
- `showAppVersion` — shows app version in UI

Pass via `--dart-define=API_CALLS=true` at run time.

### Firebase

Firebase is configured for push notifications (`firebase_messaging`) and analytics. Config lives in `lib/firebase_options.dart` (auto-generated). The Android project ID is `iserv-cmms`.

### ESP Device Provisioning

`lib/modules/device/` includes BLE, SoftAP, and Smart Config provisioning flows for ESP32/ESP8266 devices. Uses git-pinned custom forks of `esp_provisioning_softap` and `plugin_wifi_connect`.

### Entity List Pattern (Devices)

Devices do **not** follow the BLoC/clean-arch module layout. Instead they use a mixin-based pattern:

- `EntitiesBase<T, P>` (`lib/core/entity/entities_base.dart`) — abstract mixin on `HasTbContext`; defines `fetchEntities()`, card builders, tap handler
- `DevicesBase` (`lib/modules/device/devices_base.dart`) — mixin `on EntitiesBase<EntityData, EntityDataQuery>`; overrides `fetchEntities()`, implements card UI
- `DevicesList` / `DevicesListWidget` — concrete widget classes that mix in `DevicesBase` + a list/grid state mixin

`DevicesBase` is applied at the **widget** level (not the State level). The mixin field `_allowedDeviceNamesFuture` caches the area attribute fetch per widget instance. Override `fetchEntities()` (not `initState`) to intercept all data loading.

### Alarm Filtering

`FetchAlarmsUseCase` (`lib/modules/alarm/domain/usecases/alarms/fetch_alarms_usecase.dart`) receives a `userEmail` at construction (injected via `AlarmsDi.init()` called from `AlarmsPage`).

- Alarm type strings may embed the owner email as a `-(email@domain)` suffix — use `stripEmailFromAlarmType()` to strip it before display
- Alarms without an embedded email are shown to all users; alarms with an embedded email are only shown to the matching user

`AlarmsDi.init()` takes a `scopeName` (unique per page instance) and calls `getIt.pushNewScope()` to isolate registrations per page.
