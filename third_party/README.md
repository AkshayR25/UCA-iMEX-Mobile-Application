# Patched third-party packages

Local copies used through `dependency_overrides` in `pubspec.yaml`, because no upstream release
works with Flutter 3.47+. Drop the override when a fixed version is published.

| Package | Copied from | Patch |
|---|---|---|
| `material_design_icons_flutter` | 7.0.7296 (abandoned upstream, last release 2023) | `IconData` is a `final` class since Flutter 3.47, so `lib/icon_map.dart` no longer subclasses it (`_MdiIconData`); every icon is a plain `const IconData(codePoint, fontFamily: 'Material Design Icons', fontPackage: 'material_design_icons_flutter')`. Same code points and font. |
| `super_tooltip` | 2.1.0 (2.1.1 changes the API the app uses) | Flutter 3.47 added its own `TooltipPositionDelegate`; `lib/src/super_tooltip.dart` imports `package:flutter/material.dart` with `hide TooltipPositionDelegate`. |
