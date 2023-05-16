// GENERATED CODE - DO NOT MODIFY BY HAND

part of "persistence.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCoverPersistenceSettingsCollection on Isar {
  IsarCollection<CoverPersistenceSettings> get coverPersistenceSettings =>
      this.collection();
}

const CoverPersistenceSettingsSchema = CollectionSchema(
  name: r"CoverPersistenceSettings",
  id: 6080208517071918044,
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
      enumMap: _CoverPersistenceSettingsfullSizeEnumValueMap,
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
      enumMap: _CoverPersistenceSettingspreviewSizeEnumValueMap,
    )
  },
  estimateSize: _coverPersistenceSettingsEstimateSize,
  serialize: _coverPersistenceSettingsSerialize,
  deserialize: _coverPersistenceSettingsDeserialize,
  deserializeProp: _coverPersistenceSettingsDeserializeProp,
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
  getId: _coverPersistenceSettingsGetId,
  getLinks: _coverPersistenceSettingsGetLinks,
  attach: _coverPersistenceSettingsAttach,
  version: "3.1.0+1",
);

int _coverPersistenceSettingsEstimateSize(
  CoverPersistenceSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _coverPersistenceSettingsSerialize(
  CoverPersistenceSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.enabled);
  writer.writeByte(offsets[1], object.fullSize.index);
  writer.writeString(offsets[2], object.key);
  writer.writeByte(offsets[3], object.previewSize.index);
}

CoverPersistenceSettings _coverPersistenceSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CoverPersistenceSettings(
    enabled: reader.readBool(offsets[0]),
    fullSize: _CoverPersistenceSettingsfullSizeValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        CoverSize.original,
    previewSize: _CoverPersistenceSettingspreviewSizeValueEnumMap[
            reader.readByteOrNull(offsets[3])] ??
        CoverSize.original,
  );
  return object;
}

P _coverPersistenceSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (_CoverPersistenceSettingsfullSizeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CoverSize.original) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_CoverPersistenceSettingspreviewSizeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CoverSize.original) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _CoverPersistenceSettingsfullSizeEnumValueMap = {
  "original": 0,
  "medium": 1,
  "small": 2,
};
const _CoverPersistenceSettingsfullSizeValueEnumMap = {
  0: CoverSize.original,
  1: CoverSize.medium,
  2: CoverSize.small,
};
const _CoverPersistenceSettingspreviewSizeEnumValueMap = {
  "original": 0,
  "medium": 1,
  "small": 2,
};
const _CoverPersistenceSettingspreviewSizeValueEnumMap = {
  0: CoverSize.original,
  1: CoverSize.medium,
  2: CoverSize.small,
};

Id _coverPersistenceSettingsGetId(CoverPersistenceSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _coverPersistenceSettingsGetLinks(
    CoverPersistenceSettings object) {
  return [];
}

void _coverPersistenceSettingsAttach(
    IsarCollection<dynamic> col, Id id, CoverPersistenceSettings object) {}

extension CoverPersistenceSettingsByIndex
    on IsarCollection<CoverPersistenceSettings> {
  Future<CoverPersistenceSettings?> getByKey(String key) {
    return getByIndex(r"key", [key]);
  }

  CoverPersistenceSettings? getByKeySync(String key) {
    return getByIndexSync(r"key", [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r"key", [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r"key", [key]);
  }

  Future<List<CoverPersistenceSettings?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r"key", values);
  }

  List<CoverPersistenceSettings?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(CoverPersistenceSettings object) {
    return putByIndex(r"key", object);
  }

  Id putByKeySync(CoverPersistenceSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r"key", object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<CoverPersistenceSettings> objects) {
    return putAllByIndex(r"key", objects);
  }

  List<Id> putAllByKeySync(List<CoverPersistenceSettings> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r"key", objects, saveLinks: saveLinks);
  }
}

extension CoverPersistenceSettingsQueryWhereSort on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QWhere> {
  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CoverPersistenceSettingsQueryWhere on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QWhereClause> {
  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterWhereClause> keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"key",
        value: [key],
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterWhereClause> keyNotEqualTo(String key) {
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

extension CoverPersistenceSettingsQueryFilter on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QFilterCondition> {
  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"enabled",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> fullSizeEqualTo(CoverSize value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fullSize",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> fullSizeGreaterThan(
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> fullSizeLessThan(
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> fullSizeBetween(
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> previewSizeEqualTo(CoverSize value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"previewSize",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> previewSizeGreaterThan(
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> previewSizeLessThan(
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

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings,
      QAfterFilterCondition> previewSizeBetween(
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

extension CoverPersistenceSettingsQueryObject on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QFilterCondition> {}

extension CoverPersistenceSettingsQueryLinks on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QFilterCondition> {}

extension CoverPersistenceSettingsQuerySortBy on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QSortBy> {
  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      sortByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fullSize", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      sortByFullSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fullSize", Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      sortByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"previewSize", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      sortByPreviewSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"previewSize", Sort.desc);
    });
  }
}

extension CoverPersistenceSettingsQuerySortThenBy on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QSortThenBy> {
  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fullSize", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByFullSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fullSize", Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"previewSize", Sort.asc);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QAfterSortBy>
      thenByPreviewSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"previewSize", Sort.desc);
    });
  }
}

extension CoverPersistenceSettingsQueryWhereDistinct on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QDistinct> {
  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QDistinct>
      distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"enabled");
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QDistinct>
      distinctByFullSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"fullSize");
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QDistinct>
      distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"key", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverPersistenceSettings, QDistinct>
      distinctByPreviewSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"previewSize");
    });
  }
}

extension CoverPersistenceSettingsQueryProperty on QueryBuilder<
    CoverPersistenceSettings, CoverPersistenceSettings, QQueryProperty> {
  QueryBuilder<CoverPersistenceSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<CoverPersistenceSettings, bool, QQueryOperations>
      enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"enabled");
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverSize, QQueryOperations>
      fullSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"fullSize");
    });
  }

  QueryBuilder<CoverPersistenceSettings, String, QQueryOperations>
      keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"key");
    });
  }

  QueryBuilder<CoverPersistenceSettings, CoverSize, QQueryOperations>
      previewSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"previewSize");
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChapterPersistenceSettingsCollection on Isar {
  IsarCollection<ChapterPersistenceSettings> get chapterPersistenceSettings =>
      this.collection();
}

const ChapterPersistenceSettingsSchema = CollectionSchema(
  name: r"ChapterPersistenceSettings",
  id: -7962173268331618503,
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
  estimateSize: _chapterPersistenceSettingsEstimateSize,
  serialize: _chapterPersistenceSettingsSerialize,
  deserialize: _chapterPersistenceSettingsDeserialize,
  deserializeProp: _chapterPersistenceSettingsDeserializeProp,
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
  getId: _chapterPersistenceSettingsGetId,
  getLinks: _chapterPersistenceSettingsGetLinks,
  attach: _chapterPersistenceSettingsAttach,
  version: "3.1.0+1",
);

int _chapterPersistenceSettingsEstimateSize(
  ChapterPersistenceSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _chapterPersistenceSettingsSerialize(
  ChapterPersistenceSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.enabled);
  writer.writeString(offsets[1], object.key);
}

ChapterPersistenceSettings _chapterPersistenceSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterPersistenceSettings(
    enabled: reader.readBool(offsets[0]),
  );
  return object;
}

P _chapterPersistenceSettingsDeserializeProp<P>(
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

Id _chapterPersistenceSettingsGetId(ChapterPersistenceSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _chapterPersistenceSettingsGetLinks(
    ChapterPersistenceSettings object) {
  return [];
}

void _chapterPersistenceSettingsAttach(
    IsarCollection<dynamic> col, Id id, ChapterPersistenceSettings object) {}

extension ChapterPersistenceSettingsByIndex
    on IsarCollection<ChapterPersistenceSettings> {
  Future<ChapterPersistenceSettings?> getByKey(String key) {
    return getByIndex(r"key", [key]);
  }

  ChapterPersistenceSettings? getByKeySync(String key) {
    return getByIndexSync(r"key", [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r"key", [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r"key", [key]);
  }

  Future<List<ChapterPersistenceSettings?>> getAllByKey(
      List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r"key", values);
  }

  List<ChapterPersistenceSettings?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(ChapterPersistenceSettings object) {
    return putByIndex(r"key", object);
  }

  Id putByKeySync(ChapterPersistenceSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r"key", object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<ChapterPersistenceSettings> objects) {
    return putAllByIndex(r"key", objects);
  }

  List<Id> putAllByKeySync(List<ChapterPersistenceSettings> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r"key", objects, saveLinks: saveLinks);
  }
}

extension ChapterPersistenceSettingsQueryWhereSort on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QWhere> {
  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChapterPersistenceSettingsQueryWhere on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QWhereClause> {
  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterWhereClause> keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"key",
        value: [key],
      ));
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterWhereClause> keyNotEqualTo(String key) {
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

extension ChapterPersistenceSettingsQueryFilter on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QFilterCondition> {
  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterFilterCondition> enabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"enabled",
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
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

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"key",
        value: "",
      ));
    });
  }
}

extension ChapterPersistenceSettingsQueryObject on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QFilterCondition> {}

extension ChapterPersistenceSettingsQueryLinks on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QFilterCondition> {}

extension ChapterPersistenceSettingsQuerySortBy on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QSortBy> {
  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.asc);
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.desc);
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }
}

extension ChapterPersistenceSettingsQuerySortThenBy on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QSortThenBy> {
  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.asc);
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"enabled", Sort.desc);
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }
}

extension ChapterPersistenceSettingsQueryWhereDistinct on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QDistinct> {
  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QDistinct> distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"enabled");
    });
  }

  QueryBuilder<ChapterPersistenceSettings, ChapterPersistenceSettings,
      QDistinct> distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"key", caseSensitive: caseSensitive);
    });
  }
}

extension ChapterPersistenceSettingsQueryProperty on QueryBuilder<
    ChapterPersistenceSettings, ChapterPersistenceSettings, QQueryProperty> {
  QueryBuilder<ChapterPersistenceSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<ChapterPersistenceSettings, bool, QQueryOperations>
      enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"enabled");
    });
  }

  QueryBuilder<ChapterPersistenceSettings, String, QQueryOperations>
      keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"key");
    });
  }
}
