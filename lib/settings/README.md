## Settings

This directory should only contain models and convenience methods used to persist
the settings state.

Models here are categorized into 2 types:

1. [Unique per collection](###Unique-Per-Collection)
2. [Unique per entity](###Unique-Per-Entity)

### Unique Per Collection

-   Id is auto-incremented and the model itself is replaced by an unchangeable `key`.
-   'getByKey` should be used to query from Isar.
-   `static const isarKey` should be populated with same `key` to expose to the rest of the app.

As an example, `CoverPersistence` is unique per collection:

```
CoverPersistence ->
    id = auto
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
