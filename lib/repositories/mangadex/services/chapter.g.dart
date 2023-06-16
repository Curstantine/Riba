// GENERATED CODE - DO NOT MODIFY BY HAND

part of "chapter.dart";

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MangaDexChapterGetFeedQueryFilterCWProxy {
  MangaDexChapterGetFeedQueryFilter limit(int limit);

  MangaDexChapterGetFeedQueryFilter offset(int offset);

  MangaDexChapterGetFeedQueryFilter mangaId(String mangaId);

  MangaDexChapterGetFeedQueryFilter orderByChapterDesc(bool orderByChapterDesc);

  MangaDexChapterGetFeedQueryFilter translatedLanguages(
      List<Language>? translatedLanguages);

  MangaDexChapterGetFeedQueryFilter excludedGroups(
      List<String>? excludedGroups);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexChapterGetFeedQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexChapterGetFeedQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexChapterGetFeedQueryFilter call({
    int? limit,
    int? offset,
    String? mangaId,
    bool? orderByChapterDesc,
    List<Language>? translatedLanguages,
    List<String>? excludedGroups,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaDexChapterGetFeedQueryFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaDexChapterGetFeedQueryFilter.copyWith.fieldName(...)`
class _$MangaDexChapterGetFeedQueryFilterCWProxyImpl
    implements _$MangaDexChapterGetFeedQueryFilterCWProxy {
  const _$MangaDexChapterGetFeedQueryFilterCWProxyImpl(this._value);

  final MangaDexChapterGetFeedQueryFilter _value;

  @override
  MangaDexChapterGetFeedQueryFilter limit(int limit) => this(limit: limit);

  @override
  MangaDexChapterGetFeedQueryFilter offset(int offset) => this(offset: offset);

  @override
  MangaDexChapterGetFeedQueryFilter mangaId(String mangaId) =>
      this(mangaId: mangaId);

  @override
  MangaDexChapterGetFeedQueryFilter orderByChapterDesc(
          bool orderByChapterDesc) =>
      this(orderByChapterDesc: orderByChapterDesc);

  @override
  MangaDexChapterGetFeedQueryFilter translatedLanguages(
          List<Language>? translatedLanguages) =>
      this(translatedLanguages: translatedLanguages);

  @override
  MangaDexChapterGetFeedQueryFilter excludedGroups(
          List<String>? excludedGroups) =>
      this(excludedGroups: excludedGroups);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexChapterGetFeedQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexChapterGetFeedQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexChapterGetFeedQueryFilter call({
    Object? limit = const $CopyWithPlaceholder(),
    Object? offset = const $CopyWithPlaceholder(),
    Object? mangaId = const $CopyWithPlaceholder(),
    Object? orderByChapterDesc = const $CopyWithPlaceholder(),
    Object? translatedLanguages = const $CopyWithPlaceholder(),
    Object? excludedGroups = const $CopyWithPlaceholder(),
  }) {
    return MangaDexChapterGetFeedQueryFilter(
      limit: limit == const $CopyWithPlaceholder() || limit == null
          ? _value.limit
          // ignore: cast_nullable_to_non_nullable
          : limit as int,
      offset: offset == const $CopyWithPlaceholder() || offset == null
          ? _value.offset
          // ignore: cast_nullable_to_non_nullable
          : offset as int,
      mangaId: mangaId == const $CopyWithPlaceholder() || mangaId == null
          ? _value.mangaId
          // ignore: cast_nullable_to_non_nullable
          : mangaId as String,
      orderByChapterDesc: orderByChapterDesc == const $CopyWithPlaceholder() ||
              orderByChapterDesc == null
          ? _value.orderByChapterDesc
          // ignore: cast_nullable_to_non_nullable
          : orderByChapterDesc as bool,
      translatedLanguages: translatedLanguages == const $CopyWithPlaceholder()
          ? _value.translatedLanguages
          // ignore: cast_nullable_to_non_nullable
          : translatedLanguages as List<Language>?,
      excludedGroups: excludedGroups == const $CopyWithPlaceholder()
          ? _value.excludedGroups
          // ignore: cast_nullable_to_non_nullable
          : excludedGroups as List<String>?,
    );
  }
}

extension $MangaDexChapterGetFeedQueryFilterCopyWith
    on MangaDexChapterGetFeedQueryFilter {
  /// Returns a callable class that can be used as follows: `instanceOfMangaDexChapterGetFeedQueryFilter.copyWith(...)` or like so:`instanceOfMangaDexChapterGetFeedQueryFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaDexChapterGetFeedQueryFilterCWProxy get copyWith =>
      _$MangaDexChapterGetFeedQueryFilterCWProxyImpl(this);
}

abstract class _$MangaDexChapterWithFiltersQueryFilterCWProxy {
  MangaDexChapterWithFiltersQueryFilter limit(int limit);

  MangaDexChapterWithFiltersQueryFilter offset(int offset);

  MangaDexChapterWithFiltersQueryFilter orderByChapterDesc(
      bool orderByChapterDesc);

  MangaDexChapterWithFiltersQueryFilter ids(List<String>? ids);

  MangaDexChapterWithFiltersQueryFilter translatedLanguages(
      List<Language>? translatedLanguages);

  MangaDexChapterWithFiltersQueryFilter excludedGroups(
      List<String>? excludedGroups);

  MangaDexChapterWithFiltersQueryFilter contentRatings(
      List<ContentRating>? contentRatings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexChapterWithFiltersQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexChapterWithFiltersQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexChapterWithFiltersQueryFilter call({
    int? limit,
    int? offset,
    bool? orderByChapterDesc,
    List<String>? ids,
    List<Language>? translatedLanguages,
    List<String>? excludedGroups,
    List<ContentRating>? contentRatings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaDexChapterWithFiltersQueryFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaDexChapterWithFiltersQueryFilter.copyWith.fieldName(...)`
class _$MangaDexChapterWithFiltersQueryFilterCWProxyImpl
    implements _$MangaDexChapterWithFiltersQueryFilterCWProxy {
  const _$MangaDexChapterWithFiltersQueryFilterCWProxyImpl(this._value);

  final MangaDexChapterWithFiltersQueryFilter _value;

  @override
  MangaDexChapterWithFiltersQueryFilter limit(int limit) => this(limit: limit);

  @override
  MangaDexChapterWithFiltersQueryFilter offset(int offset) =>
      this(offset: offset);

  @override
  MangaDexChapterWithFiltersQueryFilter orderByChapterDesc(
          bool orderByChapterDesc) =>
      this(orderByChapterDesc: orderByChapterDesc);

  @override
  MangaDexChapterWithFiltersQueryFilter ids(List<String>? ids) =>
      this(ids: ids);

  @override
  MangaDexChapterWithFiltersQueryFilter translatedLanguages(
          List<Language>? translatedLanguages) =>
      this(translatedLanguages: translatedLanguages);

  @override
  MangaDexChapterWithFiltersQueryFilter excludedGroups(
          List<String>? excludedGroups) =>
      this(excludedGroups: excludedGroups);

  @override
  MangaDexChapterWithFiltersQueryFilter contentRatings(
          List<ContentRating>? contentRatings) =>
      this(contentRatings: contentRatings);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexChapterWithFiltersQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexChapterWithFiltersQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexChapterWithFiltersQueryFilter call({
    Object? limit = const $CopyWithPlaceholder(),
    Object? offset = const $CopyWithPlaceholder(),
    Object? orderByChapterDesc = const $CopyWithPlaceholder(),
    Object? ids = const $CopyWithPlaceholder(),
    Object? translatedLanguages = const $CopyWithPlaceholder(),
    Object? excludedGroups = const $CopyWithPlaceholder(),
    Object? contentRatings = const $CopyWithPlaceholder(),
  }) {
    return MangaDexChapterWithFiltersQueryFilter(
      limit: limit == const $CopyWithPlaceholder() || limit == null
          ? _value.limit
          // ignore: cast_nullable_to_non_nullable
          : limit as int,
      offset: offset == const $CopyWithPlaceholder() || offset == null
          ? _value.offset
          // ignore: cast_nullable_to_non_nullable
          : offset as int,
      orderByChapterDesc: orderByChapterDesc == const $CopyWithPlaceholder() ||
              orderByChapterDesc == null
          ? _value.orderByChapterDesc
          // ignore: cast_nullable_to_non_nullable
          : orderByChapterDesc as bool,
      ids: ids == const $CopyWithPlaceholder()
          ? _value.ids
          // ignore: cast_nullable_to_non_nullable
          : ids as List<String>?,
      translatedLanguages: translatedLanguages == const $CopyWithPlaceholder()
          ? _value.translatedLanguages
          // ignore: cast_nullable_to_non_nullable
          : translatedLanguages as List<Language>?,
      excludedGroups: excludedGroups == const $CopyWithPlaceholder()
          ? _value.excludedGroups
          // ignore: cast_nullable_to_non_nullable
          : excludedGroups as List<String>?,
      contentRatings: contentRatings == const $CopyWithPlaceholder()
          ? _value.contentRatings
          // ignore: cast_nullable_to_non_nullable
          : contentRatings as List<ContentRating>?,
    );
  }
}

extension $MangaDexChapterWithFiltersQueryFilterCopyWith
    on MangaDexChapterWithFiltersQueryFilter {
  /// Returns a callable class that can be used as follows: `instanceOfMangaDexChapterWithFiltersQueryFilter.copyWith(...)` or like so:`instanceOfMangaDexChapterWithFiltersQueryFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaDexChapterWithFiltersQueryFilterCWProxy get copyWith =>
      _$MangaDexChapterWithFiltersQueryFilterCWProxyImpl(this);
}
