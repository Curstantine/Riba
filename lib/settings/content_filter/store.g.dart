// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ContentFilterSettingsStoreCWProxy {
  ContentFilterSettingsStore originalLanguages(
      List<Language> originalLanguages);

  ContentFilterSettingsStore chapterLanguages(List<Language> chapterLanguages);

  ContentFilterSettingsStore contentRatings(List<ContentRating> contentRatings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ContentFilterSettingsStore(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ContentFilterSettingsStore(...).copyWith(id: 12, name: "My name")
  /// ````
  ContentFilterSettingsStore call({
    List<Language>? originalLanguages,
    List<Language>? chapterLanguages,
    List<ContentRating>? contentRatings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfContentFilterSettingsStore.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfContentFilterSettingsStore.copyWith.fieldName(...)`
class _$ContentFilterSettingsStoreCWProxyImpl
    implements _$ContentFilterSettingsStoreCWProxy {
  const _$ContentFilterSettingsStoreCWProxyImpl(this._value);

  final ContentFilterSettingsStore _value;

  @override
  ContentFilterSettingsStore originalLanguages(
          List<Language> originalLanguages) =>
      this(originalLanguages: originalLanguages);

  @override
  ContentFilterSettingsStore chapterLanguages(
          List<Language> chapterLanguages) =>
      this(chapterLanguages: chapterLanguages);

  @override
  ContentFilterSettingsStore contentRatings(
          List<ContentRating> contentRatings) =>
      this(contentRatings: contentRatings);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ContentFilterSettingsStore(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ContentFilterSettingsStore(...).copyWith(id: 12, name: "My name")
  /// ````
  ContentFilterSettingsStore call({
    Object? originalLanguages = const $CopyWithPlaceholder(),
    Object? chapterLanguages = const $CopyWithPlaceholder(),
    Object? contentRatings = const $CopyWithPlaceholder(),
  }) {
    return ContentFilterSettingsStore(
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

extension $ContentFilterSettingsStoreCopyWith on ContentFilterSettingsStore {
  /// Returns a callable class that can be used as follows: `instanceOfContentFilterSettingsStore.copyWith(...)` or like so:`instanceOfContentFilterSettingsStore.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContentFilterSettingsStoreCWProxy get copyWith =>
      _$ContentFilterSettingsStoreCWProxyImpl(this);
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetContentFilterSettingsStoreCollection on Isar {
  IsarCollection<ContentFilterSettingsStore> get contentFilterSettings =>
      this.collection();
}

const ContentFilterSettingsStoreSchema = CollectionSchema(
  name: r'ContentFilterSettingsStore',
  id: 818445002339399232,
  properties: {
    r'chapterLanguages': PropertySchema(
      id: 0,
      name: r'chapterLanguages',
      type: IsarType.byteList,
      enumMap: _ContentFilterSettingsStorechapterLanguagesEnumValueMap,
    ),
    r'contentRatings': PropertySchema(
      id: 1,
      name: r'contentRatings',
      type: IsarType.byteList,
      enumMap: _ContentFilterSettingsStorecontentRatingsEnumValueMap,
    ),
    r'originalLanguages': PropertySchema(
      id: 2,
      name: r'originalLanguages',
      type: IsarType.byteList,
      enumMap: _ContentFilterSettingsStoreoriginalLanguagesEnumValueMap,
    )
  },
  estimateSize: _contentFilterSettingsStoreEstimateSize,
  serialize: _contentFilterSettingsStoreSerialize,
  deserialize: _contentFilterSettingsStoreDeserialize,
  deserializeProp: _contentFilterSettingsStoreDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _contentFilterSettingsStoreGetId,
  getLinks: _contentFilterSettingsStoreGetLinks,
  attach: _contentFilterSettingsStoreAttach,
  version: '3.1.0+1',
);

int _contentFilterSettingsStoreEstimateSize(
  ContentFilterSettingsStore object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chapterLanguages.length;
  bytesCount += 3 + object.contentRatings.length;
  bytesCount += 3 + object.originalLanguages.length;
  return bytesCount;
}

void _contentFilterSettingsStoreSerialize(
  ContentFilterSettingsStore object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(
      offsets[0], object.chapterLanguages.map((e) => e.index).toList());
  writer.writeByteList(
      offsets[1], object.contentRatings.map((e) => e.index).toList());
  writer.writeByteList(
      offsets[2], object.originalLanguages.map((e) => e.index).toList());
}

ContentFilterSettingsStore _contentFilterSettingsStoreDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ContentFilterSettingsStore(
    chapterLanguages: reader
            .readByteList(offsets[0])
            ?.map((e) =>
                _ContentFilterSettingsStorechapterLanguagesValueEnumMap[e] ??
                Language.english)
            .toList() ??
        [],
    contentRatings: reader
            .readByteList(offsets[1])
            ?.map((e) =>
                _ContentFilterSettingsStorecontentRatingsValueEnumMap[e] ??
                ContentRating.safe)
            .toList() ??
        [],
    originalLanguages: reader
            .readByteList(offsets[2])
            ?.map((e) =>
                _ContentFilterSettingsStoreoriginalLanguagesValueEnumMap[e] ??
                Language.english)
            .toList() ??
        [],
  );
  return object;
}

P _contentFilterSettingsStoreDeserializeProp<P>(
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
                  _ContentFilterSettingsStorechapterLanguagesValueEnumMap[e] ??
                  Language.english)
              .toList() ??
          []) as P;
    case 1:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _ContentFilterSettingsStorecontentRatingsValueEnumMap[e] ??
                  ContentRating.safe)
              .toList() ??
          []) as P;
    case 2:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _ContentFilterSettingsStoreoriginalLanguagesValueEnumMap[e] ??
                  Language.english)
              .toList() ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ContentFilterSettingsStorechapterLanguagesEnumValueMap = {
  'english': 0,
  'albanian': 1,
  'arabic': 2,
  'azerbaijani': 3,
  'bengali': 4,
  'bulgarian': 5,
  'burmese': 6,
  'catalan': 7,
  'chineseSimplified': 8,
  'chineseTraditional': 9,
  'croatian': 10,
  'czech': 11,
  'danish': 12,
  'dutch': 13,
  'esperanto': 14,
  'estonian': 15,
  'filipino': 16,
  'finnish': 17,
  'french': 18,
  'georgian': 19,
  'german': 20,
  'greek': 21,
  'hebrew': 22,
  'hindi': 23,
  'hungarian': 24,
  'indonesian': 25,
  'italian': 26,
  'japanese': 27,
  'kazakh': 28,
  'korean': 29,
  'latin': 30,
  'lithuanian': 31,
  'malay': 32,
  'mongolian': 33,
  'nepali': 34,
  'norwegian': 35,
  'persian': 36,
  'polish': 37,
  'portuguese': 38,
  'portugueseBrazil': 39,
  'romanian': 40,
  'russian': 41,
  'serbian': 42,
  'slovak': 43,
  'spanish': 44,
  'spanishLatinAmerica': 45,
  'swedish': 46,
  'tamil': 47,
  'telugu': 48,
  'thai': 49,
  'turkish': 50,
  'ukrainian': 51,
  'vietnamese': 52,
};
const _ContentFilterSettingsStorechapterLanguagesValueEnumMap = {
  0: Language.english,
  1: Language.albanian,
  2: Language.arabic,
  3: Language.azerbaijani,
  4: Language.bengali,
  5: Language.bulgarian,
  6: Language.burmese,
  7: Language.catalan,
  8: Language.chineseSimplified,
  9: Language.chineseTraditional,
  10: Language.croatian,
  11: Language.czech,
  12: Language.danish,
  13: Language.dutch,
  14: Language.esperanto,
  15: Language.estonian,
  16: Language.filipino,
  17: Language.finnish,
  18: Language.french,
  19: Language.georgian,
  20: Language.german,
  21: Language.greek,
  22: Language.hebrew,
  23: Language.hindi,
  24: Language.hungarian,
  25: Language.indonesian,
  26: Language.italian,
  27: Language.japanese,
  28: Language.kazakh,
  29: Language.korean,
  30: Language.latin,
  31: Language.lithuanian,
  32: Language.malay,
  33: Language.mongolian,
  34: Language.nepali,
  35: Language.norwegian,
  36: Language.persian,
  37: Language.polish,
  38: Language.portuguese,
  39: Language.portugueseBrazil,
  40: Language.romanian,
  41: Language.russian,
  42: Language.serbian,
  43: Language.slovak,
  44: Language.spanish,
  45: Language.spanishLatinAmerica,
  46: Language.swedish,
  47: Language.tamil,
  48: Language.telugu,
  49: Language.thai,
  50: Language.turkish,
  51: Language.ukrainian,
  52: Language.vietnamese,
};
const _ContentFilterSettingsStorecontentRatingsEnumValueMap = {
  'safe': 0,
  'suggestive': 1,
  'erotica': 2,
  'pornographic': 3,
};
const _ContentFilterSettingsStorecontentRatingsValueEnumMap = {
  0: ContentRating.safe,
  1: ContentRating.suggestive,
  2: ContentRating.erotica,
  3: ContentRating.pornographic,
};
const _ContentFilterSettingsStoreoriginalLanguagesEnumValueMap = {
  'english': 0,
  'albanian': 1,
  'arabic': 2,
  'azerbaijani': 3,
  'bengali': 4,
  'bulgarian': 5,
  'burmese': 6,
  'catalan': 7,
  'chineseSimplified': 8,
  'chineseTraditional': 9,
  'croatian': 10,
  'czech': 11,
  'danish': 12,
  'dutch': 13,
  'esperanto': 14,
  'estonian': 15,
  'filipino': 16,
  'finnish': 17,
  'french': 18,
  'georgian': 19,
  'german': 20,
  'greek': 21,
  'hebrew': 22,
  'hindi': 23,
  'hungarian': 24,
  'indonesian': 25,
  'italian': 26,
  'japanese': 27,
  'kazakh': 28,
  'korean': 29,
  'latin': 30,
  'lithuanian': 31,
  'malay': 32,
  'mongolian': 33,
  'nepali': 34,
  'norwegian': 35,
  'persian': 36,
  'polish': 37,
  'portuguese': 38,
  'portugueseBrazil': 39,
  'romanian': 40,
  'russian': 41,
  'serbian': 42,
  'slovak': 43,
  'spanish': 44,
  'spanishLatinAmerica': 45,
  'swedish': 46,
  'tamil': 47,
  'telugu': 48,
  'thai': 49,
  'turkish': 50,
  'ukrainian': 51,
  'vietnamese': 52,
};
const _ContentFilterSettingsStoreoriginalLanguagesValueEnumMap = {
  0: Language.english,
  1: Language.albanian,
  2: Language.arabic,
  3: Language.azerbaijani,
  4: Language.bengali,
  5: Language.bulgarian,
  6: Language.burmese,
  7: Language.catalan,
  8: Language.chineseSimplified,
  9: Language.chineseTraditional,
  10: Language.croatian,
  11: Language.czech,
  12: Language.danish,
  13: Language.dutch,
  14: Language.esperanto,
  15: Language.estonian,
  16: Language.filipino,
  17: Language.finnish,
  18: Language.french,
  19: Language.georgian,
  20: Language.german,
  21: Language.greek,
  22: Language.hebrew,
  23: Language.hindi,
  24: Language.hungarian,
  25: Language.indonesian,
  26: Language.italian,
  27: Language.japanese,
  28: Language.kazakh,
  29: Language.korean,
  30: Language.latin,
  31: Language.lithuanian,
  32: Language.malay,
  33: Language.mongolian,
  34: Language.nepali,
  35: Language.norwegian,
  36: Language.persian,
  37: Language.polish,
  38: Language.portuguese,
  39: Language.portugueseBrazil,
  40: Language.romanian,
  41: Language.russian,
  42: Language.serbian,
  43: Language.slovak,
  44: Language.spanish,
  45: Language.spanishLatinAmerica,
  46: Language.swedish,
  47: Language.tamil,
  48: Language.telugu,
  49: Language.thai,
  50: Language.turkish,
  51: Language.ukrainian,
  52: Language.vietnamese,
};

Id _contentFilterSettingsStoreGetId(ContentFilterSettingsStore object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _contentFilterSettingsStoreGetLinks(
    ContentFilterSettingsStore object) {
  return [];
}

void _contentFilterSettingsStoreAttach(
    IsarCollection<dynamic> col, Id id, ContentFilterSettingsStore object) {}

extension ContentFilterSettingsStoreQueryWhereSort on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QWhere> {
  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ContentFilterSettingsStoreQueryWhere on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QWhereClause> {
  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
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

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
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

extension ContentFilterSettingsStoreQueryFilter on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QFilterCondition> {
  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesElementEqualTo(Language value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterLanguages',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesElementGreaterThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterLanguages',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesElementLessThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterLanguages',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesElementBetween(
    Language lower,
    Language upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterLanguages',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterLanguages',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterLanguages',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterLanguages',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterLanguages',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterLanguages',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> chapterLanguagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterLanguages',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsElementEqualTo(ContentRating value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentRatings',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsElementGreaterThan(
    ContentRating value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentRatings',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsElementLessThan(
    ContentRating value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentRatings',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsElementBetween(
    ContentRating lower,
    ContentRating upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentRatings',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentRatings',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentRatings',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentRatings',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentRatings',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentRatings',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> contentRatingsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentRatings',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
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

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
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

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
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

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesElementEqualTo(Language value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguages',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesElementGreaterThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalLanguages',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesElementLessThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalLanguages',
        value: value,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesElementBetween(
    Language lower,
    Language upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalLanguages',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originalLanguages',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originalLanguages',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originalLanguages',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originalLanguages',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originalLanguages',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterFilterCondition> originalLanguagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originalLanguages',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ContentFilterSettingsStoreQueryObject on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QFilterCondition> {}

extension ContentFilterSettingsStoreQueryLinks on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QFilterCondition> {}

extension ContentFilterSettingsStoreQuerySortBy on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QSortBy> {}

extension ContentFilterSettingsStoreQuerySortThenBy on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QSortThenBy> {
  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ContentFilterSettingsStoreQueryWhereDistinct on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QDistinct> {
  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QDistinct> distinctByChapterLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterLanguages');
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QDistinct> distinctByContentRatings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentRatings');
    });
  }

  QueryBuilder<ContentFilterSettingsStore, ContentFilterSettingsStore,
      QDistinct> distinctByOriginalLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalLanguages');
    });
  }
}

extension ContentFilterSettingsStoreQueryProperty on QueryBuilder<
    ContentFilterSettingsStore, ContentFilterSettingsStore, QQueryProperty> {
  QueryBuilder<ContentFilterSettingsStore, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ContentFilterSettingsStore, List<Language>, QQueryOperations>
      chapterLanguagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterLanguages');
    });
  }

  QueryBuilder<ContentFilterSettingsStore, List<ContentRating>,
      QQueryOperations> contentRatingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentRatings');
    });
  }

  QueryBuilder<ContentFilterSettingsStore, List<Language>, QQueryOperations>
      originalLanguagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalLanguages');
    });
  }
}
