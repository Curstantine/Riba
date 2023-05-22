# Settings

A setting must contain two classes that are bound together:

-   [SettingsController](#settingscontroller)
-   [SettingsStore](#settingsstore)

## SettingsController

The controller bound to a [SettingsStore](#settingsstore) to load, mutate and persist the settings state.

### But why?

-   Allows the consumer to easily mutate a single property of the settings using the convenience methods.
-   Ability to hoist a property to a `ValueNotifier` to listen to changes done to a single property.
    -   [Isar does not support this yet](https://github.com/isar/isar/issues/1237).

## SettingsStore

The collection model and extensions used by isar and the bound controller for persistance.

Models are categorized into 2 types:

1. [Unique per collection](###Unique-Per-Collection)
2. [Unique per entity](###Unique-Per-Entity)

### Unique Per Collection

-   This type is exists only once per collection.
-   Id is always `1`.

As an example, `CoverPersistence` is unique per collection:

```
CoverPersistence ->
    id = 1
    key = "coverCacheSettings" (unchangeable, unique)
```

### Unique Per Entity

-   This type is unique per every entity.
-   Id defines the entity.

As an example, `MangaFilterSettings` is unique per manga:

```
MangaFilterSettings ->
    id = mangaId
    isarId = fastHash of mangaId
```
