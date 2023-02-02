# riba

Cross-platform mobile MangaDex client.

## Commands

To generate required type adapters and such:
```
flutter packages pub run build_runner build
```

To generate Material Symbols specified in [fms_options.yaml](./fms_options.yaml):
```
flutter pub run fms build material_symbols.yaml
```

## Prerequisites

- `flutter` version 3.7 or higher.
    - Target the latest version possible.
- `node` version 17 or higher.
    - For icon generation.

