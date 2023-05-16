// GENERATED CODE - DO NOT MODIFY BY HAND

part of "content_filters.dart";

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContentFilterSettingsCWProxy {
  ContentFilterSettings originalLanguages(List<Language> originalLanguages);

  ContentFilterSettings chapterLanguages(List<Language> chapterLanguages);

  ContentFilterSettings contentRatings(List<ContentRating> contentRatings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ContentFilterSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ContentFilterSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  ContentFilterSettings call({
    List<Language>? originalLanguages,
    List<Language>? chapterLanguages,
    List<ContentRating>? contentRatings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfContentFilterSettings.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfContentFilterSettings.copyWith.fieldName(...)`
class _$ContentFilterSettingsCWProxyImpl
    implements _$ContentFilterSettingsCWProxy {
  const _$ContentFilterSettingsCWProxyImpl(this._value);

  final ContentFilterSettings _value;

  @override
  ContentFilterSettings originalLanguages(List<Language> originalLanguages) =>
      this(originalLanguages: originalLanguages);

  @override
  ContentFilterSettings chapterLanguages(List<Language> chapterLanguages) =>
      this(chapterLanguages: chapterLanguages);

  @override
  ContentFilterSettings contentRatings(List<ContentRating> contentRatings) =>
      this(contentRatings: contentRatings);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ContentFilterSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ContentFilterSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  ContentFilterSettings call({
    Object? originalLanguages = const $CopyWithPlaceholder(),
    Object? chapterLanguages = const $CopyWithPlaceholder(),
    Object? contentRatings = const $CopyWithPlaceholder(),
  }) {
    return ContentFilterSettings(
      originalLanguages: originalLanguages == const $CopyWithPlaceholder() ||
              originalLanguages == null
          ? _value.originalLanguages
          // ignore: cast_nullable_to_non_nullable
          : originalLanguages as List<Language>,
      chapterLanguages: chapterLanguages == const $CopyWithPlaceholder() ||
              chapterLanguages == null
          ? _value.chapterLanguages
          // ignore: cast_nullable_to_non_nullable
          : chapterLanguages as List<Language>,
      contentRatings: contentRatings == const $CopyWithPlaceholder() ||
              contentRatings == null
          ? _value.contentRatings
          // ignore: cast_nullable_to_non_nullable
          : contentRatings as List<ContentRating>,
    );
  }
}

extension $ContentFilterSettingsCopyWith on ContentFilterSettings {
  /// Returns a callable class that can be used as follows: `instanceOfContentFilterSettings.copyWith(...)` or like so:`instanceOfContentFilterSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContentFilterSettingsCWProxy get copyWith =>
      _$ContentFilterSettingsCWProxyImpl(this);
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetContentFilterSettingsCollection on Isar {
  IsarCollection<ContentFilterSettings> get contentFilterSettings =>
      this.collection();
}

const ContentFilterSettingsSchema = CollectionSchema(
  name: r"ContentFilterSettings",
  id: -4580227323529649878,
  properties: {
    r"chapterLanguages": PropertySchema(
      id: 0,
      name: r"chapterLanguages",
      type: IsarType.byteList,
      enumMap: _ContentFilterSettingschapterLanguagesEnumValueMap,
    ),
    r"contentRatings": PropertySchema(
      id: 1,
      name: r"contentRatings",
      type: IsarType.byteList,
      enumMap: _ContentFilterSettingscontentRatingsEnumValueMap,
    ),
    r"key": PropertySchema(
      id: 2,
      name: r"key",
      type: IsarType.string,
    ),
    r"originalLanguages": PropertySchema(
      id: 3,
      name: r"originalLanguages",
      type: IsarType.byteList,
      enumMap: _ContentFilterSettingsoriginalLanguagesEnumValueMap,
    )
  },
  estimateSize: _contentFilterSettingsEstimateSize,
  serialize: _contentFilterSettingsSerialize,
  deserialize: _contentFilterSettingsDeserialize,
  deserializeProp: _contentFilterSettingsDeserializeProp,
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
  getId: _contentFilterSettingsGetId,
  getLinks: _contentFilterSettingsGetLinks,
  attach: _contentFilterSettingsAttach,
  version: "3.1.0+1",
);

int _contentFilterSettingsEstimateSize(
  ContentFilterSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chapterLanguages.length;
  bytesCount += 3 + object.contentRatings.length;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.originalLanguages.length;
  return bytesCount;
}

void _contentFilterSettingsSerialize(
  ContentFilterSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(
      offsets[0], object.chapterLanguages.map((e) => e.index).toList());
  writer.writeByteList(
      offsets[1], object.contentRatings.map((e) => e.index).toList());
  writer.writeString(offsets[2], object.key);
  writer.writeByteList(
      offsets[3], object.originalLanguages.map((e) => e.index).toList());
}

ContentFilterSettings _contentFilterSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ContentFilterSettings(
    chapterLanguages: reader
            .readByteList(offsets[0])
            ?.map((e) =>
                _ContentFilterSettingschapterLanguagesValueEnumMap[e] ??
                Language.english)
            .toList() ??
        [],
    contentRatings: reader
            .readByteList(offsets[1])
            ?.map((e) =>
                _ContentFilterSettingscontentRatingsValueEnumMap[e] ??
                ContentRating.safe)
            .toList() ??
        [],
    originalLanguages: reader
            .readByteList(offsets[3])
            ?.map((e) =>
                _ContentFilterSettingsoriginalLanguagesValueEnumMap[e] ??
                Language.english)
            .toList() ??
        [],
  );
  return object;
}

P _contentFilterSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _ContentFilterSettingschapterLanguagesValueEnumMap[e] ??
                  Language.english)
              .toList() ??
          []) as P;
    case 1:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _ContentFilterSettingscontentRatingsValueEnumMap[e] ??
                  ContentRating.safe)
              .toList() ??
          []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _ContentFilterSettingsoriginalLanguagesValueEnumMap[e] ??
                  Language.english)
              .toList() ??
          []) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _ContentFilterSettingschapterLanguagesEnumValueMap = {
  "english": 0,
  "japanese": 1,
  "simpleChinese": 2,
  "traditionalChinese": 3,
  "korean": 4,
  "french": 5,
  "russian": 6,
  "vietnamese": 7,
  "portugueseBrazil": 8,
  "indonesian": 9,
};
const _ContentFilterSettingschapterLanguagesValueEnumMap = {
  0: Language.english,
  1: Language.japanese,
  2: Language.simpleChinese,
  3: Language.traditionalChinese,
  4: Language.korean,
  5: Language.french,
  6: Language.russian,
  7: Language.vietnamese,
  8: Language.portugueseBrazil,
  9: Language.indonesian,
};
const _ContentFilterSettingscontentRatingsEnumValueMap = {
  "safe": 0,
  "suggestive": 1,
  "erotica": 2,
  "pornographic": 3,
};
const _ContentFilterSettingscontentRatingsValueEnumMap = {
  0: ContentRating.safe,
  1: ContentRating.suggestive,
  2: ContentRating.erotica,
  3: ContentRating.pornographic,
};
const _ContentFilterSettingsoriginalLanguagesEnumValueMap = {
  "english": 0,
  "japanese": 1,
  "simpleChinese": 2,
  "traditionalChinese": 3,
  "korean": 4,
  "french": 5,
  "russian": 6,
  "vietnamese": 7,
  "portugueseBrazil": 8,
  "indonesian": 9,
};
const _ContentFilterSettingsoriginalLanguagesValueEnumMap = {
  0: Language.english,
  1: Language.japanese,
  2: Language.simpleChinese,
  3: Language.traditionalChinese,
  4: Language.korean,
  5: Language.french,
  6: Language.russian,
  7: Language.vietnamese,
  8: Language.portugueseBrazil,
  9: Language.indonesian,
};

Id _contentFilterSettingsGetId(ContentFilterSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _contentFilterSettingsGetLinks(
    ContentFilterSettings object) {
  return [];
}

void _contentFilterSettingsAttach(
    IsarCollection<dynamic> col, Id id, ContentFilterSettings object) {}

extension ContentFilterSettingsByIndex
    on IsarCollection<ContentFilterSettings> {
  Future<ContentFilterSettings?> getByKey(String key) {
    return getByIndex(r"key", [key]);
  }

  ContentFilterSettings? getByKeySync(String key) {
    return getByIndexSync(r"key", [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r"key", [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r"key", [key]);
  }

  Future<List<ContentFilterSettings?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r"key", values);
  }

  List<ContentFilterSettings?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(ContentFilterSettings object) {
    return putByIndex(r"key", object);
  }

  Id putByKeySync(ContentFilterSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r"key", object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<ContentFilterSettings> objects) {
    return putAllByIndex(r"key", objects);
  }

  List<Id> putAllByKeySync(List<ContentFilterSettings> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r"key", objects, saveLinks: saveLinks);
  }
}

extension ContentFilterSettingsQueryWhereSort
    on QueryBuilder<ContentFilterSettings, ContentFilterSettings, QWhere> {
  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ContentFilterSettingsQueryWhere on QueryBuilder<ContentFilterSettings,
    ContentFilterSettings, QWhereClause> {
  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterWhereClause>
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterWhereClause>
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterWhereClause>
      keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"key",
        value: [key],
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterWhereClause>
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

extension ContentFilterSettingsQueryFilter on QueryBuilder<
    ContentFilterSettings, ContentFilterSettings, QFilterCondition> {
  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesElementEqualTo(Language value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"chapterLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesElementGreaterThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"chapterLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesElementLessThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"chapterLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesElementBetween(
    Language lower,
    Language upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"chapterLanguages",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"chapterLanguages",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"chapterLanguages",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"chapterLanguages",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"chapterLanguages",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"chapterLanguages",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> chapterLanguagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"chapterLanguages",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsElementEqualTo(ContentRating value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"contentRatings",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsElementGreaterThan(
    ContentRating value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"contentRatings",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsElementLessThan(
    ContentRating value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"contentRatings",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsElementBetween(
    ContentRating lower,
    ContentRating upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"contentRatings",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"contentRatings",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"contentRatings",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"contentRatings",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"contentRatings",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"contentRatings",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> contentRatingsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"contentRatings",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
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

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"key",
        value: "",
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesElementEqualTo(Language value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"originalLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesElementGreaterThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"originalLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesElementLessThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"originalLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesElementBetween(
    Language lower,
    Language upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"originalLanguages",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"originalLanguages",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"originalLanguages",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"originalLanguages",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"originalLanguages",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"originalLanguages",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings,
      QAfterFilterCondition> originalLanguagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"originalLanguages",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ContentFilterSettingsQueryObject on QueryBuilder<
    ContentFilterSettings, ContentFilterSettings, QFilterCondition> {}

extension ContentFilterSettingsQueryLinks on QueryBuilder<ContentFilterSettings,
    ContentFilterSettings, QFilterCondition> {}

extension ContentFilterSettingsQuerySortBy
    on QueryBuilder<ContentFilterSettings, ContentFilterSettings, QSortBy> {
  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterSortBy>
      sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }
}

extension ContentFilterSettingsQuerySortThenBy
    on QueryBuilder<ContentFilterSettings, ContentFilterSettings, QSortThenBy> {
  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterSortBy>
      thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.asc);
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"key", Sort.desc);
    });
  }
}

extension ContentFilterSettingsQueryWhereDistinct
    on QueryBuilder<ContentFilterSettings, ContentFilterSettings, QDistinct> {
  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QDistinct>
      distinctByChapterLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"chapterLanguages");
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QDistinct>
      distinctByContentRatings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"contentRatings");
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QDistinct>
      distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"key", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ContentFilterSettings, ContentFilterSettings, QDistinct>
      distinctByOriginalLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"originalLanguages");
    });
  }
}

extension ContentFilterSettingsQueryProperty on QueryBuilder<
    ContentFilterSettings, ContentFilterSettings, QQueryProperty> {
  QueryBuilder<ContentFilterSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<ContentFilterSettings, List<Language>, QQueryOperations>
      chapterLanguagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"chapterLanguages");
    });
  }

  QueryBuilder<ContentFilterSettings, List<ContentRating>, QQueryOperations>
      contentRatingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"contentRatings");
    });
  }

  QueryBuilder<ContentFilterSettings, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"key");
    });
  }

  QueryBuilder<ContentFilterSettings, List<Language>, QQueryOperations>
      originalLanguagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"originalLanguages");
    });
  }
}
