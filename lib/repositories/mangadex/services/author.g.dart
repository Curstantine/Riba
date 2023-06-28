// GENERATED CODE - DO NOT MODIFY BY HAND

part of "author.dart";

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MangaDexAuthorWithFilterQueryFilterCWProxy {
  MangaDexAuthorWithFilterQueryFilter limit(int limit);

  MangaDexAuthorWithFilterQueryFilter offset(int offset);

  MangaDexAuthorWithFilterQueryFilter name(String? name);

  MangaDexAuthorWithFilterQueryFilter orderByNameDesc(bool orderByNameDesc);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexAuthorWithFilterQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexAuthorWithFilterQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexAuthorWithFilterQueryFilter call({
    int? limit,
    int? offset,
    String? name,
    bool? orderByNameDesc,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaDexAuthorWithFilterQueryFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaDexAuthorWithFilterQueryFilter.copyWith.fieldName(...)`
class _$MangaDexAuthorWithFilterQueryFilterCWProxyImpl
    implements _$MangaDexAuthorWithFilterQueryFilterCWProxy {
  const _$MangaDexAuthorWithFilterQueryFilterCWProxyImpl(this._value);

  final MangaDexAuthorWithFilterQueryFilter _value;

  @override
  MangaDexAuthorWithFilterQueryFilter limit(int limit) => this(limit: limit);

  @override
  MangaDexAuthorWithFilterQueryFilter offset(int offset) =>
      this(offset: offset);

  @override
  MangaDexAuthorWithFilterQueryFilter name(String? name) => this(name: name);

  @override
  MangaDexAuthorWithFilterQueryFilter orderByNameDesc(bool orderByNameDesc) =>
      this(orderByNameDesc: orderByNameDesc);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexAuthorWithFilterQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexAuthorWithFilterQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexAuthorWithFilterQueryFilter call({
    Object? limit = const $CopyWithPlaceholder(),
    Object? offset = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? orderByNameDesc = const $CopyWithPlaceholder(),
  }) {
    return MangaDexAuthorWithFilterQueryFilter(
      limit: limit == const $CopyWithPlaceholder() || limit == null
          ? _value.limit
          // ignore: cast_nullable_to_non_nullable
          : limit as int,
      offset: offset == const $CopyWithPlaceholder() || offset == null
          ? _value.offset
          // ignore: cast_nullable_to_non_nullable
          : offset as int,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      orderByNameDesc: orderByNameDesc == const $CopyWithPlaceholder() ||
              orderByNameDesc == null
          ? _value.orderByNameDesc
          // ignore: cast_nullable_to_non_nullable
          : orderByNameDesc as bool,
    );
  }
}

extension $MangaDexAuthorWithFilterQueryFilterCopyWith
    on MangaDexAuthorWithFilterQueryFilter {
  /// Returns a callable class that can be used as follows: `instanceOfMangaDexAuthorWithFilterQueryFilter.copyWith(...)` or like so:`instanceOfMangaDexAuthorWithFilterQueryFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaDexAuthorWithFilterQueryFilterCWProxy get copyWith =>
      _$MangaDexAuthorWithFilterQueryFilterCWProxyImpl(this);
}
