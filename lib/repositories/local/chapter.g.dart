// GENERATED CODE - DO NOT MODIFY BY HAND

part of "chapter.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetChapterCollection on Isar {
  IsarCollection<Chapter> get chapters => this.collection();
}

const ChapterSchema = CollectionSchema(
  name: r"Chapter",
  id: -7604549436611156012,
  properties: {
    r"chapter": PropertySchema(
      id: 0,
      name: r"chapter",
      type: IsarType.string,
    ),
    r"createdAt": PropertySchema(
      id: 1,
      name: r"createdAt",
      type: IsarType.dateTime,
    ),
    r"externalUrl": PropertySchema(
      id: 2,
      name: r"externalUrl",
      type: IsarType.string,
    ),
    r"groupIds": PropertySchema(
      id: 3,
      name: r"groupIds",
      type: IsarType.stringList,
    ),
    r"id": PropertySchema(
      id: 4,
      name: r"id",
      type: IsarType.string,
    ),
    r"mangaId": PropertySchema(
      id: 5,
      name: r"mangaId",
      type: IsarType.string,
    ),
    r"pages": PropertySchema(
      id: 6,
      name: r"pages",
      type: IsarType.long,
    ),
    r"publishAt": PropertySchema(
      id: 7,
      name: r"publishAt",
      type: IsarType.dateTime,
    ),
    r"readableAt": PropertySchema(
      id: 8,
      name: r"readableAt",
      type: IsarType.dateTime,
    ),
    r"title": PropertySchema(
      id: 9,
      name: r"title",
      type: IsarType.string,
    ),
    r"translatedLanguage": PropertySchema(
      id: 10,
      name: r"translatedLanguage",
      type: IsarType.object,
      target: r"Locale",
    ),
    r"updatedAt": PropertySchema(
      id: 11,
      name: r"updatedAt",
      type: IsarType.dateTime,
    ),
    r"uploaderId": PropertySchema(
      id: 12,
      name: r"uploaderId",
      type: IsarType.string,
    ),
    r"version": PropertySchema(
      id: 13,
      name: r"version",
      type: IsarType.long,
    ),
    r"volume": PropertySchema(
      id: 14,
      name: r"volume",
      type: IsarType.string,
    )
  },
  estimateSize: _chapterEstimateSize,
  serialize: _chapterSerialize,
  deserialize: _chapterDeserialize,
  deserializeProp: _chapterDeserializeProp,
  idName: r"isarId",
  indexes: {
    r"mangaId": IndexSchema(
      id: 7466570075891278896,
      name: r"mangaId",
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r"mangaId",
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r"uploaderId": IndexSchema(
      id: -2905442145074141949,
      name: r"uploaderId",
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r"uploaderId",
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r"groupIds": IndexSchema(
      id: 336612842135500568,
      name: r"groupIds",
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r"groupIds",
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r"Locale": LocaleSchema},
  getId: _chapterGetId,
  getLinks: _chapterGetLinks,
  attach: _chapterAttach,
  version: "3.0.5",
);

int _chapterEstimateSize(
  Chapter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.chapter;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.externalUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.groupIds.length * 3;
  {
    for (var i = 0; i < object.groupIds.length; i++) {
      final value = object.groupIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.mangaId.length * 3;
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 +
      LocaleSchema.estimateSize(
          object.translatedLanguage, allOffsets[Locale]!, allOffsets);
  bytesCount += 3 + object.uploaderId.length * 3;
  {
    final value = object.volume;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _chapterSerialize(
  Chapter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chapter);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.externalUrl);
  writer.writeStringList(offsets[3], object.groupIds);
  writer.writeString(offsets[4], object.id);
  writer.writeString(offsets[5], object.mangaId);
  writer.writeLong(offsets[6], object.pages);
  writer.writeDateTime(offsets[7], object.publishAt);
  writer.writeDateTime(offsets[8], object.readableAt);
  writer.writeString(offsets[9], object.title);
  writer.writeObject<Locale>(
    offsets[10],
    allOffsets,
    LocaleSchema.serialize,
    object.translatedLanguage,
  );
  writer.writeDateTime(offsets[11], object.updatedAt);
  writer.writeString(offsets[12], object.uploaderId);
  writer.writeLong(offsets[13], object.version);
  writer.writeString(offsets[14], object.volume);
}

Chapter _chapterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Chapter(
    chapter: reader.readStringOrNull(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    externalUrl: reader.readStringOrNull(offsets[2]),
    groupIds: reader.readStringList(offsets[3]) ?? [],
    id: reader.readString(offsets[4]),
    mangaId: reader.readString(offsets[5]),
    pages: reader.readLong(offsets[6]),
    publishAt: reader.readDateTime(offsets[7]),
    readableAt: reader.readDateTime(offsets[8]),
    title: reader.readStringOrNull(offsets[9]),
    translatedLanguage: reader.readObjectOrNull<Locale>(
          offsets[10],
          LocaleSchema.deserialize,
          allOffsets,
        ) ??
        Locale(),
    updatedAt: reader.readDateTime(offsets[11]),
    uploaderId: reader.readString(offsets[12]),
    version: reader.readLong(offsets[13]),
    volume: reader.readStringOrNull(offsets[14]),
  );
  return object;
}

P _chapterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readObjectOrNull<Locale>(
            offset,
            LocaleSchema.deserialize,
            allOffsets,
          ) ??
          Locale()) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

Id _chapterGetId(Chapter object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _chapterGetLinks(Chapter object) {
  return [];
}

void _chapterAttach(IsarCollection<dynamic> col, Id id, Chapter object) {}

extension ChapterQueryWhereSort on QueryBuilder<Chapter, Chapter, QWhere> {
  QueryBuilder<Chapter, Chapter, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChapterQueryWhere on QueryBuilder<Chapter, Chapter, QWhereClause> {
  QueryBuilder<Chapter, Chapter, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> mangaIdEqualTo(
      String mangaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"mangaId",
        value: [mangaId],
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> mangaIdNotEqualTo(
      String mangaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"mangaId",
              lower: [],
              upper: [mangaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"mangaId",
              lower: [mangaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"mangaId",
              lower: [mangaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"mangaId",
              lower: [],
              upper: [mangaId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> uploaderIdEqualTo(
      String uploaderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"uploaderId",
        value: [uploaderId],
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> uploaderIdNotEqualTo(
      String uploaderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"uploaderId",
              lower: [],
              upper: [uploaderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"uploaderId",
              lower: [uploaderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"uploaderId",
              lower: [uploaderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"uploaderId",
              lower: [],
              upper: [uploaderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> groupIdsEqualTo(
      List<String> groupIds) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"groupIds",
        value: [groupIds],
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterWhereClause> groupIdsNotEqualTo(
      List<String> groupIds) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"groupIds",
              lower: [],
              upper: [groupIds],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"groupIds",
              lower: [groupIds],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"groupIds",
              lower: [groupIds],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"groupIds",
              lower: [],
              upper: [groupIds],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ChapterQueryFilter
    on QueryBuilder<Chapter, Chapter, QFilterCondition> {
  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"chapter",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"chapter",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"chapter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"chapter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"chapter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"chapter",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"chapter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"chapter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"chapter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"chapter",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"chapter",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> chapterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"chapter",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"createdAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"createdAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"createdAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"createdAt",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"externalUrl",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"externalUrl",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"externalUrl",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"externalUrl",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"externalUrl",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"externalUrl",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"externalUrl",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"externalUrl",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"externalUrl",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"externalUrl",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> externalUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"externalUrl",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition>
      externalUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"externalUrl",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"groupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition>
      groupIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"groupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"groupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"groupIds",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition>
      groupIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"groupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"groupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"groupIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"groupIds",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition>
      groupIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"groupIds",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition>
      groupIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"groupIds",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"groupIds",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"groupIds",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"groupIds",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"groupIds",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition>
      groupIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"groupIds",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> groupIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"groupIds",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"id",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"mangaId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"mangaId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"mangaId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"mangaId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"mangaId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"mangaId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"mangaId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"mangaId",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"mangaId",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> mangaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"mangaId",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> pagesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"pages",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> pagesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"pages",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> pagesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"pages",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> pagesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"pages",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> publishAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"publishAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> publishAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"publishAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> publishAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"publishAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> publishAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"publishAt",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> readableAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"readableAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> readableAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"readableAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> readableAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"readableAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> readableAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"readableAt",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"title",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"title",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"title",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"title",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"title",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"title",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"title",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"title",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"title",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"title",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"title",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"title",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"updatedAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"updatedAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"updatedAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"updatedAt",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"uploaderId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"uploaderId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"uploaderId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"uploaderId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"uploaderId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"uploaderId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"uploaderId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"uploaderId",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"uploaderId",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> uploaderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"uploaderId",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> versionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"version",
        value: value,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> versionGreaterThan(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> versionLessThan(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> versionBetween(
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

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"volume",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"volume",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"volume",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"volume",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"volume",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"volume",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"volume",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"volume",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"volume",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"volume",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"volume",
        value: "",
      ));
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> volumeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"volume",
        value: "",
      ));
    });
  }
}

extension ChapterQueryObject
    on QueryBuilder<Chapter, Chapter, QFilterCondition> {
  QueryBuilder<Chapter, Chapter, QAfterFilterCondition> translatedLanguage(
      FilterQuery<Locale> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"translatedLanguage");
    });
  }
}

extension ChapterQueryLinks
    on QueryBuilder<Chapter, Chapter, QFilterCondition> {}

extension ChapterQuerySortBy on QueryBuilder<Chapter, Chapter, QSortBy> {
  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"chapter", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"chapter", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByExternalUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"externalUrl", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByExternalUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"externalUrl", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"mangaId", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"mangaId", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"pages", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"pages", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByPublishAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"publishAt", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByPublishAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"publishAt", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByReadableAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"readableAt", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByReadableAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"readableAt", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"title", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"title", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByUploaderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"uploaderId", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByUploaderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"uploaderId", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"volume", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> sortByVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"volume", Sort.desc);
    });
  }
}

extension ChapterQuerySortThenBy
    on QueryBuilder<Chapter, Chapter, QSortThenBy> {
  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"chapter", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"chapter", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByExternalUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"externalUrl", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByExternalUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"externalUrl", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"mangaId", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"mangaId", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"pages", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"pages", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByPublishAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"publishAt", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByPublishAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"publishAt", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByReadableAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"readableAt", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByReadableAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"readableAt", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"title", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"title", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByUploaderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"uploaderId", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByUploaderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"uploaderId", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"volume", Sort.asc);
    });
  }

  QueryBuilder<Chapter, Chapter, QAfterSortBy> thenByVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"volume", Sort.desc);
    });
  }
}

extension ChapterQueryWhereDistinct
    on QueryBuilder<Chapter, Chapter, QDistinct> {
  QueryBuilder<Chapter, Chapter, QDistinct> distinctByChapter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"chapter", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"createdAt");
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByExternalUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"externalUrl", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByGroupIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"groupIds");
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByMangaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"mangaId", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"pages");
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByPublishAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"publishAt");
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByReadableAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"readableAt");
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"title", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"updatedAt");
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByUploaderId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"uploaderId", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"version");
    });
  }

  QueryBuilder<Chapter, Chapter, QDistinct> distinctByVolume(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"volume", caseSensitive: caseSensitive);
    });
  }
}

extension ChapterQueryProperty
    on QueryBuilder<Chapter, Chapter, QQueryProperty> {
  QueryBuilder<Chapter, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<Chapter, String?, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"chapter");
    });
  }

  QueryBuilder<Chapter, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"createdAt");
    });
  }

  QueryBuilder<Chapter, String?, QQueryOperations> externalUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"externalUrl");
    });
  }

  QueryBuilder<Chapter, List<String>, QQueryOperations> groupIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"groupIds");
    });
  }

  QueryBuilder<Chapter, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<Chapter, String, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"mangaId");
    });
  }

  QueryBuilder<Chapter, int, QQueryOperations> pagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"pages");
    });
  }

  QueryBuilder<Chapter, DateTime, QQueryOperations> publishAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"publishAt");
    });
  }

  QueryBuilder<Chapter, DateTime, QQueryOperations> readableAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"readableAt");
    });
  }

  QueryBuilder<Chapter, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"title");
    });
  }

  QueryBuilder<Chapter, Locale, QQueryOperations> translatedLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"translatedLanguage");
    });
  }

  QueryBuilder<Chapter, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"updatedAt");
    });
  }

  QueryBuilder<Chapter, String, QQueryOperations> uploaderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"uploaderId");
    });
  }

  QueryBuilder<Chapter, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"version");
    });
  }

  QueryBuilder<Chapter, String?, QQueryOperations> volumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"volume");
    });
  }
}
