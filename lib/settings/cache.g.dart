// GENERATED CODE - DO NOT MODIFY BY HAND

part of "cache.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCoverCacheSettingsCollection on Isar {
  IsarCollection<CoverCacheSettings> get coverCacheSettings =>
      this.collection();
}

const CoverCacheSettingsSchema = CollectionSchema(
  name: r"CoverCacheSettings",
  id: -6349337884832606692,
  properties: {
    r"enabled": PropertySchema(
      id: 0,
      name: r"enabled",
      type: IsarType.bool,
    ),
    r"fullSize": PropertySchema(
      id: 1,
      name: r"fullSize",
      type: IsarType.byte,
      enumMap: _CoverCacheSettingsfullSizeEnumValueMap,
    ),
    r"key": PropertySchema(
      id: 2,
      name: r"key",
      type: IsarType.string,
    ),
    r"previewSize": PropertySchema(
      id: 3,
      name: r"previewSize",
      type: IsarType.byte,
      enumMap: _CoverCacheSettingspreviewSizeEnumValueMap,
    )
  },
  estimateSize: _coverCacheSettingsEstimateSize,
  serialize: _coverCacheSettingsSerialize,
  deserialize: _coverCacheSettingsDeserialize,
  deserializeProp: _coverCacheSettingsDeserializeProp,
  idName: r"id",
  indexes: {
    r"key": IndexSchema(
      id: -4906094122524121629,
      name: r"key",
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r"key",
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _coverCacheSettingsGetId,
  getLinks: _coverCacheSettingsGetLinks,
  attach: _coverCacheSettingsAttach,
  version: "3.0.5",
);

int _coverCacheSettingsEstimateSize(
  CoverCacheSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _coverCacheSettingsSerialize(
  CoverCacheSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.enabled);
  writer.writeByte(offsets[1], object.fullSize.index);
  writer.writeString(offsets[2], object.key);
  writer.writeByte(offsets[3], object.previewSize.index);
}

CoverCacheSettings _coverCacheSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CoverCacheSettings(
    enabled: reader.readBool(offsets[0]),
    fullSize: _CoverCacheSettingsfullSizeValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        CoverSize.original,
    previewSize: _CoverCacheSettingspreviewSizeValueEnumMap[
            reader.readByteOrNull(offsets[3])] ??
        CoverSize.original,
  );
  return object;
}

P _coverCacheSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (_CoverCacheSettingsfullSizeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CoverSize.original) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_CoverCacheSettingspreviewSizeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CoverSize.original) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _CoverCacheSettingsfullSizeEnumValueMap = {
  "original": 0,
  "medium": 1,
  "small": 2,
};
const _CoverCacheSettingsfullSizeValueEnumMap = {
  0: CoverSize.original,
  1: CoverSize.medium,
  2: CoverSize.small,
};
const _CoverCacheSettingspreviewSizeEnumValueMap = {
  "original": 0,
  "medium": 1,
  "small": 2,
};
const _CoverCacheSettingspreviewSizeValueEnumMap = {
  0: CoverSize.original,
  1: CoverSize.medium,
  2: CoverSize.small,
};

Id _coverCacheSettingsGetId(CoverCacheSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _coverCacheSettingsGetLinks(
    CoverCacheSettings object) {
  return [];
}

void _coverCacheSettingsAttach(
    IsarCollection<dynamic> col, Id id, CoverCacheSettings object) {}

extension CoverCacheSettingsByIndex on IsarCollection<CoverCacheSettings> {
  Future<CoverCacheSettings?> getByKey(String key) {
    return getByIndex(r"key", [key]);
  }

  CoverCacheSettings? getByKeySync(String key) {
    return getByIndexSync(r"key", [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r"key", [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r"key", [key]);
  }

  Future<List<CoverCacheSettings?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r"key", values);
  }

  List<CoverCacheSettings?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r"key", values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r"key", values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r"key", values);
  }

  Future<Id> putByKey(CoverCacheSettings object) {
    return putByIndex(r"key", object);
  }

  Id putByKeySync(CoverCacheSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r"key", object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<CoverCacheSettings> objects) {
    return putAllByIndex(r"key", objects);
  }

  List<Id> putAllByKeySync(List<CoverCacheSettings> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r"key", objects, saveLinks: saveLinks);
  }
}

extension CoverCacheSettingsQueryWhereSort
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QWhere> {
  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CoverCacheSettingsQueryWhere
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QWhereClause> {
  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterWhereClause>
      keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"key",
        value: [key],
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterWhereClause>
      keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"key",
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"key",
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"key",
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"key",
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CoverCacheSettingsQueryFilter
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QFilterCondition> {
  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"enabled",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      fullSizeEqualTo(CoverSize value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fullSize",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      fullSizeGreaterThan(
    CoverSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"fullSize",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      fullSizeLessThan(
    CoverSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"fullSize",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      fullSizeBetween(
    CoverSize lower,
    CoverSize upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"fullSize",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"id",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"key",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"key",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      previewSizeEqualTo(CoverSize value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"previewSize",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      previewSizeGreaterThan(
    CoverSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"previewSize",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      previewSizeLessThan(
    CoverSize value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"previewSize",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterFilterCondition>
      previewSizeBetween(
    CoverSize lower,
    CoverSize upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"previewSize",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CoverCacheSettingsQueryObject
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QFilterCondition> {}

extension CoverCacheSettingsQueryLinks
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QFilterCondition> {}

extension CoverCacheSettingsQuerySortBy
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QSortBy> {
  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.desc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      sortByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fullSize", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      sortByFullSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fullSize", Sort.desc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      sortByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"previewSize", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      sortByPreviewSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"previewSize", Sort.desc);
    });
  }
}

extension CoverCacheSettingsQuerySortThenBy
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QSortThenBy> {
  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.desc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fullSize", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByFullSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fullSize", Sort.desc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"previewSize", Sort.asc);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QAfterSortBy>
      thenByPreviewSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"previewSize", Sort.desc);
    });
  }
}

extension CoverCacheSettingsQueryWhereDistinct
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QDistinct> {
  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QDistinct>
      distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"enabled");
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QDistinct>
      distinctByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"fullSize");
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"key", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoverCacheSettings, CoverCacheSettings, QDistinct>
      distinctByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"previewSize");
    });
  }
}

extension CoverCacheSettingsQueryProperty
    on QueryBuilder<CoverCacheSettings, CoverCacheSettings, QQueryProperty> {
  QueryBuilder<CoverCacheSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<CoverCacheSettings, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"enabled");
    });
  }

  QueryBuilder<CoverCacheSettings, CoverSize, QQueryOperations>
      fullSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"fullSize");
    });
  }

  QueryBuilder<CoverCacheSettings, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"key");
    });
  }

  QueryBuilder<CoverCacheSettings, CoverSize, QQueryOperations>
      previewSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"previewSize");
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetChapterCacheSettingsCollection on Isar {
  IsarCollection<ChapterCacheSettings> get chapterCacheSettings =>
      this.collection();
}

const ChapterCacheSettingsSchema = CollectionSchema(
  name: r"ChapterCacheSettings",
  id: -1596114072565871281,
  properties: {
    r"enabled": PropertySchema(
      id: 0,
      name: r"enabled",
      type: IsarType.bool,
    ),
    r"key": PropertySchema(
      id: 1,
      name: r"key",
      type: IsarType.string,
    )
  },
  estimateSize: _chapterCacheSettingsEstimateSize,
  serialize: _chapterCacheSettingsSerialize,
  deserialize: _chapterCacheSettingsDeserialize,
  deserializeProp: _chapterCacheSettingsDeserializeProp,
  idName: r"id",
  indexes: {
    r"key": IndexSchema(
      id: -4906094122524121629,
      name: r"key",
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r"key",
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _chapterCacheSettingsGetId,
  getLinks: _chapterCacheSettingsGetLinks,
  attach: _chapterCacheSettingsAttach,
  version: "3.0.5",
);

int _chapterCacheSettingsEstimateSize(
  ChapterCacheSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _chapterCacheSettingsSerialize(
  ChapterCacheSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.enabled);
  writer.writeString(offsets[1], object.key);
}

ChapterCacheSettings _chapterCacheSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterCacheSettings(
    enabled: reader.readBool(offsets[0]),
  );
  return object;
}

P _chapterCacheSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

Id _chapterCacheSettingsGetId(ChapterCacheSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _chapterCacheSettingsGetLinks(
    ChapterCacheSettings object) {
  return [];
}

void _chapterCacheSettingsAttach(
    IsarCollection<dynamic> col, Id id, ChapterCacheSettings object) {}

extension ChapterCacheSettingsByIndex on IsarCollection<ChapterCacheSettings> {
  Future<ChapterCacheSettings?> getByKey(String key) {
    return getByIndex(r"key", [key]);
  }

  ChapterCacheSettings? getByKeySync(String key) {
    return getByIndexSync(r"key", [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r"key", [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r"key", [key]);
  }

  Future<List<ChapterCacheSettings?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r"key", values);
  }

  List<ChapterCacheSettings?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r"key", values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r"key", values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r"key", values);
  }

  Future<Id> putByKey(ChapterCacheSettings object) {
    return putByIndex(r"key", object);
  }

  Id putByKeySync(ChapterCacheSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r"key", object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<ChapterCacheSettings> objects) {
    return putAllByIndex(r"key", objects);
  }

  List<Id> putAllByKeySync(List<ChapterCacheSettings> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r"key", objects, saveLinks: saveLinks);
  }
}

extension ChapterCacheSettingsQueryWhereSort
    on QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QWhere> {
  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChapterCacheSettingsQueryWhere
    on QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QWhereClause> {
  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterWhereClause>
      keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"key",
        value: [key],
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterWhereClause>
      keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"key",
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"key",
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"key",
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"key",
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ChapterCacheSettingsQueryFilter on QueryBuilder<ChapterCacheSettings,
    ChapterCacheSettings, QFilterCondition> {
  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"enabled",
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"id",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"key",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
          QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
          QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"key",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings,
      QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"key",
        value: "",
      ));
    });
  }
}

extension ChapterCacheSettingsQueryObject on QueryBuilder<ChapterCacheSettings,
    ChapterCacheSettings, QFilterCondition> {}

extension ChapterCacheSettingsQueryLinks on QueryBuilder<ChapterCacheSettings,
    ChapterCacheSettings, QFilterCondition> {}

extension ChapterCacheSettingsQuerySortBy
    on QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QSortBy> {
  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.asc);
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.desc);
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }
}

extension ChapterCacheSettingsQuerySortThenBy
    on QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QSortThenBy> {
  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.asc);
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.desc);
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }
}

extension ChapterCacheSettingsQueryWhereDistinct
    on QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QDistinct> {
  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QDistinct>
      distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"enabled");
    });
  }

  QueryBuilder<ChapterCacheSettings, ChapterCacheSettings, QDistinct>
      distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"key", caseSensitive: caseSensitive);
    });
  }
}

extension ChapterCacheSettingsQueryProperty on QueryBuilder<
    ChapterCacheSettings, ChapterCacheSettings, QQueryProperty> {
  QueryBuilder<ChapterCacheSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<ChapterCacheSettings, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"enabled");
    });
  }

  QueryBuilder<ChapterCacheSettings, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"key");
    });
  }
}
