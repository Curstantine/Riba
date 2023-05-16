# Riba

MangaDex client written in Flutter from the ground up with the goal of being fast and MD3 compliant.

## Commands

To generate required type adapters and such:

```fish
dart run build_runner build && dart fix . --apply
```

## Prerequisites

-   Latest version of Flutter.

## Formatting

All the formatting is done hand from now on. The `dartfmt` utility is not reliable enough to be used to produce readable consistent code.

This project will format according to the [flutter style](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo#formatting) with its own quirks.

-   100 character limit if possible.

-   4 tab indent.

Since this project was using `dartfmt` with 2 space indent prior to the migration,
the codebase as of now is not consistent with the above rules.

## Targets other than Android

The project is written in a platform agnostic way, so it should be possible to build for other platform
with a little bit of messing around.
