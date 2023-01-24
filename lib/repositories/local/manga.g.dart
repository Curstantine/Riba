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
    r"authors": PropertySchema(
      id: 1,
      name: r"authors",
      type: IsarType.stringList,
    ),
    r"description": PropertySchema(
      id: 2,
      name: r"description",
      type: IsarType.object,
      target: r"Localizations",
    ),
    r"id": PropertySchema(
      id: 3,
      name: r"id",
      type: IsarType.string,
    ),
    r"originalLocale": PropertySchema(
      id: 4,
      name: r"originalLocale",
      type: IsarType.object,
      target: r"Locale",
    ),
    r"titles": PropertySchema(
      id: 5,
      name: r"titles",
      type: IsarType.object,
      target: r"Localizations",
    )
  },
  estimateSize: _mangaEstimateSize,
  serialize: _mangaSerialize,
  deserialize: _mangaDeserialize,
  deserializeProp: _mangaDeserializeProp,
  idName: r"isarId",
  indexes: {},
  links: {},
  embeddedSchemas: {r"Localizations": LocalizationsSchema, r"Locale": LocaleSchema},
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
      bytesCount += LocalizationsSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.authors.length * 3;
  {
    for (var i = 0; i < object.authors.length; i++) {
      final value = object.authors[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 +
      LocalizationsSchema.estimateSize(object.description, allOffsets[Localizations]!, allOffsets);
  bytesCount += 3 + object.id.length * 3;
  bytesCount +=
      3 + LocaleSchema.estimateSize(object.originalLocale, allOffsets[Locale]!, allOffsets);
  bytesCount +=
      3 + LocalizationsSchema.estimateSize(object.titles, allOffsets[Localizations]!, allOffsets);
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
  writer.writeStringList(offsets[1], object.authors);
  writer.writeObject<Localizations>(
    offsets[2],
    allOffsets,
    LocalizationsSchema.serialize,
    object.description,
  );
  writer.writeString(offsets[3], object.id);
  writer.writeObject<Locale>(
    offsets[4],
    allOffsets,
    LocaleSchema.serialize,
    object.originalLocale,
  );
  writer.writeObject<Localizations>(
    offsets[5],
    allOffsets,
    LocalizationsSchema.serialize,
    object.titles,
  );
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
    authors: reader.readStringList(offsets[1]) ?? [],
    description: reader.readObjectOrNull<Localizations>(
          offsets[2],
          LocalizationsSchema.deserialize,
          allOffsets,
        ) ??
        Localizations(),
    id: reader.readString(offsets[3]),
    originalLocale: reader.readObjectOrNull<Locale>(
          offsets[4],
          LocaleSchema.deserialize,
          allOffsets,
        ) ??
        Locale(),
    titles: reader.readObjectOrNull<Localizations>(
          offsets[5],
          LocalizationsSchema.deserialize,
          allOffsets,
        ) ??
        Localizations(),
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
      return (reader.readObjectOrNull<Localizations>(
            offset,
            LocalizationsSchema.deserialize,
            allOffsets,
          ) ??
          Localizations()) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readObjectOrNull<Locale>(
            offset,
            LocaleSchema.deserialize,
            allOffsets,
          ) ??
          Locale()) as P;
    case 5:
      return (reader.readObjectOrNull<Localizations>(
            offset,
            LocalizationsSchema.deserialize,
            allOffsets,
          ) ??
          Localizations()) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

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

  QueryBuilder<Manga, Manga, QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
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
}

extension MangaQueryFilter on QueryBuilder<Manga, Manga, QFilterCondition> {
  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesLengthEqualTo(int length) {
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

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"authors",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"authors",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"authors",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"authors",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"authors",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"authors",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"authors",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"authors",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"authors",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"authors",
        value: "",
      ));
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authors",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authors",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authors",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authors",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authors",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> authorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"authors",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
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
}

extension MangaQueryObject on QueryBuilder<Manga, Manga, QFilterCondition> {
  QueryBuilder<Manga, Manga, QAfterFilterCondition> altTitlesElement(FilterQuery<Localizations> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"altTitles");
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> description(FilterQuery<Localizations> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"description");
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> originalLocale(FilterQuery<Locale> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"originalLocale");
    });
  }

  QueryBuilder<Manga, Manga, QAfterFilterCondition> titles(FilterQuery<Localizations> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"titles");
    });
  }
}

extension MangaQueryLinks on QueryBuilder<Manga, Manga, QFilterCondition> {}

extension MangaQuerySortBy on QueryBuilder<Manga, Manga, QSortBy> {
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
}

extension MangaQuerySortThenBy on QueryBuilder<Manga, Manga, QSortThenBy> {
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
}

extension MangaQueryWhereDistinct on QueryBuilder<Manga, Manga, QDistinct> {
  QueryBuilder<Manga, Manga, QDistinct> distinctByAuthors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"authors");
    });
  }

  QueryBuilder<Manga, Manga, QDistinct> distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }
}

extension MangaQueryProperty on QueryBuilder<Manga, Manga, QQueryProperty> {
  QueryBuilder<Manga, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<Manga, List<Localizations>, QQueryOperations> altTitlesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"altTitles");
    });
  }

  QueryBuilder<Manga, List<String>, QQueryOperations> authorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"authors");
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

  QueryBuilder<Manga, Locale, QQueryOperations> originalLocaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"originalLocale");
    });
  }

  QueryBuilder<Manga, Localizations, QQueryOperations> titlesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"titles");
    });
  }
}
