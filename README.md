# Riba

Cross-platform mobile MangaDex client.

## Commands

To generate required type adapters and such:

```fish
flutter packages pub run build_runner build && dart fix . --apply
```

## Prerequisites

-   `flutter` version 3.7 or higher.
    -   Target the latest version possible.

## Formatting

All the formatting is done hand from now on. The `dartfmt` utility is not reliable enough to be used to produce readable consistent code.

This project will format according to the [flutter style](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo#formatting) with its own quirks.

-   100 character limit if possible.

-   4 tab indent.

Since this project was using `dartfmt` with 2 space indent prior to the migration,
the codebase as of now is not consistent with the above rules.
