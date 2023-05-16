// GENERATED CODE - DO NOT MODIFY BY HAND

part of "manga_filter.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMangaFilterSettingsCollection on Isar {
  IsarCollection<MangaFilterSettings> get mangaFilterSettings =>
      this.collection();
}

const MangaFilterSettingsSchema = CollectionSchema(
  name: r"MangaFilterSettings",
  id: 3978961410874775324,
  properties: {
    r"excludedGroupIds": PropertySchema(
      id: 0,
      name: r"excludedGroupIds",
      type: IsarType.stringList,
    ),
    r"id": PropertySchema(
      id: 1,
      name: r"id",
      type: IsarType.string,
    ),
    r"isDefault": PropertySchema(
      id: 2,
      name: r"isDefault",
      type: IsarType.bool,
    )
  },
  estimateSize: _mangaFilterSettingsEstimateSize,
  serialize: _mangaFilterSettingsSerialize,
  deserialize: _mangaFilterSettingsDeserialize,
  deserializeProp: _mangaFilterSettingsDeserializeProp,
  idName: r"isarId",
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mangaFilterSettingsGetId,
  getLinks: _mangaFilterSettingsGetLinks,
  attach: _mangaFilterSettingsAttach,
  version: "3.1.0+1",
);

int _mangaFilterSettingsEstimateSize(
  MangaFilterSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.excludedGroupIds.length * 3;
  {
    for (var i = 0; i < object.excludedGroupIds.length; i++) {
      final value = object.excludedGroupIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _mangaFilterSettingsSerialize(
  MangaFilterSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.excludedGroupIds);
  writer.writeString(offsets[1], object.id);
  writer.writeBool(offsets[2], object.isDefault);
}

MangaFilterSettings _mangaFilterSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MangaFilterSettings(
    excludedGroupIds: reader.readStringList(offsets[0]) ?? [],
    id: reader.readString(offsets[1]),
  );
  return object;
}

P _mangaFilterSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

Id _mangaFilterSettingsGetId(MangaFilterSettings object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _mangaFilterSettingsGetLinks(
    MangaFilterSettings object) {
  return [];
}

void _mangaFilterSettingsAttach(
    IsarCollection<dynamic> col, Id id, MangaFilterSettings object) {}

extension MangaFilterSettingsQueryWhereSort
    on QueryBuilder<MangaFilterSettings, MangaFilterSettings, QWhere> {
  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MangaFilterSettingsQueryWhere
    on QueryBuilder<MangaFilterSettings, MangaFilterSettings, QWhereClause> {
  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MangaFilterSettingsQueryFilter on QueryBuilder<MangaFilterSettings,
    MangaFilterSettings, QFilterCondition> {
  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"excludedGroupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"excludedGroupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"excludedGroupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"excludedGroupIds",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"excludedGroupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"excludedGroupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"excludedGroupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"excludedGroupIds",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"excludedGroupIds",
        value: "",
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"excludedGroupIds",
        value: "",
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"excludedGroupIds",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"excludedGroupIds",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"excludedGroupIds",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"excludedGroupIds",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"excludedGroupIds",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      excludedGroupIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"excludedGroupIds",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"id",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"id",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      isDefaultEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isDefault",
        value: value,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"isarId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MangaFilterSettingsQueryObject on QueryBuilder<MangaFilterSettings,
    MangaFilterSettings, QFilterCondition> {}

extension MangaFilterSettingsQueryLinks on QueryBuilder<MangaFilterSettings,
    MangaFilterSettings, QFilterCondition> {}

extension MangaFilterSettingsQuerySortBy
    on QueryBuilder<MangaFilterSettings, MangaFilterSettings, QSortBy> {
  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      sortByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isDefault", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      sortByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isDefault", Sort.desc);
    });
  }
}

extension MangaFilterSettingsQuerySortThenBy
    on QueryBuilder<MangaFilterSettings, MangaFilterSettings, QSortThenBy> {
  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      thenByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isDefault", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      thenByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isDefault", Sort.desc);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }
}

extension MangaFilterSettingsQueryWhereDistinct
    on QueryBuilder<MangaFilterSettings, MangaFilterSettings, QDistinct> {
  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QDistinct>
      distinctByExcludedGroupIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"excludedGroupIds");
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MangaFilterSettings, MangaFilterSettings, QDistinct>
      distinctByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"isDefault");
    });
  }
}

extension MangaFilterSettingsQueryProperty
    on QueryBuilder<MangaFilterSettings, MangaFilterSettings, QQueryProperty> {
  QueryBuilder<MangaFilterSettings, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<MangaFilterSettings, List<String>, QQueryOperations>
      excludedGroupIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"excludedGroupIds");
    });
  }

  QueryBuilder<MangaFilterSettings, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<MangaFilterSettings, bool, QQueryOperations>
      isDefaultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isDefault");
    });
  }
}
