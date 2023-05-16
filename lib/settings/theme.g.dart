// GENERATED CODE - DO NOT MODIFY BY HAND

part of "theme.dart";

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThemeSettingsCWProxy {
  ThemeSettings themeId(ThemeId themeId);

  ThemeSettings themeMode(ThemeMode themeMode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThemeSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThemeSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  ThemeSettings call({
    ThemeId? themeId,
    ThemeMode? themeMode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThemeSettings.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThemeSettings.copyWith.fieldName(...)`
class _$ThemeSettingsCWProxyImpl implements _$ThemeSettingsCWProxy {
  const _$ThemeSettingsCWProxyImpl(this._value);

  final ThemeSettings _value;

  @override
  ThemeSettings themeId(ThemeId themeId) => this(themeId: themeId);

  @override
  ThemeSettings themeMode(ThemeMode themeMode) => this(themeMode: themeMode);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThemeSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThemeSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  ThemeSettings call({
    Object? themeId = const $CopyWithPlaceholder(),
    Object? themeMode = const $CopyWithPlaceholder(),
  }) {
    return ThemeSettings(
      themeId: themeId == const $CopyWithPlaceholder() || themeId == null
          ? _value.themeId
          // ignore: cast_nullable_to_non_nullable
          : themeId as ThemeId,
      themeMode: themeMode == const $CopyWithPlaceholder() || themeMode == null
          ? _value.themeMode
          // ignore: cast_nullable_to_non_nullable
          : themeMode as ThemeMode,
    );
  }
}

extension $ThemeSettingsCopyWith on ThemeSettings {
  /// Returns a callable class that can be used as follows: `instanceOfThemeSettings.copyWith(...)` or like so:`instanceOfThemeSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThemeSettingsCWProxy get copyWith => _$ThemeSettingsCWProxyImpl(this);
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetThemeSettingsCollection on Isar {
  IsarCollection<ThemeSettings> get themeSettings => this.collection();
}

const ThemeSettingsSchema = CollectionSchema(
  name: r"ThemeSettings",
  id: 815540309993789807,
  properties: {
    r"key": PropertySchema(
      id: 0,
      name: r"key",
      type: IsarType.string,
    ),
    r"themeId": PropertySchema(
      id: 1,
      name: r"themeId",
      type: IsarType.byte,
      enumMap: _ThemeSettingsthemeIdEnumValueMap,
    ),
    r"themeMode": PropertySchema(
      id: 2,
      name: r"themeMode",
      type: IsarType.byte,
      enumMap: _ThemeSettingsthemeModeEnumValueMap,
    )
  },
  estimateSize: _themeSettingsEstimateSize,
  serialize: _themeSettingsSerialize,
  deserialize: _themeSettingsDeserialize,
  deserializeProp: _themeSettingsDeserializeProp,
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
  getId: _themeSettingsGetId,
  getLinks: _themeSettingsGetLinks,
  attach: _themeSettingsAttach,
  version: "3.1.0+1",
);

int _themeSettingsEstimateSize(
  ThemeSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _themeSettingsSerialize(
  ThemeSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeByte(offsets[1], object.themeId.index);
  writer.writeByte(offsets[2], object.themeMode.index);
}

ThemeSettings _themeSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ThemeSettings(
    themeId:
        _ThemeSettingsthemeIdValueEnumMap[reader.readByteOrNull(offsets[1])] ??
            ThemeId.dynamic,
    themeMode: _ThemeSettingsthemeModeValueEnumMap[
            reader.readByteOrNull(offsets[2])] ??
        ThemeMode.system,
  );
  return object;
}

P _themeSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_ThemeSettingsthemeIdValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ThemeId.dynamic) as P;
    case 2:
      return (_ThemeSettingsthemeModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ThemeMode.system) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _ThemeSettingsthemeIdEnumValueMap = {
  "dynamic": 0,
  "lavender": 1,
};
const _ThemeSettingsthemeIdValueEnumMap = {
  0: ThemeId.dynamic,
  1: ThemeId.lavender,
};
const _ThemeSettingsthemeModeEnumValueMap = {
  "system": 0,
  "light": 1,
  "dark": 2,
};
const _ThemeSettingsthemeModeValueEnumMap = {
  0: ThemeMode.system,
  1: ThemeMode.light,
  2: ThemeMode.dark,
};

Id _themeSettingsGetId(ThemeSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _themeSettingsGetLinks(ThemeSettings object) {
  return [];
}

void _themeSettingsAttach(
    IsarCollection<dynamic> col, Id id, ThemeSettings object) {}

extension ThemeSettingsByIndex on IsarCollection<ThemeSettings> {
  Future<ThemeSettings?> getByKey(String key) {
    return getByIndex(r"key", [key]);
  }

  ThemeSettings? getByKeySync(String key) {
    return getByIndexSync(r"key", [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r"key", [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r"key", [key]);
  }

  Future<List<ThemeSettings?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r"key", values);
  }

  List<ThemeSettings?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(ThemeSettings object) {
    return putByIndex(r"key", object);
  }

  Id putByKeySync(ThemeSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r"key", object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<ThemeSettings> objects) {
    return putAllByIndex(r"key", objects);
  }

  List<Id> putAllByKeySync(List<ThemeSettings> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r"key", objects, saveLinks: saveLinks);
  }
}

extension ThemeSettingsQueryWhereSort
    on QueryBuilder<ThemeSettings, ThemeSettings, QWhere> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ThemeSettingsQueryWhere
    on QueryBuilder<ThemeSettings, ThemeSettings, QWhereClause> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idBetween(
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> keyEqualTo(
      String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"key",
        value: [key],
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> keyNotEqualTo(
      String key) {
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

extension ThemeSettingsQueryFilter
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> keyEqualTo(
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> keyLessThan(
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> keyBetween(
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> keyEndsWith(
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

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"key",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeIdEqualTo(ThemeId value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"themeId",
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeIdGreaterThan(
    ThemeId value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"themeId",
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeIdLessThan(
    ThemeId value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"themeId",
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeIdBetween(
    ThemeId lower,
    ThemeId upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"themeId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeEqualTo(ThemeMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"themeMode",
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeGreaterThan(
    ThemeMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"themeMode",
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeLessThan(
    ThemeMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"themeMode",
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeModeBetween(
    ThemeMode lower,
    ThemeMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"themeMode",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ThemeSettingsQueryObject
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {}

extension ThemeSettingsQueryLinks
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {}

extension ThemeSettingsQuerySortBy
    on QueryBuilder<ThemeSettings, ThemeSettings, QSortBy> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByThemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeId", Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByThemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeId", Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.desc);
    });
  }
}

extension ThemeSettingsQuerySortThenBy
    on QueryBuilder<ThemeSettings, ThemeSettings, QSortThenBy> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByThemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeId", Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByThemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeId", Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.desc);
    });
  }
}

extension ThemeSettingsQueryWhereDistinct
    on QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> {
  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"key", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByThemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"themeId");
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"themeMode");
    });
  }
}

extension ThemeSettingsQueryProperty
    on QueryBuilder<ThemeSettings, ThemeSettings, QQueryProperty> {
  QueryBuilder<ThemeSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<ThemeSettings, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"key");
    });
  }

  QueryBuilder<ThemeSettings, ThemeId, QQueryOperations> themeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"themeId");
    });
  }

  QueryBuilder<ThemeSettings, ThemeMode, QQueryOperations> themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"themeMode");
    });
  }
}
