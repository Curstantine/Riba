// GENERATED CODE - DO NOT MODIFY BY HAND

part of "history.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHistoryCollection on Isar {
  IsarCollection<History> get history => this.collection();
}

const HistorySchema = CollectionSchema(
  name: r"History",
  id: 1676981785059398080,
  properties: {
    r"createdAt": PropertySchema(
      id: 0,
      name: r"createdAt",
      type: IsarType.dateTime,
    ),
    r"type": PropertySchema(
      id: 1,
      name: r"type",
      type: IsarType.byte,
      enumMap: _HistorytypeEnumValueMap,
    ),
    r"value": PropertySchema(
      id: 2,
      name: r"value",
      type: IsarType.string,
    )
  },
  estimateSize: _historyEstimateSize,
  serialize: _historySerialize,
  deserialize: _historyDeserialize,
  deserializeProp: _historyDeserializeProp,
  idName: r"id",
  indexes: {
    r"type": IndexSchema(
      id: 5117122708147080838,
      name: r"type",
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r"type",
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _historyGetId,
  getLinks: _historyGetLinks,
  attach: _historyAttach,
  version: "3.1.0+1",
);

int _historyEstimateSize(
  History object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _historySerialize(
  History object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeByte(offsets[1], object.type.index);
  writer.writeString(offsets[2], object.value);
}

History _historyDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = History(
    createdAt: reader.readDateTime(offsets[0]),
    type: _HistorytypeValueEnumMap[reader.readByteOrNull(offsets[1])] ??
        HistoryType.author,
    value: reader.readString(offsets[2]),
  );
  return object;
}

P _historyDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (_HistorytypeValueEnumMap[reader.readByteOrNull(offset)] ??
          HistoryType.author) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _HistorytypeEnumValueMap = {
  "author": 0,
  "chapter": 1,
  "manga": 2,
  "query": 3,
};
const _HistorytypeValueEnumMap = {
  0: HistoryType.author,
  1: HistoryType.chapter,
  2: HistoryType.manga,
  3: HistoryType.query,
};

Id _historyGetId(History object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _historyGetLinks(History object) {
  return [];
}

void _historyAttach(IsarCollection<dynamic> col, Id id, History object) {}

extension HistoryQueryWhereSort on QueryBuilder<History, History, QWhere> {
  QueryBuilder<History, History, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<History, History, QAfterWhere> anyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r"type"),
      );
    });
  }
}

extension HistoryQueryWhere on QueryBuilder<History, History, QWhereClause> {
  QueryBuilder<History, History, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<History, History, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<History, History, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<History, History, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<History, History, QAfterWhereClause> idBetween(
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

  QueryBuilder<History, History, QAfterWhereClause> typeEqualTo(
      HistoryType type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r"type",
        value: [type],
      ));
    });
  }

  QueryBuilder<History, History, QAfterWhereClause> typeNotEqualTo(
      HistoryType type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"type",
              lower: [],
              upper: [type],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"type",
              lower: [type],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r"type",
              lower: [type],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r"type",
              lower: [],
              upper: [type],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<History, History, QAfterWhereClause> typeGreaterThan(
    HistoryType type, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r"type",
        lower: [type],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<History, History, QAfterWhereClause> typeLessThan(
    HistoryType type, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r"type",
        lower: [],
        upper: [type],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<History, History, QAfterWhereClause> typeBetween(
    HistoryType lowerType,
    HistoryType upperType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r"type",
        lower: [lowerType],
        includeLower: includeLower,
        upper: [upperType],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryQueryFilter
    on QueryBuilder<History, History, QFilterCondition> {
  QueryBuilder<History, History, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"createdAt",
        value: value,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<History, History, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<History, History, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<History, History, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: value,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<History, History, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<History, History, QAfterFilterCondition> idBetween(
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

  QueryBuilder<History, History, QAfterFilterCondition> typeEqualTo(
      HistoryType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"type",
        value: value,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> typeGreaterThan(
    HistoryType value, {
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

  QueryBuilder<History, History, QAfterFilterCondition> typeLessThan(
    HistoryType value, {
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

  QueryBuilder<History, History, QAfterFilterCondition> typeBetween(
    HistoryType lower,
    HistoryType upper, {
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

  QueryBuilder<History, History, QAfterFilterCondition> valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"value",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"value",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"value",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"value",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"value",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"value",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"value",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"value",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"value",
        value: "",
      ));
    });
  }

  QueryBuilder<History, History, QAfterFilterCondition> valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"value",
        value: "",
      ));
    });
  }
}

extension HistoryQueryObject
    on QueryBuilder<History, History, QFilterCondition> {}

extension HistoryQueryLinks
    on QueryBuilder<History, History, QFilterCondition> {}

extension HistoryQuerySortBy on QueryBuilder<History, History, QSortBy> {
  QueryBuilder<History, History, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"type", Sort.asc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"type", Sort.desc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"value", Sort.asc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"value", Sort.desc);
    });
  }
}

extension HistoryQuerySortThenBy
    on QueryBuilder<History, History, QSortThenBy> {
  QueryBuilder<History, History, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"type", Sort.asc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"type", Sort.desc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"value", Sort.asc);
    });
  }

  QueryBuilder<History, History, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"value", Sort.desc);
    });
  }
}

extension HistoryQueryWhereDistinct
    on QueryBuilder<History, History, QDistinct> {
  QueryBuilder<History, History, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"createdAt");
    });
  }

  QueryBuilder<History, History, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"type");
    });
  }

  QueryBuilder<History, History, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"value", caseSensitive: caseSensitive);
    });
  }
}

extension HistoryQueryProperty
    on QueryBuilder<History, History, QQueryProperty> {
  QueryBuilder<History, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<History, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"createdAt");
    });
  }

  QueryBuilder<History, HistoryType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"type");
    });
  }

  QueryBuilder<History, String, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"value");
    });
  }
}
