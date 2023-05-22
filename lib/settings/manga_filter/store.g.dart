// GENERATED CODE - DO NOT MODIFY BY HAND

part of "store.dart";

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MangaFilterSettingsStoreCWProxy {
  MangaFilterSettingsStore id(String id);

  MangaFilterSettingsStore excludedGroupIds(List<String> excludedGroupIds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaFilterSettingsStore(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaFilterSettingsStore(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaFilterSettingsStore call({
    String? id,
    List<String>? excludedGroupIds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMangaFilterSettingsStore.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMangaFilterSettingsStore.copyWith.fieldName(...)`
class _$MangaFilterSettingsStoreCWProxyImpl
    implements _$MangaFilterSettingsStoreCWProxy {
  const _$MangaFilterSettingsStoreCWProxyImpl(this._value);

  final MangaFilterSettingsStore _value;

  @override
  MangaFilterSettingsStore id(String id) => this(id: id);

  @override
  MangaFilterSettingsStore excludedGroupIds(List<String> excludedGroupIds) =>
      this(excludedGroupIds: excludedGroupIds);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MangaFilterSettingsStore(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MangaFilterSettingsStore(...).copyWith(id: 12, name: "My name")
  /// ````
  MangaFilterSettingsStore call({
    Object? id = const $CopyWithPlaceholder(),
    Object? excludedGroupIds = const $CopyWithPlaceholder(),
  }) {
    return MangaFilterSettingsStore(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      excludedGroupIds: excludedGroupIds == const $CopyWithPlaceholder() ||
              excludedGroupIds == null
          ? _value.excludedGroupIds
          // ignore: cast_nullable_to_non_nullable
          : excludedGroupIds as List<String>,
    );
  }
}

extension $MangaFilterSettingsStoreCopyWith on MangaFilterSettingsStore {
  /// Returns a callable class that can be used as follows: `instanceOfMangaFilterSettingsStore.copyWith(...)` or like so:`instanceOfMangaFilterSettingsStore.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MangaFilterSettingsStoreCWProxy get copyWith =>
      _$MangaFilterSettingsStoreCWProxyImpl(this);
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMangaFilterSettingsStoreCollection on Isar {
  IsarCollection<MangaFilterSettingsStore> get mangaFilterSettings =>
      this.collection();
}

const MangaFilterSettingsStoreSchema = CollectionSchema(
  name: r"MangaFilterSettingsStore",
  id: -7852478692418679483,
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
  estimateSize: _mangaFilterSettingsStoreEstimateSize,
  serialize: _mangaFilterSettingsStoreSerialize,
  deserialize: _mangaFilterSettingsStoreDeserialize,
  deserializeProp: _mangaFilterSettingsStoreDeserializeProp,
  idName: r"isarId",
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mangaFilterSettingsStoreGetId,
  getLinks: _mangaFilterSettingsStoreGetLinks,
  attach: _mangaFilterSettingsStoreAttach,
  version: "3.1.0+1",
);

int _mangaFilterSettingsStoreEstimateSize(
  MangaFilterSettingsStore object,
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

void _mangaFilterSettingsStoreSerialize(
  MangaFilterSettingsStore object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.excludedGroupIds);
  writer.writeString(offsets[1], object.id);
  writer.writeBool(offsets[2], object.isDefault);
}

MangaFilterSettingsStore _mangaFilterSettingsStoreDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MangaFilterSettingsStore(
    excludedGroupIds: reader.readStringList(offsets[0]) ?? [],
    id: reader.readString(offsets[1]),
  );
  return object;
}

P _mangaFilterSettingsStoreDeserializeProp<P>(
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

Id _mangaFilterSettingsStoreGetId(MangaFilterSettingsStore object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _mangaFilterSettingsStoreGetLinks(
    MangaFilterSettingsStore object) {
  return [];
}

void _mangaFilterSettingsStoreAttach(
    IsarCollection<dynamic> col, Id id, MangaFilterSettingsStore object) {}

extension MangaFilterSettingsStoreQueryWhereSort on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QWhere> {
  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MangaFilterSettingsStoreQueryWhere on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QWhereClause> {
  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterWhereClause> isarIdBetween(
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

extension MangaFilterSettingsStoreQueryFilter on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QFilterCondition> {
  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsElementEqualTo(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsElementGreaterThan(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsElementLessThan(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsElementBetween(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsElementStartsWith(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsElementEndsWith(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
          QAfterFilterCondition>
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
          QAfterFilterCondition>
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"excludedGroupIds",
        value: "",
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"excludedGroupIds",
        value: "",
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsLengthEqualTo(int length) {
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsIsEmpty() {
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsIsNotEmpty() {
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsLengthLessThan(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsLengthGreaterThan(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> excludedGroupIdsLengthBetween(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"id",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> isDefaultEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isDefault",
        value: value,
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore,
      QAfterFilterCondition> isarIdBetween(
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

extension MangaFilterSettingsStoreQueryObject on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QFilterCondition> {}

extension MangaFilterSettingsStoreQueryLinks on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QFilterCondition> {}

extension MangaFilterSettingsStoreQuerySortBy on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QSortBy> {
  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      sortByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isDefault", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      sortByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isDefault", Sort.desc);
    });
  }
}

extension MangaFilterSettingsStoreQuerySortThenBy on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QSortThenBy> {
  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      thenByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isDefault", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      thenByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isDefault", Sort.desc);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }
}

extension MangaFilterSettingsStoreQueryWhereDistinct on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QDistinct> {
  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QDistinct>
      distinctByExcludedGroupIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"excludedGroupIds");
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MangaFilterSettingsStore, MangaFilterSettingsStore, QDistinct>
      distinctByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"isDefault");
    });
  }
}

extension MangaFilterSettingsStoreQueryProperty on QueryBuilder<
    MangaFilterSettingsStore, MangaFilterSettingsStore, QQueryProperty> {
  QueryBuilder<MangaFilterSettingsStore, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<MangaFilterSettingsStore, List<String>, QQueryOperations>
      excludedGroupIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"excludedGroupIds");
    });
  }

  QueryBuilder<MangaFilterSettingsStore, String, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<MangaFilterSettingsStore, bool, QQueryOperations>
      isDefaultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isDefault");
    });
  }
}
