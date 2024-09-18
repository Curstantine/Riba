// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MangaDataCWProxy {
  MangaData manga(Manga manga);

  MangaData cover(CoverArt? cover);

  MangaData authors(List<Author> authors);

  MangaData artists(List<Author> artists);

  MangaData tags(List<Tag> tags);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaData(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaData call({
    Manga? manga,
    CoverArt? cover,
    List<Author>? authors,
    List<Author>? artists,
    List<Tag>? tags,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaData.copyWith.fieldName(...)`
class _$MangaDataCWProxyImpl implements _$MangaDataCWProxy {
  const _$MangaDataCWProxyImpl(this._value);

  final MangaData _value;

  @override
  MangaData manga(Manga manga) => this(manga: manga);

  @override
  MangaData cover(CoverArt? cover) => this(cover: cover);

  @override
  MangaData authors(List<Author> authors) => this(authors: authors);

  @override
  MangaData artists(List<Author> artists) => this(artists: artists);

  @override
  MangaData tags(List<Tag> tags) => this(tags: tags);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaData(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaData call({
    Object? manga = const $CopyWithPlaceholder(),
    Object? cover = const $CopyWithPlaceholder(),
    Object? authors = const $CopyWithPlaceholder(),
    Object? artists = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
  }) {
    return MangaData(
      manga: manga == const $CopyWithPlaceholder() || manga == null
          ? _value.manga
          // ignore: cast_nullable_to_non_nullable
          : manga as Manga,
      cover: cover == const $CopyWithPlaceholder()
          ? _value.cover
          // ignore: cast_nullable_to_non_nullable
          : cover as CoverArt?,
      authors: authors == const $CopyWithPlaceholder() || authors == null
          ? _value.authors
          // ignore: cast_nullable_to_non_nullable
          : authors as List<Author>,
      artists: artists == const $CopyWithPlaceholder() || artists == null
          ? _value.artists
          // ignore: cast_nullable_to_non_nullable
          : artists as List<Author>,
      tags: tags == const $CopyWithPlaceholder() || tags == null
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<Tag>,
    );
  }
}

extension $MangaDataCopyWith on MangaData {
  /// Returns a callable class that can be used as follows: `instanceOfMangaData.copyWith(...)` or like so:`instanceOfMangaData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaDataCWProxy get copyWith => _$MangaDataCWProxyImpl(this);
}
