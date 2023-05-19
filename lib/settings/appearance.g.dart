// GENERATED CODE - DO NOT MODIFY BY HAND

part of "appearance.dart";

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppearanceSettingsCWProxy {
  AppearanceSettings schemeId(SchemeId schemeId);

  AppearanceSettings themeMode(ThemeMode themeMode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppearanceSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppearanceSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  AppearanceSettings call({
    SchemeId? schemeId,
    ThemeMode? themeMode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppearanceSettings.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppearanceSettings.copyWith.fieldName(...)`
class _$AppearanceSettingsCWProxyImpl implements _$AppearanceSettingsCWProxy {
  const _$AppearanceSettingsCWProxyImpl(this._value);

  final AppearanceSettings _value;

  @override
  AppearanceSettings schemeId(SchemeId schemeId) => this(schemeId: schemeId);

  @override
  AppearanceSettings themeMode(ThemeMode themeMode) =>
      this(themeMode: themeMode);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppearanceSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppearanceSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  AppearanceSettings call({
    Object? schemeId = const $CopyWithPlaceholder(),
    Object? themeMode = const $CopyWithPlaceholder(),
  }) {
    return AppearanceSettings(
      schemeId: schemeId == const $CopyWithPlaceholder() || schemeId == null
          ? _value.schemeId
          // ignore: cast_nullable_to_non_nullable
          : schemeId as SchemeId,
      themeMode: themeMode == const $CopyWithPlaceholder() || themeMode == null
          ? _value.themeMode
          // ignore: cast_nullable_to_non_nullable
          : themeMode as ThemeMode,
    );
  }
}

extension $AppearanceSettingsCopyWith on AppearanceSettings {
  /// Returns a callable class that can be used as follows: `instanceOfAppearanceSettings.copyWith(...)` or like so:`instanceOfAppearanceSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppearanceSettingsCWProxy get copyWith =>
      _$AppearanceSettingsCWProxyImpl(this);
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppearanceSettingsCollection on Isar {
  IsarCollection<AppearanceSettings> get appearanceSettings =>
      this.collection();
}

const AppearanceSettingsSchema = CollectionSchema(
  name: r"AppearanceSettings",
  id: 6428802170289617316,
  properties: {
    r"key": PropertySchema(
      id: 0,
      name: r"key",
      type: IsarType.string,
    ),
    r"schemeId": PropertySchema(
      id: 1,
      name: r"schemeId",
      type: IsarType.byte,
      enumMap: _AppearanceSettingsschemeIdEnumValueMap,
    ),
    r"themeMode": PropertySchema(
      id: 2,
      name: r"themeMode",
      type: IsarType.byte,
      enumMap: _AppearanceSettingsthemeModeEnumValueMap,
    )
  },
  estimateSize: _appearanceSettingsEstimateSize,
  serialize: _appearanceSettingsSerialize,
  deserialize: _appearanceSettingsDeserialize,
  deserializeProp: _appearanceSettingsDeserializeProp,
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
  getId: _appearanceSettingsGetId,
  getLinks: _appearanceSettingsGetLinks,
  attach: _appearanceSettingsAttach,
  version: "3.1.0+1",
);

int _appearanceSettingsEstimateSize(
  AppearanceSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _appearanceSettingsSerialize(
  AppearanceSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeByte(offsets[1], object.schemeId.index);
  writer.writeByte(offsets[2], object.themeMode.index);
}

AppearanceSettings _appearanceSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppearanceSettings(
    schemeId: _AppearanceSettingsschemeIdValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        SchemeId.dynamic,
    themeMode: _AppearanceSettingsthemeModeValueEnumMap[
            reader.readByteOrNull(offsets[2])] ??
        ThemeMode.system,
  );
  return object;
}

P _appearanceSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_AppearanceSettingsschemeIdValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SchemeId.dynamic) as P;
    case 2:
      return (_AppearanceSettingsthemeModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ThemeMode.system) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _AppearanceSettingsschemeIdEnumValueMap = {
  "dynamic": 0,
  "lavender": 1,
};
const _AppearanceSettingsschemeIdValueEnumMap = {
  0: SchemeId.dynamic,
  1: SchemeId.lavender,
};
const _AppearanceSettingsthemeModeEnumValueMap = {
  "system": 0,
  "light": 1,
  "dark": 2,
};
const _AppearanceSettingsthemeModeValueEnumMap = {
  0: ThemeMode.system,
  1: ThemeMode.light,
  2: ThemeMode.dark,
};

Id _appearanceSettingsGetId(AppearanceSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appearanceSettingsGetLinks(
    AppearanceSettings object) {
  return [];
}

void _appearanceSettingsAttach(
    IsarCollection<dynamic> col, Id id, AppearanceSettings object) {}

extension AppearanceSettingsByIndex on IsarCollection<AppearanceSettings> {
  Future<AppearanceSettings?> getByKey(String key) {
    return getByIndex(r"key", [key]);
  }

  AppearanceSettings? getByKeySync(String key) {
    return getByIndexSync(r"key", [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r"key", [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r"key", [key]);
  }

  Future<List<AppearanceSettings?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r"key", values);
  }

  List<AppearanceSettings?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(AppearanceSettings object) {
    return putByIndex(r"key", object);
  }

  Id putByKeySync(AppearanceSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r"key", object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<AppearanceSettings> objects) {
    return putAllByIndex(r"key", objects);
  }

  List<Id> putAllByKeySync(List<AppearanceSettings> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r"key", objects, saveLinks: saveLinks);
  }
}

extension AppearanceSettingsQueryWhereSort
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QWhere> {
  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppearanceSettingsQueryWhere
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QWhereClause> {
  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterWhereClause>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterWhereClause>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterWhereClause>
      keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"key",
        value: [key],
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterWhereClause>
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

extension AppearanceSettingsQueryFilter
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QFilterCondition> {
  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"key",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"key",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      schemeIdEqualTo(SchemeId value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"schemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      schemeIdGreaterThan(
    SchemeId value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"schemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      schemeIdLessThan(
    SchemeId value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"schemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      schemeIdBetween(
    SchemeId lower,
    SchemeId upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"schemeId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
      themeModeEqualTo(ThemeMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"themeMode",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterFilterCondition>
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

extension AppearanceSettingsQueryObject
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QFilterCondition> {}

extension AppearanceSettingsQueryLinks
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QFilterCondition> {}

extension AppearanceSettingsQuerySortBy
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QSortBy> {
  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      sortBySchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"schemeId", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      sortBySchemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"schemeId", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.desc);
    });
  }
}

extension AppearanceSettingsQuerySortThenBy
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QSortThenBy> {
  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      thenBySchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"schemeId", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      thenBySchemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"schemeId", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QAfterSortBy>
      thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.desc);
    });
  }
}

extension AppearanceSettingsQueryWhereDistinct
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QDistinct> {
  QueryBuilder<AppearanceSettings, AppearanceSettings, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"key", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QDistinct>
      distinctBySchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"schemeId");
    });
  }

  QueryBuilder<AppearanceSettings, AppearanceSettings, QDistinct>
      distinctByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"themeMode");
    });
  }
}

extension AppearanceSettingsQueryProperty
    on QueryBuilder<AppearanceSettings, AppearanceSettings, QQueryProperty> {
  QueryBuilder<AppearanceSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<AppearanceSettings, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"key");
    });
  }

  QueryBuilder<AppearanceSettings, SchemeId, QQueryOperations>
      schemeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"schemeId");
    });
  }

  QueryBuilder<AppearanceSettings, ThemeMode, QQueryOperations>
      themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"themeMode");
    });
  }
}
