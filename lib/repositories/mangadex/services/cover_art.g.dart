// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_art.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MangaDexCoverGetManyQueryFilterCWProxy {
  MangaDexCoverGetManyQueryFilter ids(List<String> ids);

  MangaDexCoverGetManyQueryFilter locales(List<Locale>? locales);

  MangaDexCoverGetManyQueryFilter orderByVolumeDesc(bool orderByVolumeDesc);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexCoverGetManyQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexCoverGetManyQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexCoverGetManyQueryFilter call({
    List<String>? ids,
    List<Locale>? locales,
    bool? orderByVolumeDesc,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaDexCoverGetManyQueryFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaDexCoverGetManyQueryFilter.copyWith.fieldName(...)`
class _$MangaDexCoverGetManyQueryFilterCWProxyImpl
    implements _$MangaDexCoverGetManyQueryFilterCWProxy {
  const _$MangaDexCoverGetManyQueryFilterCWProxyImpl(this._value);

  final MangaDexCoverGetManyQueryFilter _value;

  @override
  MangaDexCoverGetManyQueryFilter ids(List<String> ids) => this(ids: ids);

  @override
  MangaDexCoverGetManyQueryFilter locales(List<Locale>? locales) =>
      this(locales: locales);

  @override
  MangaDexCoverGetManyQueryFilter orderByVolumeDesc(bool orderByVolumeDesc) =>
      this(orderByVolumeDesc: orderByVolumeDesc);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaDexCoverGetManyQueryFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaDexCoverGetManyQueryFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaDexCoverGetManyQueryFilter call({
    Object? ids = const $CopyWithPlaceholder(),
    Object? locales = const $CopyWithPlaceholder(),
    Object? orderByVolumeDesc = const $CopyWithPlaceholder(),
  }) {
    return MangaDexCoverGetManyQueryFilter(
      ids: ids == const $CopyWithPlaceholder() || ids == null
          ? _value.ids
          // ignore: cast_nullable_to_non_nullable
          : ids as List<String>,
      locales: locales == const $CopyWithPlaceholder()
          ? _value.locales
          // ignore: cast_nullable_to_non_nullable
          : locales as List<Locale>?,
      orderByVolumeDesc: orderByVolumeDesc == const $CopyWithPlaceholder() ||
              orderByVolumeDesc == null
          ? _value.orderByVolumeDesc
          // ignore: cast_nullable_to_non_nullable
          : orderByVolumeDesc as bool,
    );
  }
}

extension $MangaDexCoverGetManyQueryFilterCopyWith
    on MangaDexCoverGetManyQueryFilter {
  /// Returns a callable class that can be used as follows: `instanceOfMangaDexCoverGetManyQueryFilter.copyWith(...)` or like so:`instanceOfMangaDexCoverGetManyQueryFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaDexCoverGetManyQueryFilterCWProxy get copyWith =>
      _$MangaDexCoverGetManyQueryFilterCWProxyImpl(this);
}
