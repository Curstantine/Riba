// GENERATED CODE - DO NOT MODIFY BY HAND

part of "group.dart";

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MangaDexGroupGetManyAsSingleQueryFilterCWProxy {
  MangaDexGroupGetManyAsSingleQueryFilter ids(List<String> ids);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexGroupGetManyAsSingleQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexGroupGetManyAsSingleQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexGroupGetManyAsSingleQueryFilter call({
    List<String>? ids,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaDexGroupGetManyAsSingleQueryFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaDexGroupGetManyAsSingleQueryFilter.copyWith.fieldName(...)`
class _$MangaDexGroupGetManyAsSingleQueryFilterCWProxyImpl
    implements _$MangaDexGroupGetManyAsSingleQueryFilterCWProxy {
  const _$MangaDexGroupGetManyAsSingleQueryFilterCWProxyImpl(this._value);

  final MangaDexGroupGetManyAsSingleQueryFilter _value;

  @override
  MangaDexGroupGetManyAsSingleQueryFilter ids(List<String> ids) =>
      this(ids: ids);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexGroupGetManyAsSingleQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexGroupGetManyAsSingleQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexGroupGetManyAsSingleQueryFilter call({
    Object? ids = const $CopyWithPlaceholder(),
  }) {
    return MangaDexGroupGetManyAsSingleQueryFilter(
      ids: ids == const $CopyWithPlaceholder() || ids == null
          ? _value.ids
          // ignore: cast_nullable_to_non_nullable
          : ids as List<String>,
    );
  }
}

extension $MangaDexGroupGetManyAsSingleQueryFilterCopyWith
    on MangaDexGroupGetManyAsSingleQueryFilter {
  /// Returns a callable class that can be used as follows: `instanceOfMangaDexGroupGetManyAsSingleQueryFilter.copyWith(...)` or like so:`instanceOfMangaDexGroupGetManyAsSingleQueryFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaDexGroupGetManyAsSingleQueryFilterCWProxy get copyWith =>
      _$MangaDexGroupGetManyAsSingleQueryFilterCWProxyImpl(this);
}

abstract class _$MangaDexGroupWithFilterQueryFilterCWProxy {
  MangaDexGroupWithFilterQueryFilter limit(int limit);

  MangaDexGroupWithFilterQueryFilter offset(int offset);

  MangaDexGroupWithFilterQueryFilter name(String? name);

  MangaDexGroupWithFilterQueryFilter orderByFollowedCountDesc(
      bool orderByFollowedCountDesc);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexGroupWithFilterQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexGroupWithFilterQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexGroupWithFilterQueryFilter call({
    int? limit,
    int? offset,
    String? name,
    bool? orderByFollowedCountDesc,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaDexGroupWithFilterQueryFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaDexGroupWithFilterQueryFilter.copyWith.fieldName(...)`
class _$MangaDexGroupWithFilterQueryFilterCWProxyImpl
    implements _$MangaDexGroupWithFilterQueryFilterCWProxy {
  const _$MangaDexGroupWithFilterQueryFilterCWProxyImpl(this._value);

  final MangaDexGroupWithFilterQueryFilter _value;

  @override
  MangaDexGroupWithFilterQueryFilter limit(int limit) => this(limit: limit);

  @override
  MangaDexGroupWithFilterQueryFilter offset(int offset) => this(offset: offset);

  @override
  MangaDexGroupWithFilterQueryFilter name(String? name) => this(name: name);

  @override
  MangaDexGroupWithFilterQueryFilter orderByFollowedCountDesc(
          bool orderByFollowedCountDesc) =>
      this(orderByFollowedCountDesc: orderByFollowedCountDesc);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexGroupWithFilterQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexGroupWithFilterQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexGroupWithFilterQueryFilter call({
    Object? limit = const $CopyWithPlaceholder(),
    Object? offset = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? orderByFollowedCountDesc = const $CopyWithPlaceholder(),
  }) {
    return MangaDexGroupWithFilterQueryFilter(
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
      orderByFollowedCountDesc:
          orderByFollowedCountDesc == const $CopyWithPlaceholder() ||
                  orderByFollowedCountDesc == null
              ? _value.orderByFollowedCountDesc
              // ignore: cast_nullable_to_non_nullable
              : orderByFollowedCountDesc as bool,
    );
  }
}

extension $MangaDexGroupWithFilterQueryFilterCopyWith
    on MangaDexGroupWithFilterQueryFilter {
  /// Returns a callable class that can be used as follows: `instanceOfMangaDexGroupWithFilterQueryFilter.copyWith(...)` or like so:`instanceOfMangaDexGroupWithFilterQueryFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaDexGroupWithFilterQueryFilterCWProxy get copyWith =>
      _$MangaDexGroupWithFilterQueryFilterCWProxyImpl(this);
}
