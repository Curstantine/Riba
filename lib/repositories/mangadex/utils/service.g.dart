// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MangaDexGenericQueryFilterCWProxy {
  MangaDexGenericQueryFilter includes(List<EntityType>? includes);

  MangaDexGenericQueryFilter limit(int? limit);

  MangaDexGenericQueryFilter offset(int? offset);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexGenericQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexGenericQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexGenericQueryFilter call({
    List<EntityType>? includes,
    int? limit,
    int? offset,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaDexGenericQueryFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaDexGenericQueryFilter.copyWith.fieldName(...)`
class _$MangaDexGenericQueryFilterCWProxyImpl
    implements _$MangaDexGenericQueryFilterCWProxy {
  const _$MangaDexGenericQueryFilterCWProxyImpl(this._value);

  final MangaDexGenericQueryFilter _value;

  @override
  MangaDexGenericQueryFilter includes(List<EntityType>? includes) =>
      this(includes: includes);

  @override
  MangaDexGenericQueryFilter limit(int? limit) => this(limit: limit);

  @override
  MangaDexGenericQueryFilter offset(int? offset) => this(offset: offset);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexGenericQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexGenericQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexGenericQueryFilter call({
    Object? includes = const $CopyWithPlaceholder(),
    Object? limit = const $CopyWithPlaceholder(),
    Object? offset = const $CopyWithPlaceholder(),
  }) {
    return MangaDexGenericQueryFilter(
      includes: includes == const $CopyWithPlaceholder()
          ? _value.includes
          // ignore: cast_nullable_to_non_nullable
          : includes as List<EntityType>?,
      limit: limit == const $CopyWithPlaceholder()
          ? _value.limit
          // ignore: cast_nullable_to_non_nullable
          : limit as int?,
      offset: offset == const $CopyWithPlaceholder()
          ? _value.offset
          // ignore: cast_nullable_to_non_nullable
          : offset as int?,
    );
  }
}

extension $MangaDexGenericQueryFilterCopyWith on MangaDexGenericQueryFilter {
  /// Returns a callable class that can be used as follows: `instanceOfMangaDexGenericQueryFilter.copyWith(...)` or like so:`instanceOfMangaDexGenericQueryFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaDexGenericQueryFilterCWProxy get copyWith =>
      _$MangaDexGenericQueryFilterCWProxyImpl(this);
}
