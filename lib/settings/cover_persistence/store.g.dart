// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CoverPersistenceSettingsStoreCWProxy {
  CoverPersistenceSettingsStore enabled(bool enabled);

  CoverPersistenceSettingsStore previewSize(CoverSize previewSize);

  CoverPersistenceSettingsStore fullSize(CoverSize fullSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CoverPersistenceSettingsStore(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CoverPersistenceSettingsStore(...).copyWith(id: 12, name: "My name")
  /// ````
  CoverPersistenceSettingsStore call({
    bool? enabled,
    CoverSize? previewSize,
    CoverSize? fullSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCoverPersistenceSettingsStore.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCoverPersistenceSettingsStore.copyWith.fieldName(...)`
class _$CoverPersistenceSettingsStoreCWProxyImpl
    implements _$CoverPersistenceSettingsStoreCWProxy {
  const _$CoverPersistenceSettingsStoreCWProxyImpl(this._value);

  final CoverPersistenceSettingsStore _value;

  @override
  CoverPersistenceSettingsStore enabled(bool enabled) => this(enabled: enabled);

  @override
  CoverPersistenceSettingsStore previewSize(CoverSize previewSize) =>
      this(previewSize: previewSize);

  @override
  CoverPersistenceSettingsStore fullSize(CoverSize fullSize) =>
      this(fullSize: fullSize);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CoverPersistenceSettingsStore(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CoverPersistenceSettingsStore(...).copyWith(id: 12, name: "My name")
  /// ````
  CoverPersistenceSettingsStore call({
    Object? enabled = const $CopyWithPlaceholder(),
    Object? previewSize = const $CopyWithPlaceholder(),
    Object? fullSize = const $CopyWithPlaceholder(),
  }) {
    return CoverPersistenceSettingsStore(
      enabled: enabled == const $CopyWithPlaceholder() || enabled == null
          ? _value.enabled
          // ignore: cast_nullable_to_non_nullable
          : enabled as bool,
      previewSize:
          previewSize == const $CopyWithPlaceholder() || previewSize == null
              ? _value.previewSize
              // ignore: cast_nullable_to_non_nullable
              : previewSize as CoverSize,
      fullSize: fullSize == const $CopyWithPlaceholder() || fullSize == null
          ? _value.fullSize
          // ignore: cast_nullable_to_non_nullable
          : fullSize as CoverSize,
    );
  }
}

extension $CoverPersistenceSettingsStoreCopyWith
    on CoverPersistenceSettingsStore {
  /// Returns a callable class that can be used as follows: `instanceOfCoverPersistenceSettingsStore.copyWith(...)` or like so:`instanceOfCoverPersistenceSettingsStore.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CoverPersistenceSettingsStoreCWProxy get copyWith =>
      _$CoverPersistenceSettingsStoreCWProxyImpl(this);
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCoverPersistenceSettingsStoreCollection on Isar {
  IsarCollection<CoverPersistenceSettingsStore> get coverPersistenceSettings =>
      this.collection();
}

const CoverPersistenceSettingsStoreSchema = CollectionSchema(
  name: r'CoverPersistenceSettingsStore',
  id: 4222908783201711202,
  properties: {
    r'enabled': PropertySchema(
      id: 0,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'fullSize': PropertySchema(
      id: 1,
      name: r'fullSize',
      type: IsarType.byte,
      enumMap: _CoverPersistenceSettingsStorefullSizeEnumValueMap,
    ),
    r'previewSize': PropertySchema(
      id: 2,
      name: r'previewSize',
      type: IsarType.byte,
      enumMap: _CoverPersistenceSettingsStorepreviewSizeEnumValueMap,
    )
  },
  estimateSize: _coverPersistenceSettingsStoreEstimateSize,
  serialize: _coverPersistenceSettingsStoreSerialize,
  deserialize: _coverPersistenceSettingsStoreDeserialize,
  deserializeProp: _coverPersistenceSettingsStoreDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _coverPersistenceSettingsStoreGetId,
  getLinks: _coverPersistenceSettingsStoreGetLinks,
  attach: _coverPersistenceSettingsStoreAttach,
  version: '3.1.0+1',
);

int _coverPersistenceSettingsStoreEstimateSize(
  CoverPersistenceSettingsStore object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _coverPersistenceSettingsStoreSerialize(
  CoverPersistenceSettingsStore object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.enabled);
  writer.writeByte(offsets[1], object.fullSize.index);
  writer.writeByte(offsets[2], object.previewSize.index);
}

CoverPersistenceSettingsStore _coverPersistenceSettingsStoreDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CoverPersistenceSettingsStore(
    enabled: reader.readBool(offsets[0]),
    fullSize: _CoverPersistenceSettingsStorefullSizeValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        CoverSize.original,
    previewSize: _CoverPersistenceSettingsStorepreviewSizeValueEnumMap[
            reader.readByteOrNull(offsets[2])] ??
        CoverSize.original,
  );
  return object;
}

P _coverPersistenceSettingsStoreDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (_CoverPersistenceSettingsStorefullSizeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CoverSize.original) as P;
    case 2:
      return (_CoverPersistenceSettingsStorepreviewSizeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CoverSize.original) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CoverPersistenceSettingsStorefullSizeEnumValueMap = {
  'original': 0,
  'medium': 1,
  'small': 2,
};
const _CoverPersistenceSettingsStorefullSizeValueEnumMap = {
  0: CoverSize.original,
  1: CoverSize.medium,
  2: CoverSize.small,
};
const _CoverPersistenceSettingsStorepreviewSizeEnumValueMap = {
  'original': 0,
  'medium': 1,
  'small': 2,
};
const _CoverPersistenceSettingsStorepreviewSizeValueEnumMap = {
  0: CoverSize.original,
  1: CoverSize.medium,
  2: CoverSize.small,
};

Id _coverPersistenceSettingsStoreGetId(CoverPersistenceSettingsStore object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _coverPersistenceSettingsStoreGetLinks(
    CoverPersistenceSettingsStore object) {
  return [];
}

void _coverPersistenceSettingsStoreAttach(
    IsarCollection<dynamic> col, Id id, CoverPersistenceSettingsStore object) {}

extension CoverPersistenceSettingsStoreQueryWhereSort on QueryBuilder<
    CoverPersistenceSettingsStore, CoverPersistenceSettingsStore, QWhere> {
  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CoverPersistenceSettingsStoreQueryWhere on QueryBuilder<
    CoverPersistenceSettingsStore,
    CoverPersistenceSettingsStore,
    QWhereClause> {
  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CoverPersistenceSettingsStoreQueryFilter on QueryBuilder<
    CoverPersistenceSettingsStore,
    CoverPersistenceSettingsStore,
    QFilterCondition> {
  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> fullSizeEqualTo(CoverSize value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullSize',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> fullSizeGreaterThan(
    CoverSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullSize',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> fullSizeLessThan(
    CoverSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullSize',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> fullSizeBetween(
    CoverSize lower,
    CoverSize upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> previewSizeEqualTo(CoverSize value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previewSize',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> previewSizeGreaterThan(
    CoverSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previewSize',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> previewSizeLessThan(
    CoverSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previewSize',
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterFilterCondition> previewSizeBetween(
    CoverSize lower,
    CoverSize upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previewSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CoverPersistenceSettingsStoreQueryObject on QueryBuilder<
    CoverPersistenceSettingsStore,
    CoverPersistenceSettingsStore,
    QFilterCondition> {}

extension CoverPersistenceSettingsStoreQueryLinks on QueryBuilder<
    CoverPersistenceSettingsStore,
    CoverPersistenceSettingsStore,
    QFilterCondition> {}

extension CoverPersistenceSettingsStoreQuerySortBy on QueryBuilder<
    CoverPersistenceSettingsStore, CoverPersistenceSettingsStore, QSortBy> {
  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> sortByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullSize', Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> sortByFullSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullSize', Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> sortByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewSize', Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> sortByPreviewSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewSize', Sort.desc);
    });
  }
}

extension CoverPersistenceSettingsStoreQuerySortThenBy on QueryBuilder<
    CoverPersistenceSettingsStore, CoverPersistenceSettingsStore, QSortThenBy> {
  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> thenByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullSize', Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> thenByFullSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullSize', Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> thenByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewSize', Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QAfterSortBy> thenByPreviewSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewSize', Sort.desc);
    });
  }
}

extension CoverPersistenceSettingsStoreQueryWhereDistinct on QueryBuilder<
    CoverPersistenceSettingsStore, CoverPersistenceSettingsStore, QDistinct> {
  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QDistinct> distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QDistinct> distinctByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullSize');
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverPersistenceSettingsStore,
      QDistinct> distinctByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previewSize');
    });
  }
}

extension CoverPersistenceSettingsStoreQueryProperty on QueryBuilder<
    CoverPersistenceSettingsStore,
    CoverPersistenceSettingsStore,
    QQueryProperty> {
  QueryBuilder<CoverPersistenceSettingsStore, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, bool, QQueryOperations>
      enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverSize, QQueryOperations>
      fullSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullSize');
    });
  }

  QueryBuilder<CoverPersistenceSettingsStore, CoverSize, QQueryOperations>
      previewSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previewSize');
    });
  }
}
