// GENERATED CODE - DO NOT MODIFY BY HAND

part of "manga.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetMangaCollection on Isar {
  IsarCollection<Manga> get manga => this.collection();
}

const MangaSchema = CollectionSchema(
  name: r"Manga",
  id: -5643034226035087553,
  properties: {
    r"altTitles": PropertySchema(
      id: 0,
      name: r"altTitles",
      type: IsarType.objectList,
      target: r"Localizations",
    ),
    r"artistIds": PropertySchema(
      id: 1,
      name: r"artistIds",
      type: IsarType.stringList,
    ),
    r"authorIds": PropertySchema(
      id: 2,
      name: r"authorIds",
      type: IsarType.stringList,
    ),
    r"contentRating": PropertySchema(
      id: 3,
      name: r"contentRating",
      type: IsarType.byte,
      enumMap: _MangacontentRatingEnumValueMap,
    ),
    r"defaultCoverId": PropertySchema(
      id: 4,
      name: r"defaultCoverId",
      type: IsarType.string,
    ),
    r"description": PropertySchema(
      id: 5,
      name: r"description",
      type: IsarType.object,
      target: r"Localizations",
    ),
    r"id": PropertySchema(
      id: 6,
      name: r"id",
      type: IsarType.string,
    ),
    r"originalLanguage": PropertySchema(
      id: 7,
      name: r"originalLanguage",
      type: IsarType.byte,
      enumMap: _MangaoriginalLanguageEnumValueMap,
    ),
    r"preferredCoverId": PropertySchema(
      id: 8,
      name: r"preferredCoverId",
      type: IsarType.string,
    ),
    r"publicationDemographic": PropertySchema(
      id: 9,
      name: r"publicationDemographic",
      type: IsarType.byte,
      enumMap: _MangapublicationDemographicEnumValueMap,
    ),
    r"status": PropertySchema(
      id: 10,
      name: r"status",
      type: IsarType.byte,
      enumMap: _MangastatusEnumValueMap,
    ),
    r"tagsIds": PropertySchema(
      id: 11,
      name: r"tagsIds",
      type: IsarType.stringList,
    ),
    r"titles": PropertySchema(
      id: 12,
      name: r"titles",
      type: IsarType.object,
      target: r"Localizations",
    ),
    r"version": PropertySchema(
      id: 13,
      name: r"version",
      type: IsarType.long,
    )
  },
  estimateSize: _mangaEstimateSize,
  serialize: _mangaSerialize,
  deserialize: _mangaDeserialize,
  deserializeProp: _mangaDeserializeProp,
  idName: r"isarId",
  indexes: {
    r"authorIds": IndexSchema(
      id: -7996935101339351690,
      name: r"authorIds",
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r"authorIds",
          type: IndexType.hashElements,
          caseSensitive: true,
        )
      ],
    ),
    r"artistIds": IndexSchema(
      id: -1867997334466972802,
      name: r"artistIds",
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r"artistIds",
          type: IndexType.hashElements,
          caseSensitive: true,
        )
      ],
    ),
    r"tagsIds": IndexSchema(
      id: -8425780021134725086,
      name: r"tagsIds",
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r"tagsIds",
          type: IndexType.hashElements,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r"Localizations": LocalizationsSchema,
    r"Locale": LocaleSchema
  },
  getId: _mangaGetId,
  getLinks: _mangaGetLinks,
  attach: _mangaAttach,
  version: "3.0.5",
);

int _mangaEstimateSize(
  Manga object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.altTitles.length * 3;
  {
    final offsets = allOffsets[Localizations]!;
    for (var i = 0; i < object.altTitles.length; i++) {
      final value = object.altTitles[i];
      bytesCount +=
          LocalizationsSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.artistIds.length * 3;
  {
    for (var i = 0; i < object.artistIds.length; i++) {
      final value = object.artistIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.authorIds.length * 3;
  {
    for (var i = 0; i < object.authorIds.length; i++) {
      final value = object.authorIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.defaultCoverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 +
      LocalizationsSchema.estimateSize(
          object.description, allOffsets[Localizations]!, allOffsets);
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.preferredCoverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tagsIds.length * 3;
  {
    for (var i = 0; i < object.tagsIds.length; i++) {
      final value = object.tagsIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 +
      LocalizationsSchema.estimateSize(
          object.titles, allOffsets[Localizations]!, allOffsets);
  return bytesCount;
}

void _mangaSerialize(
  Manga object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Localizations>(
    offsets[0],
    allOffsets,
    LocalizationsSchema.serialize,
    object.altTitles,
  );
  writer.writeStringList(offsets[1], object.artistIds);
  writer.writeStringList(offsets[2], object.authorIds);
  writer.writeByte(offsets[3], object.contentRating.index);
  writer.writeString(offsets[4], object.defaultCoverId);
  writer.writeObject<Localizations>(
    offsets[5],
    allOffsets,
    LocalizationsSchema.serialize,
    object.description,
  );
  writer.writeString(offsets[6], object.id);
  writer.writeByte(offsets[7], object.originalLanguage.index);
  writer.writeString(offsets[8], object.preferredCoverId);
  writer.writeByte(offsets[9], object.publicationDemographic.index);
  writer.writeByte(offsets[10], object.status.index);
  writer.writeStringList(offsets[11], object.tagsIds);
  writer.writeObject<Localizations>(
    offsets[12],
    allOffsets,
    LocalizationsSchema.serialize,
    object.titles,
  );
  writer.writeLong(offsets[13], object.version);
}

Manga _mangaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Manga(
    altTitles: reader.readObjectList<Localizations>(
          offsets[0],
          LocalizationsSchema.deserialize,
          allOffsets,
          Localizations(),
        ) ??
        [],
    artistIds: reader.readStringList(offsets[1]) ?? [],
    authorIds: reader.readStringList(offsets[2]) ?? [],
    contentRating:
        _MangacontentRatingValueEnumMap[reader.readByteOrNull(offsets[3])] ??
            MangaContentRating.safe,
    defaultCoverId: reader.readStringOrNull(offsets[4]),
    description: reader.readObjectOrNull<Localizations>(
          offsets[5],
          LocalizationsSchema.deserialize,
          allOffsets,
        ) ??
        Localizations(),
    id: reader.readString(offsets[6]),
    originalLanguage:
        _MangaoriginalLanguageValueEnumMap[reader.readByteOrNull(offsets[7])] ??
            Language.none,
    preferredCoverId: reader.readStringOrNull(offsets[8]),
    publicationDemographic: _MangapublicationDemographicValueEnumMap[
            reader.readByteOrNull(offsets[9])] ??
        MangaPublicationDemographic.unknown,
    status: _MangastatusValueEnumMap[reader.readByteOrNull(offsets[10])] ??
        MangaStatus.ongoing,
    tagsIds: reader.readStringList(offsets[11]) ?? [],
    titles: reader.readObjectOrNull<Localizations>(
          offsets[12],
          LocalizationsSchema.deserialize,
          allOffsets,
        ) ??
        Localizations(),
    version: reader.readLong(offsets[13]),
  );
  return object;
}

P _mangaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Localizations>(
            offset,
            LocalizationsSchema.deserialize,
            allOffsets,
            Localizations(),
          ) ??
          []) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (_MangacontentRatingValueEnumMap[reader.readByteOrNull(offset)] ??
          MangaContentRating.safe) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<Localizations>(
            offset,
            LocalizationsSchema.deserialize,
            allOffsets,
          ) ??
          Localizations()) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (_MangaoriginalLanguageValueEnumMap[
              reader.readByteOrNull(offset)] ??
          Language.none) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_MangapublicationDemographicValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MangaPublicationDemographic.unknown) as P;
    case 10:
      return (_MangastatusValueEnumMap[reader.readByteOrNull(offset)] ??
          MangaStatus.ongoing) as P;
    case 11:
      return (reader.readStringList(offset) ?? []) as P;
    case 12:
      return (reader.readObjectOrNull<Localizations>(
            offset,
            LocalizationsSchema.deserialize,
            allOffsets,
          ) ??
          Localizations()) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _MangacontentRatingEnumValueMap = {
  "safe": 0,
  "suggestive": 1,
  "erotica": 2,
  "pornographic": 3,
};
const _MangacontentRatingValueEnumMap = {
  0: MangaContentRating.safe,
  1: MangaContentRating.suggestive,
  2: MangaContentRating.erotica,
  3: MangaContentRating.pornographic,
};
const _MangaoriginalLanguageEnumValueMap = {
  "none": 0,
  "english": 1,
  "japanese": 2,
  "simpleChinese": 3,
  "traditionalChinese": 4,
  "korean": 5,
  "french": 6,
  "russian": 7,
  "vietnamese": 8,
  "portugueseBrazil": 9,
  "indonesian": 10,
};
const _MangaoriginalLanguageValueEnumMap = {
  0: Language.none,
  1: Language.english,
  2: Language.japanese,
  3: Language.simpleChinese,
  4: Language.traditionalChinese,
  5: Language.korean,
  6: Language.french,
  7: Language.russian,
  8: Language.vietnamese,
  9: Language.portugueseBrazil,
  10: Language.indonesian,
};
const _MangapublicationDemographicEnumValueMap = {
  "unknown": 0,
  "shounen": 1,
  "shoujo": 2,
  "josei": 3,
  "seinen": 4,
};
const _MangapublicationDemographicValueEnumMap = {
  0: MangaPublicationDemographic.unknown,
  1: MangaPublicationDemographic.shounen,
  2: MangaPublicationDemographic.shoujo,
  3: MangaPublicationDemographic.josei,
  4: MangaPublicationDemographic.seinen,
};
const _MangastatusEnumValueMap = {
  "ongoing": 0,
  "completed": 1,
  "hiatus": 2,
  "cancelled": 3,
};
const _MangastatusValueEnumMap = {
  0: MangaStatus.ongoing,
  1: MangaStatus.completed,
  2: MangaStatus.hiatus,
  3: MangaStatus.cancelled,
};

Id _mangaGetId(Manga object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _mangaGetLinks(Manga object) {
  return [];
}

void _mangaAttach(IsarCollection<dynamic> col, Id id, Manga object) {}

extension MangaQueryWhereSort on QueryBuilder<Manga, Manga, QWhere> {
  QueryBuilder<Manga, Manga, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MangaQueryWhere on QueryBuilder<Manga, Manga, QWhereClause> {
  QueryBuilder<Manga, Manga, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Manga, Manga, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Manga, Manga, QAfterWhereClause> authorIdsElementEqualTo(
      String authorIdsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"authorIds",
        value: [authorIdsElement],
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterWhereClause> authorIdsElementNotEqualTo(
      String authorIdsElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"authorIds",
              lower: [],
              upper: [authorIdsElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"authorIds",
              lower: [authorIdsElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"authorIds",
              lower: [authorIdsElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"authorIds",
              lower: [],
              upper: [authorIdsElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Manga, Manga, QAfterWhereClause> artistIdsElementEqualTo(
      String artistIdsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"artistIds",
        value: [artistIdsElement],
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterWhereClause> artistIdsElementNotEqualTo(
      String artistIdsElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"artistIds",
              lower: [],
              upper: [artistIdsElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"artistIds",
              lower: [artistIdsElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"artistIds",
              lower: [artistIdsElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"artistIds",
              lower: [],
              upper: [artistIdsElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Manga, Manga, QAfterWhereClause> tagsIdsElementEqualTo(
      String tagsIdsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"tagsIds",
        value: [tagsIdsElement],
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterWhereClause> tagsIdsElementNotEqualTo(
      String tagsIdsElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"tagsIds",
              lower: [],
              upper: [tagsIdsElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"tagsIds",
              lower: [tagsIdsElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"tagsIds",
              lower: [tagsIdsElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"tagsIds",
              lower: [],
              upper: [tagsIdsElement],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MangaQueryFilter on QueryBuilder<Manga, Manga, QFilterCondition> {
  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altTitles",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altTitles",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altTitles",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altTitles",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altTitles",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altTitles",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"artistIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"artistIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"artistIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"artistIds",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"artistIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"artistIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"artistIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"artistIds",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"artistIds",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition>
      artistIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"artistIds",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"artistIds",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"artistIds",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"artistIds",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"artistIds",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"artistIds",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> artistIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"artistIds",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"authorIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"authorIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"authorIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"authorIds",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"authorIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"authorIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"authorIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"authorIds",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"authorIds",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition>
      authorIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"authorIds",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authorIds",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authorIds",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authorIds",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authorIds",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authorIds",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authorIds",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> contentRatingEqualTo(
      MangaContentRating value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"contentRating",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> contentRatingGreaterThan(
    MangaContentRating value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"contentRating",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> contentRatingLessThan(
    MangaContentRating value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"contentRating",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> contentRatingBetween(
    MangaContentRating lower,
    MangaContentRating upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"contentRating",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"defaultCoverId",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"defaultCoverId",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"defaultCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"defaultCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"defaultCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"defaultCoverId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"defaultCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"defaultCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"defaultCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"defaultCoverId",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"defaultCoverId",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> defaultCoverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"defaultCoverId",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"id",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> originalLanguageEqualTo(
      Language value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"originalLanguage",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> originalLanguageGreaterThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"originalLanguage",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> originalLanguageLessThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"originalLanguage",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> originalLanguageBetween(
    Language lower,
    Language upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"originalLanguage",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"preferredCoverId",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition>
      preferredCoverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"preferredCoverId",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"preferredCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"preferredCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"preferredCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"preferredCoverId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"preferredCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"preferredCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"preferredCoverId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"preferredCoverId",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> preferredCoverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"preferredCoverId",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition>
      preferredCoverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"preferredCoverId",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition>
      publicationDemographicEqualTo(MangaPublicationDemographic value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"publicationDemographic",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition>
      publicationDemographicGreaterThan(
    MangaPublicationDemographic value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"publicationDemographic",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition>
      publicationDemographicLessThan(
    MangaPublicationDemographic value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"publicationDemographic",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition>
      publicationDemographicBetween(
    MangaPublicationDemographic lower,
    MangaPublicationDemographic upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"publicationDemographic",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> statusEqualTo(
      MangaStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"status",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> statusGreaterThan(
    MangaStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"status",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> statusLessThan(
    MangaStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"status",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> statusBetween(
    MangaStatus lower,
    MangaStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"status",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"tagsIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"tagsIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"tagsIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"tagsIds",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"tagsIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"tagsIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"tagsIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"tagsIds",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"tagsIds",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"tagsIds",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"tagsIds",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"tagsIds",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"tagsIds",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"tagsIds",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"tagsIds",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> tagsIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"tagsIds",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"version",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"version",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"version",
        value: value,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"version",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MangaQueryObject on QueryBuilder<Manga, Manga, QFilterCondition> {
  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesElement(
      FilterQuery<Localizations> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"altTitles");
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> description(
      FilterQuery<Localizations> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"description");
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> titles(
      FilterQuery<Localizations> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"titles");
    });
  }
}

extension MangaQueryLinks on QueryBuilder<Manga, Manga, QFilterCondition> {}

extension MangaQuerySortBy on QueryBuilder<Manga, Manga, QSortBy> {
  QueryBuilder<Manga, Manga, QAfterSortBy> sortByContentRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"contentRating", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByContentRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"contentRating", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByDefaultCoverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"defaultCoverId", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByDefaultCoverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"defaultCoverId", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"originalLanguage", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"originalLanguage", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByPreferredCoverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"preferredCoverId", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByPreferredCoverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"preferredCoverId", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByPublicationDemographic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"publicationDemographic", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByPublicationDemographicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"publicationDemographic", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"status", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"status", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }
}

extension MangaQuerySortThenBy on QueryBuilder<Manga, Manga, QSortThenBy> {
  QueryBuilder<Manga, Manga, QAfterSortBy> thenByContentRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"contentRating", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByContentRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"contentRating", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByDefaultCoverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"defaultCoverId", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByDefaultCoverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"defaultCoverId", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"originalLanguage", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"originalLanguage", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByPreferredCoverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"preferredCoverId", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByPreferredCoverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"preferredCoverId", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByPublicationDemographic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"publicationDemographic", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByPublicationDemographicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"publicationDemographic", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"status", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"status", Sort.desc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<Manga, Manga, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }
}

extension MangaQueryWhereDistinct on QueryBuilder<Manga, Manga, QDistinct> {
  QueryBuilder<Manga, Manga, QDistinct> distinctByArtistIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"artistIds");
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByAuthorIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"authorIds");
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByContentRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"contentRating");
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByDefaultCoverId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"defaultCoverId",
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"originalLanguage");
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByPreferredCoverId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"preferredCoverId",
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByPublicationDemographic() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"publicationDemographic");
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"status");
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByTagsIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"tagsIds");
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"version");
    });
  }
}

extension MangaQueryProperty on QueryBuilder<Manga, Manga, QQueryProperty> {
  QueryBuilder<Manga, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<Manga, List<Localizations>, QQueryOperations>
      altTitlesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"altTitles");
    });
  }

  QueryBuilder<Manga, List<String>, QQueryOperations> artistIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"artistIds");
    });
  }

  QueryBuilder<Manga, List<String>, QQueryOperations> authorIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"authorIds");
    });
  }

  QueryBuilder<Manga, MangaContentRating, QQueryOperations>
      contentRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"contentRating");
    });
  }

  QueryBuilder<Manga, String?, QQueryOperations> defaultCoverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"defaultCoverId");
    });
  }

  QueryBuilder<Manga, Localizations, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"description");
    });
  }

  QueryBuilder<Manga, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<Manga, Language, QQueryOperations> originalLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"originalLanguage");
    });
  }

  QueryBuilder<Manga, String?, QQueryOperations> preferredCoverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"preferredCoverId");
    });
  }

  QueryBuilder<Manga, MangaPublicationDemographic, QQueryOperations>
      publicationDemographicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"publicationDemographic");
    });
  }

  QueryBuilder<Manga, MangaStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"status");
    });
  }

  QueryBuilder<Manga, List<String>, QQueryOperations> tagsIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"tagsIds");
    });
  }

  QueryBuilder<Manga, Localizations, QQueryOperations> titlesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"titles");
    });
  }

  QueryBuilder<Manga, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"version");
    });
  }
}
