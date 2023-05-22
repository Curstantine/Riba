// GENERATED CODE - DO NOT MODIFY BY HAND

part of "store.dart";

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppearanceSettingsStoreCWProxy {
  AppearanceSettingsStore lightSchemeId(SchemeId lightSchemeId);

  AppearanceSettingsStore darkSchemeId(SchemeId darkSchemeId);

  AppearanceSettingsStore themeMode(ThemeMode themeMode);

  AppearanceSettingsStore preferredDisplayLocales(
      List<Locale> preferredDisplayLocales);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppearanceSettingsStore(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppearanceSettingsStore(...).copyWith(id: 12, name: "My name")
  /// ````
  AppearanceSettingsStore call({
    SchemeId? lightSchemeId,
    SchemeId? darkSchemeId,
    ThemeMode? themeMode,
    List<Locale>? preferredDisplayLocales,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppearanceSettingsStore.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppearanceSettingsStore.copyWith.fieldName(...)`
class _$AppearanceSettingsStoreCWProxyImpl
    implements _$AppearanceSettingsStoreCWProxy {
  const _$AppearanceSettingsStoreCWProxyImpl(this._value);

  final AppearanceSettingsStore _value;

  @override
  AppearanceSettingsStore lightSchemeId(SchemeId lightSchemeId) =>
      this(lightSchemeId: lightSchemeId);

  @override
  AppearanceSettingsStore darkSchemeId(SchemeId darkSchemeId) =>
      this(darkSchemeId: darkSchemeId);

  @override
  AppearanceSettingsStore themeMode(ThemeMode themeMode) =>
      this(themeMode: themeMode);

  @override
  AppearanceSettingsStore preferredDisplayLocales(
          List<Locale> preferredDisplayLocales) =>
      this(preferredDisplayLocales: preferredDisplayLocales);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppearanceSettingsStore(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppearanceSettingsStore(...).copyWith(id: 12, name: "My name")
  /// ````
  AppearanceSettingsStore call({
    Object? lightSchemeId = const $CopyWithPlaceholder(),
    Object? darkSchemeId = const $CopyWithPlaceholder(),
    Object? themeMode = const $CopyWithPlaceholder(),
    Object? preferredDisplayLocales = const $CopyWithPlaceholder(),
  }) {
    return AppearanceSettingsStore(
      lightSchemeId:
          lightSchemeId == const $CopyWithPlaceholder() || lightSchemeId == null
              ? _value.lightSchemeId
              // ignore: cast_nullable_to_non_nullable
              : lightSchemeId as SchemeId,
      darkSchemeId:
          darkSchemeId == const $CopyWithPlaceholder() || darkSchemeId == null
              ? _value.darkSchemeId
              // ignore: cast_nullable_to_non_nullable
              : darkSchemeId as SchemeId,
      themeMode: themeMode == const $CopyWithPlaceholder() || themeMode == null
          ? _value.themeMode
          // ignore: cast_nullable_to_non_nullable
          : themeMode as ThemeMode,
      preferredDisplayLocales:
          preferredDisplayLocales == const $CopyWithPlaceholder() ||
                  preferredDisplayLocales == null
              ? _value.preferredDisplayLocales
              // ignore: cast_nullable_to_non_nullable
              : preferredDisplayLocales as List<Locale>,
    );
  }
}

extension $AppearanceSettingsStoreCopyWith on AppearanceSettingsStore {
  /// Returns a callable class that can be used as follows: `instanceOfAppearanceSettingsStore.copyWith(...)` or like so:`instanceOfAppearanceSettingsStore.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppearanceSettingsStoreCWProxy get copyWith =>
      _$AppearanceSettingsStoreCWProxyImpl(this);
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppearanceSettingsStoreCollection on Isar {
  IsarCollection<AppearanceSettingsStore> get appearanceSettings =>
      this.collection();
}

const AppearanceSettingsStoreSchema = CollectionSchema(
  name: r"AppearanceSettingsStore",
  id: 7080077831121807335,
  properties: {
    r"darkSchemeId": PropertySchema(
      id: 0,
      name: r"darkSchemeId",
      type: IsarType.byte,
      enumMap: _AppearanceSettingsStoredarkSchemeIdEnumValueMap,
    ),
    r"lightSchemeId": PropertySchema(
      id: 1,
      name: r"lightSchemeId",
      type: IsarType.byte,
      enumMap: _AppearanceSettingsStorelightSchemeIdEnumValueMap,
    ),
    r"preferredDisplayLocales": PropertySchema(
      id: 2,
      name: r"preferredDisplayLocales",
      type: IsarType.objectList,
      target: r"Locale",
    ),
    r"themeMode": PropertySchema(
      id: 3,
      name: r"themeMode",
      type: IsarType.byte,
      enumMap: _AppearanceSettingsStorethemeModeEnumValueMap,
    )
  },
  estimateSize: _appearanceSettingsStoreEstimateSize,
  serialize: _appearanceSettingsStoreSerialize,
  deserialize: _appearanceSettingsStoreDeserialize,
  deserializeProp: _appearanceSettingsStoreDeserializeProp,
  idName: r"id",
  indexes: {},
  links: {},
  embeddedSchemas: {r"Locale": LocaleSchema},
  getId: _appearanceSettingsStoreGetId,
  getLinks: _appearanceSettingsStoreGetLinks,
  attach: _appearanceSettingsStoreAttach,
  version: "3.1.0+1",
);

int _appearanceSettingsStoreEstimateSize(
  AppearanceSettingsStore object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.preferredDisplayLocales.length * 3;
  {
    final offsets = allOffsets[Locale]!;
    for (var i = 0; i < object.preferredDisplayLocales.length; i++) {
      final value = object.preferredDisplayLocales[i];
      bytesCount += LocaleSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _appearanceSettingsStoreSerialize(
  AppearanceSettingsStore object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.darkSchemeId.index);
  writer.writeByte(offsets[1], object.lightSchemeId.index);
  writer.writeObjectList<Locale>(
    offsets[2],
    allOffsets,
    LocaleSchema.serialize,
    object.preferredDisplayLocales,
  );
  writer.writeByte(offsets[3], object.themeMode.index);
}

AppearanceSettingsStore _appearanceSettingsStoreDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppearanceSettingsStore(
    darkSchemeId: _AppearanceSettingsStoredarkSchemeIdValueEnumMap[
            reader.readByteOrNull(offsets[0])] ??
        SchemeId.dynamic,
    lightSchemeId: _AppearanceSettingsStorelightSchemeIdValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        SchemeId.dynamic,
    preferredDisplayLocales: reader.readObjectList<Locale>(
          offsets[2],
          LocaleSchema.deserialize,
          allOffsets,
          Locale(),
        ) ??
        [],
    themeMode: _AppearanceSettingsStorethemeModeValueEnumMap[
            reader.readByteOrNull(offsets[3])] ??
        ThemeMode.system,
  );
  return object;
}

P _appearanceSettingsStoreDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_AppearanceSettingsStoredarkSchemeIdValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SchemeId.dynamic) as P;
    case 1:
      return (_AppearanceSettingsStorelightSchemeIdValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SchemeId.dynamic) as P;
    case 2:
      return (reader.readObjectList<Locale>(
            offset,
            LocaleSchema.deserialize,
            allOffsets,
            Locale(),
          ) ??
          []) as P;
    case 3:
      return (_AppearanceSettingsStorethemeModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ThemeMode.system) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _AppearanceSettingsStoredarkSchemeIdEnumValueMap = {
  "dynamic": 0,
  "brittlePink": 1,
};
const _AppearanceSettingsStoredarkSchemeIdValueEnumMap = {
  0: SchemeId.dynamic,
  1: SchemeId.brittlePink,
};
const _AppearanceSettingsStorelightSchemeIdEnumValueMap = {
  "dynamic": 0,
  "brittlePink": 1,
};
const _AppearanceSettingsStorelightSchemeIdValueEnumMap = {
  0: SchemeId.dynamic,
  1: SchemeId.brittlePink,
};
const _AppearanceSettingsStorethemeModeEnumValueMap = {
  "system": 0,
  "light": 1,
  "dark": 2,
};
const _AppearanceSettingsStorethemeModeValueEnumMap = {
  0: ThemeMode.system,
  1: ThemeMode.light,
  2: ThemeMode.dark,
};

Id _appearanceSettingsStoreGetId(AppearanceSettingsStore object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appearanceSettingsStoreGetLinks(
    AppearanceSettingsStore object) {
  return [];
}

void _appearanceSettingsStoreAttach(
    IsarCollection<dynamic> col, Id id, AppearanceSettingsStore object) {}

extension AppearanceSettingsStoreQueryWhereSort
    on QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QWhere> {
  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppearanceSettingsStoreQueryWhere on QueryBuilder<
    AppearanceSettingsStore, AppearanceSettingsStore, QWhereClause> {
  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
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

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
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

extension AppearanceSettingsStoreQueryFilter on QueryBuilder<
    AppearanceSettingsStore, AppearanceSettingsStore, QFilterCondition> {
  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> darkSchemeIdEqualTo(SchemeId value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"darkSchemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> darkSchemeIdGreaterThan(
    SchemeId value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"darkSchemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> darkSchemeIdLessThan(
    SchemeId value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"darkSchemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> darkSchemeIdBetween(
    SchemeId lower,
    SchemeId upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"darkSchemeId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
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

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
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

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
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

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> lightSchemeIdEqualTo(SchemeId value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"lightSchemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> lightSchemeIdGreaterThan(
    SchemeId value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"lightSchemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> lightSchemeIdLessThan(
    SchemeId value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"lightSchemeId",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> lightSchemeIdBetween(
    SchemeId lower,
    SchemeId upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"lightSchemeId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> preferredDisplayLocalesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"preferredDisplayLocales",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> preferredDisplayLocalesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"preferredDisplayLocales",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> preferredDisplayLocalesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"preferredDisplayLocales",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> preferredDisplayLocalesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"preferredDisplayLocales",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> preferredDisplayLocalesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"preferredDisplayLocales",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> preferredDisplayLocalesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"preferredDisplayLocales",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> themeModeEqualTo(ThemeMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"themeMode",
        value: value,
      ));
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> themeModeGreaterThan(
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

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> themeModeLessThan(
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

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
      QAfterFilterCondition> themeModeBetween(
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

extension AppearanceSettingsStoreQueryObject on QueryBuilder<
    AppearanceSettingsStore, AppearanceSettingsStore, QFilterCondition> {
  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore,
          QAfterFilterCondition>
      preferredDisplayLocalesElement(FilterQuery<Locale> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"preferredDisplayLocales");
    });
  }
}

extension AppearanceSettingsStoreQueryLinks on QueryBuilder<
    AppearanceSettingsStore, AppearanceSettingsStore, QFilterCondition> {}

extension AppearanceSettingsStoreQuerySortBy
    on QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QSortBy> {
  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      sortByDarkSchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"darkSchemeId", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      sortByDarkSchemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"darkSchemeId", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      sortByLightSchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"lightSchemeId", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      sortByLightSchemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"lightSchemeId", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.desc);
    });
  }
}

extension AppearanceSettingsStoreQuerySortThenBy on QueryBuilder<
    AppearanceSettingsStore, AppearanceSettingsStore, QSortThenBy> {
  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      thenByDarkSchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"darkSchemeId", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      thenByDarkSchemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"darkSchemeId", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      thenByLightSchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"lightSchemeId", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      thenByLightSchemeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"lightSchemeId", Sort.desc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.asc);
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QAfterSortBy>
      thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"themeMode", Sort.desc);
    });
  }
}

extension AppearanceSettingsStoreQueryWhereDistinct on QueryBuilder<
    AppearanceSettingsStore, AppearanceSettingsStore, QDistinct> {
  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QDistinct>
      distinctByDarkSchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"darkSchemeId");
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QDistinct>
      distinctByLightSchemeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"lightSchemeId");
    });
  }

  QueryBuilder<AppearanceSettingsStore, AppearanceSettingsStore, QDistinct>
      distinctByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"themeMode");
    });
  }
}

extension AppearanceSettingsStoreQueryProperty on QueryBuilder<
    AppearanceSettingsStore, AppearanceSettingsStore, QQueryProperty> {
  QueryBuilder<AppearanceSettingsStore, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<AppearanceSettingsStore, SchemeId, QQueryOperations>
      darkSchemeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"darkSchemeId");
    });
  }

  QueryBuilder<AppearanceSettingsStore, SchemeId, QQueryOperations>
      lightSchemeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"lightSchemeId");
    });
  }

  QueryBuilder<AppearanceSettingsStore, List<Locale>, QQueryOperations>
      preferredDisplayLocalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"preferredDisplayLocales");
    });
  }

  QueryBuilder<AppearanceSettingsStore, ThemeMode, QQueryOperations>
      themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"themeMode");
    });
  }
}
