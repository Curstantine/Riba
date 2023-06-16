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
