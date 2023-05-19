// GENERATED CODE - DO NOT MODIFY BY HAND

part of "statistics.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStatisticsCollection on Isar {
  IsarCollection<Statistics> get statistics => this.collection();
}

const StatisticsSchema = CollectionSchema(
  name: r"Statistics",
  id: -3012562703602652036,
  properties: {
    r"comments": PropertySchema(
      id: 0,
      name: r"comments",
      type: IsarType.object,
      target: r"CommentStatistics",
    ),
    r"follows": PropertySchema(
      id: 1,
      name: r"follows",
      type: IsarType.long,
    ),
    r"id": PropertySchema(
      id: 2,
      name: r"id",
      type: IsarType.string,
    ),
    r"rating": PropertySchema(
      id: 3,
      name: r"rating",
      type: IsarType.object,
      target: r"RatingStatistics",
    ),
    r"type": PropertySchema(
      id: 4,
      name: r"type",
      type: IsarType.byte,
      enumMap: _StatisticstypeEnumValueMap,
    )
  },
  estimateSize: _statisticsEstimateSize,
  serialize: _statisticsSerialize,
  deserialize: _statisticsDeserialize,
  deserializeProp: _statisticsDeserializeProp,
  idName: r"isarId",
  indexes: {},
  links: {},
  embeddedSchemas: {
    r"CommentStatistics": CommentStatisticsSchema,
    r"RatingStatistics": RatingStatisticsSchema
  },
  getId: _statisticsGetId,
  getLinks: _statisticsGetLinks,
  attach: _statisticsAttach,
  version: "3.1.0+1",
);

int _statisticsEstimateSize(
  Statistics object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.comments;
    if (value != null) {
      bytesCount += 3 +
          CommentStatisticsSchema.estimateSize(
              value, allOffsets[CommentStatistics]!, allOffsets);
    }
  }
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.rating;
    if (value != null) {
      bytesCount += 3 +
          RatingStatisticsSchema.estimateSize(
              value, allOffsets[RatingStatistics]!, allOffsets);
    }
  }
  return bytesCount;
}

void _statisticsSerialize(
  Statistics object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<CommentStatistics>(
    offsets[0],
    allOffsets,
    CommentStatisticsSchema.serialize,
    object.comments,
  );
  writer.writeLong(offsets[1], object.follows);
  writer.writeString(offsets[2], object.id);
  writer.writeObject<RatingStatistics>(
    offsets[3],
    allOffsets,
    RatingStatisticsSchema.serialize,
    object.rating,
  );
  writer.writeByte(offsets[4], object.type.index);
}

Statistics _statisticsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Statistics(
    comments: reader.readObjectOrNull<CommentStatistics>(
      offsets[0],
      CommentStatisticsSchema.deserialize,
      allOffsets,
    ),
    follows: reader.readLongOrNull(offsets[1]),
    id: reader.readString(offsets[2]),
    rating: reader.readObjectOrNull<RatingStatistics>(
      offsets[3],
      RatingStatisticsSchema.deserialize,
      allOffsets,
    ),
    type: _StatisticstypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
        EntityType.manga,
  );
  return object;
}

P _statisticsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<CommentStatistics>(
        offset,
        CommentStatisticsSchema.deserialize,
        allOffsets,
      )) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<RatingStatistics>(
        offset,
        RatingStatisticsSchema.deserialize,
        allOffsets,
      )) as P;
    case 4:
      return (_StatisticstypeValueEnumMap[reader.readByteOrNull(offset)] ??
          EntityType.manga) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _StatisticstypeEnumValueMap = {
  "manga": 0,
  "chapter": 1,
  "customList": 2,
  "author": 3,
  "artist": 4,
  "user": 5,
  "tag": 6,
  "coverArt": 7,
  "scanlationGroup": 8,
  "leader": 9,
  "member": 10,
  "creator": 11,
};
const _StatisticstypeValueEnumMap = {
  0: EntityType.manga,
  1: EntityType.chapter,
  2: EntityType.customList,
  3: EntityType.author,
  4: EntityType.artist,
  5: EntityType.user,
  6: EntityType.tag,
  7: EntityType.coverArt,
  8: EntityType.scanlationGroup,
  9: EntityType.leader,
  10: EntityType.member,
  11: EntityType.creator,
};

Id _statisticsGetId(Statistics object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _statisticsGetLinks(Statistics object) {
  return [];
}

void _statisticsAttach(IsarCollection<dynamic> col, Id id, Statistics object) {}

extension StatisticsQueryWhereSort
    on QueryBuilder<Statistics, Statistics, QWhere> {
  QueryBuilder<Statistics, Statistics, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StatisticsQueryWhere
    on QueryBuilder<Statistics, Statistics, QWhereClause> {
  QueryBuilder<Statistics, Statistics, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> isarIdBetween(
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

extension StatisticsQueryFilter
    on QueryBuilder<Statistics, Statistics, QFilterCondition> {
  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> commentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"comments",
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      commentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"comments",
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> followsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"follows",
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      followsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"follows",
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> followsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"follows",
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      followsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"follows",
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> followsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"follows",
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> followsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"follows",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idMatches(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> ratingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"rating",
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      ratingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"rating",
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> typeEqualTo(
      EntityType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"type",
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> typeGreaterThan(
    EntityType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"type",
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> typeLessThan(
    EntityType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"type",
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> typeBetween(
    EntityType lower,
    EntityType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"type",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StatisticsQueryObject
    on QueryBuilder<Statistics, Statistics, QFilterCondition> {
  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> comments(
      FilterQuery<CommentStatistics> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"comments");
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> rating(
      FilterQuery<RatingStatistics> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"rating");
    });
  }
}

extension StatisticsQueryLinks
    on QueryBuilder<Statistics, Statistics, QFilterCondition> {}

extension StatisticsQuerySortBy
    on QueryBuilder<Statistics, Statistics, QSortBy> {
  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByFollows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"follows", Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByFollowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"follows", Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"type", Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"type", Sort.desc);
    });
  }
}

extension StatisticsQuerySortThenBy
    on QueryBuilder<Statistics, Statistics, QSortThenBy> {
  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByFollows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"follows", Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByFollowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"follows", Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"type", Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"type", Sort.desc);
    });
  }
}

extension StatisticsQueryWhereDistinct
    on QueryBuilder<Statistics, Statistics, QDistinct> {
  QueryBuilder<Statistics, Statistics, QDistinct> distinctByFollows() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"follows");
    });
  }

  QueryBuilder<Statistics, Statistics, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Statistics, Statistics, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"type");
    });
  }
}

extension StatisticsQueryProperty
    on QueryBuilder<Statistics, Statistics, QQueryProperty> {
  QueryBuilder<Statistics, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<Statistics, CommentStatistics?, QQueryOperations>
      commentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"comments");
    });
  }

  QueryBuilder<Statistics, int?, QQueryOperations> followsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"follows");
    });
  }

  QueryBuilder<Statistics, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<Statistics, RatingStatistics?, QQueryOperations>
      ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"rating");
    });
  }

  QueryBuilder<Statistics, EntityType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"type");
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CommentStatisticsSchema = Schema(
  name: r"CommentStatistics",
  id: 5590073889979445643,
  properties: {
    r"id": PropertySchema(
      id: 0,
      name: r"id",
      type: IsarType.long,
    ),
    r"total": PropertySchema(
      id: 1,
      name: r"total",
      type: IsarType.long,
    )
  },
  estimateSize: _commentStatisticsEstimateSize,
  serialize: _commentStatisticsSerialize,
  deserialize: _commentStatisticsDeserialize,
  deserializeProp: _commentStatisticsDeserializeProp,
);

int _commentStatisticsEstimateSize(
  CommentStatistics object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _commentStatisticsSerialize(
  CommentStatistics object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeLong(offsets[1], object.total);
}

CommentStatistics _commentStatisticsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CommentStatistics(
    id: reader.readLongOrNull(offsets[0]) ?? 0,
    total: reader.readLongOrNull(offsets[1]) ?? 0,
  );
  return object;
}

P _commentStatisticsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

extension CommentStatisticsQueryFilter
    on QueryBuilder<CommentStatistics, CommentStatistics, QFilterCondition> {
  QueryBuilder<CommentStatistics, CommentStatistics, QAfterFilterCondition>
      idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<CommentStatistics, CommentStatistics, QAfterFilterCondition>
      idGreaterThan(
    int value, {
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

  QueryBuilder<CommentStatistics, CommentStatistics, QAfterFilterCondition>
      idLessThan(
    int value, {
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

  QueryBuilder<CommentStatistics, CommentStatistics, QAfterFilterCondition>
      idBetween(
    int lower,
    int upper, {
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

  QueryBuilder<CommentStatistics, CommentStatistics, QAfterFilterCondition>
      totalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"total",
        value: value,
      ));
    });
  }

  QueryBuilder<CommentStatistics, CommentStatistics, QAfterFilterCondition>
      totalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"total",
        value: value,
      ));
    });
  }

  QueryBuilder<CommentStatistics, CommentStatistics, QAfterFilterCondition>
      totalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"total",
        value: value,
      ));
    });
  }

  QueryBuilder<CommentStatistics, CommentStatistics, QAfterFilterCondition>
      totalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"total",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CommentStatisticsQueryObject
    on QueryBuilder<CommentStatistics, CommentStatistics, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RatingStatisticsSchema = Schema(
  name: r"RatingStatistics",
  id: -1063738768541718830,
  properties: {
    r"average": PropertySchema(
      id: 0,
      name: r"average",
      type: IsarType.double,
    ),
    r"bayesian": PropertySchema(
      id: 1,
      name: r"bayesian",
      type: IsarType.double,
    ),
    r"distribution": PropertySchema(
      id: 2,
      name: r"distribution",
      type: IsarType.longList,
    )
  },
  estimateSize: _ratingStatisticsEstimateSize,
  serialize: _ratingStatisticsSerialize,
  deserialize: _ratingStatisticsDeserialize,
  deserializeProp: _ratingStatisticsDeserializeProp,
);

int _ratingStatisticsEstimateSize(
  RatingStatistics object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.distribution.length * 8;
  return bytesCount;
}

void _ratingStatisticsSerialize(
  RatingStatistics object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.average);
  writer.writeDouble(offsets[1], object.bayesian);
  writer.writeLongList(offsets[2], object.distribution);
}

RatingStatistics _ratingStatisticsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RatingStatistics(
    average: reader.readDoubleOrNull(offsets[0]) ?? 0,
    bayesian: reader.readDoubleOrNull(offsets[1]) ?? 0,
    distribution: reader.readLongList(offsets[2]) ?? const [],
  );
  return object;
}

P _ratingStatisticsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readLongList(offset) ?? const []) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

extension RatingStatisticsQueryFilter
    on QueryBuilder<RatingStatistics, RatingStatistics, QFilterCondition> {
  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      averageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"average",
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      averageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"average",
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      averageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"average",
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      averageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"average",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      bayesianEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"bayesian",
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      bayesianGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"bayesian",
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      bayesianLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"bayesian",
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      bayesianBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"bayesian",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"distribution",
        value: value,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"distribution",
        value: value,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"distribution",
        value: value,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"distribution",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"distribution",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"distribution",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"distribution",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"distribution",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"distribution",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RatingStatistics, RatingStatistics, QAfterFilterCondition>
      distributionLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"distribution",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension RatingStatisticsQueryObject
    on QueryBuilder<RatingStatistics, RatingStatistics, QFilterCondition> {}
