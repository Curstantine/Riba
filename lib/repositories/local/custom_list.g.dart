// GENERATED CODE - DO NOT MODIFY BY HAND

part of "custom_list.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCustomListCollection on Isar {
  IsarCollection<CustomList> get customLists => this.collection();
}

const CustomListSchema = CollectionSchema(
  name: r"CustomList",
  id: -8525547938508663416,
  properties: {
    r"id": PropertySchema(
      id: 0,
      name: r"id",
      type: IsarType.string,
    ),
    r"mangaIds": PropertySchema(
      id: 1,
      name: r"mangaIds",
      type: IsarType.stringList,
    ),
    r"name": PropertySchema(
      id: 2,
      name: r"name",
      type: IsarType.string,
    ),
    r"userId": PropertySchema(
      id: 3,
      name: r"userId",
      type: IsarType.string,
    ),
    r"version": PropertySchema(
      id: 4,
      name: r"version",
      type: IsarType.long,
    ),
    r"visibility": PropertySchema(
      id: 5,
      name: r"visibility",
      type: IsarType.byte,
      enumMap: _CustomListvisibilityEnumValueMap,
    )
  },
  estimateSize: _customListEstimateSize,
  serialize: _customListSerialize,
  deserialize: _customListDeserialize,
  deserializeProp: _customListDeserializeProp,
  idName: r"isarId",
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _customListGetId,
  getLinks: _customListGetLinks,
  attach: _customListAttach,
  version: "3.0.5",
);

int _customListEstimateSize(
  CustomList object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.mangaIds.length * 3;
  {
    for (var i = 0; i < object.mangaIds.length; i++) {
      final value = object.mangaIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _customListSerialize(
  CustomList object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.id);
  writer.writeStringList(offsets[1], object.mangaIds);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.userId);
  writer.writeLong(offsets[4], object.version);
  writer.writeByte(offsets[5], object.visibility.index);
}

CustomList _customListDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomList(
    id: reader.readString(offsets[0]),
    mangaIds: reader.readStringList(offsets[1]) ?? [],
    name: reader.readString(offsets[2]),
    userId: reader.readString(offsets[3]),
    version: reader.readLong(offsets[4]),
    visibility:
        _CustomListvisibilityValueEnumMap[reader.readByteOrNull(offsets[5])] ??
            CustomListVisibility.public,
  );
  return object;
}

P _customListDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (_CustomListvisibilityValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CustomListVisibility.public) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _CustomListvisibilityEnumValueMap = {
  "public": 0,
  "private": 1,
};
const _CustomListvisibilityValueEnumMap = {
  0: CustomListVisibility.public,
  1: CustomListVisibility.private,
};

Id _customListGetId(CustomList object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _customListGetLinks(CustomList object) {
  return [];
}

void _customListAttach(IsarCollection<dynamic> col, Id id, CustomList object) {}

extension CustomListQueryWhereSort
    on QueryBuilder<CustomList, CustomList, QWhere> {
  QueryBuilder<CustomList, CustomList, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CustomListQueryWhere
    on QueryBuilder<CustomList, CustomList, QWhereClause> {
  QueryBuilder<CustomList, CustomList, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<CustomList, CustomList, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterWhereClause> isarIdBetween(
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

extension CustomListQueryFilter
    on QueryBuilder<CustomList, CustomList, QFilterCondition> {
  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idContains(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idMatches(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"mangaIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"mangaIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"mangaIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"mangaIds",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"mangaIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"mangaIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"mangaIds",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"mangaIds",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"mangaIds",
        value: "",
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"mangaIds",
        value: "",
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"mangaIds",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"mangaIds",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"mangaIds",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"mangaIds",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"mangaIds",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      mangaIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"mangaIds",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"name",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"name",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"name",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"name",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"name",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"name",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"name",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"name",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"name",
        value: "",
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"name",
        value: "",
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"userId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"userId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"userId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"userId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"userId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"userId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"userId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"userId",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"userId",
        value: "",
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"userId",
        value: "",
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> versionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"version",
        value: value,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      versionGreaterThan(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> versionLessThan(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> versionBetween(
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

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> visibilityEqualTo(
      CustomListVisibility value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"visibility",
        value: value,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      visibilityGreaterThan(
    CustomListVisibility value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"visibility",
        value: value,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition>
      visibilityLessThan(
    CustomListVisibility value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"visibility",
        value: value,
      ));
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterFilterCondition> visibilityBetween(
    CustomListVisibility lower,
    CustomListVisibility upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"visibility",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CustomListQueryObject
    on QueryBuilder<CustomList, CustomList, QFilterCondition> {}

extension CustomListQueryLinks
    on QueryBuilder<CustomList, CustomList, QFilterCondition> {}

extension CustomListQuerySortBy
    on QueryBuilder<CustomList, CustomList, QSortBy> {
  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"userId", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"userId", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByVisibility() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"visibility", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> sortByVisibilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"visibility", Sort.desc);
    });
  }
}

extension CustomListQuerySortThenBy
    on QueryBuilder<CustomList, CustomList, QSortThenBy> {
  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"userId", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"userId", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByVisibility() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"visibility", Sort.asc);
    });
  }

  QueryBuilder<CustomList, CustomList, QAfterSortBy> thenByVisibilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"visibility", Sort.desc);
    });
  }
}

extension CustomListQueryWhereDistinct
    on QueryBuilder<CustomList, CustomList, QDistinct> {
  QueryBuilder<CustomList, CustomList, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomList, CustomList, QDistinct> distinctByMangaIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"mangaIds");
    });
  }

  QueryBuilder<CustomList, CustomList, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"name", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomList, CustomList, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"userId", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomList, CustomList, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"version");
    });
  }

  QueryBuilder<CustomList, CustomList, QDistinct> distinctByVisibility() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"visibility");
    });
  }
}

extension CustomListQueryProperty
    on QueryBuilder<CustomList, CustomList, QQueryProperty> {
  QueryBuilder<CustomList, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<CustomList, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<CustomList, List<String>, QQueryOperations> mangaIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"mangaIds");
    });
  }

  QueryBuilder<CustomList, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"name");
    });
  }

  QueryBuilder<CustomList, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"userId");
    });
  }

  QueryBuilder<CustomList, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"version");
    });
  }

  QueryBuilder<CustomList, CustomListVisibility, QQueryOperations>
      visibilityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"visibility");
    });
  }
}
