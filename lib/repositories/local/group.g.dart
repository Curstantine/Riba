// GENERATED CODE - DO NOT MODIFY BY HAND

part of "group.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetGroupCollection on Isar {
  IsarCollection<Group> get groups => this.collection();
}

const GroupSchema = CollectionSchema(
  name: r"Group",
  id: -2045556087275737047,
  properties: {
    r"altNames": PropertySchema(
      id: 0,
      name: r"altNames",
      type: IsarType.objectList,
      target: r"Localizations",
    ),
    r"createdAt": PropertySchema(
      id: 1,
      name: r"createdAt",
      type: IsarType.dateTime,
    ),
    r"description": PropertySchema(
      id: 2,
      name: r"description",
      type: IsarType.string,
    ),
    r"focusedLanguages": PropertySchema(
      id: 3,
      name: r"focusedLanguages",
      type: IsarType.byteList,
      enumMap: _GroupfocusedLanguagesEnumValueMap,
    ),
    r"id": PropertySchema(
      id: 4,
      name: r"id",
      type: IsarType.string,
    ),
    r"inactive": PropertySchema(
      id: 5,
      name: r"inactive",
      type: IsarType.bool,
    ),
    r"name": PropertySchema(
      id: 6,
      name: r"name",
      type: IsarType.string,
    ),
    r"official": PropertySchema(
      id: 7,
      name: r"official",
      type: IsarType.bool,
    ),
    r"socials": PropertySchema(
      id: 8,
      name: r"socials",
      type: IsarType.object,
      target: r"GroupSocials",
    ),
    r"updatedAt": PropertySchema(
      id: 9,
      name: r"updatedAt",
      type: IsarType.dateTime,
    ),
    r"version": PropertySchema(
      id: 10,
      name: r"version",
      type: IsarType.long,
    )
  },
  estimateSize: _groupEstimateSize,
  serialize: _groupSerialize,
  deserialize: _groupDeserialize,
  deserializeProp: _groupDeserializeProp,
  idName: r"isarId",
  indexes: {},
  links: {},
  embeddedSchemas: {
    r"Localizations": LocalizationsSchema,
    r"Locale": LocaleSchema,
    r"GroupSocials": GroupSocialsSchema
  },
  getId: _groupGetId,
  getLinks: _groupGetLinks,
  attach: _groupAttach,
  version: "3.0.5",
);

int _groupEstimateSize(
  Group object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.altNames.length * 3;
  {
    final offsets = allOffsets[Localizations]!;
    for (var i = 0; i < object.altNames.length; i++) {
      final value = object.altNames[i];
      bytesCount +=
          LocalizationsSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.focusedLanguages.length;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 +
      GroupSocialsSchema.estimateSize(
          object.socials, allOffsets[GroupSocials]!, allOffsets);
  return bytesCount;
}

void _groupSerialize(
  Group object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Localizations>(
    offsets[0],
    allOffsets,
    LocalizationsSchema.serialize,
    object.altNames,
  );
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.description);
  writer.writeByteList(
      offsets[3], object.focusedLanguages.map((e) => e.index).toList());
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.inactive);
  writer.writeString(offsets[6], object.name);
  writer.writeBool(offsets[7], object.official);
  writer.writeObject<GroupSocials>(
    offsets[8],
    allOffsets,
    GroupSocialsSchema.serialize,
    object.socials,
  );
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeLong(offsets[10], object.version);
}

Group _groupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Group(
    altNames: reader.readObjectList<Localizations>(
          offsets[0],
          LocalizationsSchema.deserialize,
          allOffsets,
          Localizations(),
        ) ??
        [],
    createdAt: reader.readDateTime(offsets[1]),
    description: reader.readString(offsets[2]),
    focusedLanguages: reader
            .readByteList(offsets[3])
            ?.map((e) => _GroupfocusedLanguagesValueEnumMap[e] ?? Language.none)
            .toList() ??
        [],
    id: reader.readString(offsets[4]),
    inactive: reader.readBool(offsets[5]),
    name: reader.readString(offsets[6]),
    official: reader.readBool(offsets[7]),
    socials: reader.readObjectOrNull<GroupSocials>(
          offsets[8],
          GroupSocialsSchema.deserialize,
          allOffsets,
        ) ??
        GroupSocials(),
    updatedAt: reader.readDateTime(offsets[9]),
    version: reader.readLong(offsets[10]),
  );
  return object;
}

P _groupDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader
              .readByteList(offset)
              ?.map(
                  (e) => _GroupfocusedLanguagesValueEnumMap[e] ?? Language.none)
              .toList() ??
          []) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readObjectOrNull<GroupSocials>(
            offset,
            GroupSocialsSchema.deserialize,
            allOffsets,
          ) ??
          GroupSocials()) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _GroupfocusedLanguagesEnumValueMap = {
  "none": 0,
  "english": 1,
  "japanese": 2,
  "simpleChinese": 3,
  "traditionalChinese": 4,
  "korean": 5,
};
const _GroupfocusedLanguagesValueEnumMap = {
  0: Language.none,
  1: Language.english,
  2: Language.japanese,
  3: Language.simpleChinese,
  4: Language.traditionalChinese,
  5: Language.korean,
};

Id _groupGetId(Group object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _groupGetLinks(Group object) {
  return [];
}

void _groupAttach(IsarCollection<dynamic> col, Id id, Group object) {}

extension GroupQueryWhereSort on QueryBuilder<Group, Group, QWhere> {
  QueryBuilder<Group, Group, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GroupQueryWhere on QueryBuilder<Group, Group, QWhereClause> {
  QueryBuilder<Group, Group, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Group, Group, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Group, Group, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Group, Group, QAfterWhereClause> isarIdBetween(
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

extension GroupQueryFilter on QueryBuilder<Group, Group, QFilterCondition> {
  QueryBuilder<Group, Group, QAfterFilterCondition> altNamesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altNames",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> altNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altNames",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> altNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altNames",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> altNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altNames",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> altNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altNames",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> altNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"altNames",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"createdAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"description",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"description",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"description",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"description",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"description",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"description",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"description",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"description",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"description",
        value: "",
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"description",
        value: "",
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesElementEqualTo(Language value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"focusedLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesElementGreaterThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"focusedLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesElementLessThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"focusedLanguages",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesElementBetween(
    Language lower,
    Language upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"focusedLanguages",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"focusedLanguages",
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> focusedLanguagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"focusedLanguages",
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"focusedLanguages",
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"focusedLanguages",
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"focusedLanguages",
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition>
      focusedLanguagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r"focusedLanguages",
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> idMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"id",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> inactiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"inactive",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"name",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"name",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"name",
        value: "",
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"name",
        value: "",
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> officialEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"official",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"updatedAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"version",
        value: value,
      ));
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> versionGreaterThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> versionLessThan(
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

  QueryBuilder<Group, Group, QAfterFilterCondition> versionBetween(
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

extension GroupQueryObject on QueryBuilder<Group, Group, QFilterCondition> {
  QueryBuilder<Group, Group, QAfterFilterCondition> altNamesElement(
      FilterQuery<Localizations> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"altNames");
    });
  }

  QueryBuilder<Group, Group, QAfterFilterCondition> socials(
      FilterQuery<GroupSocials> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"socials");
    });
  }
}

extension GroupQueryLinks on QueryBuilder<Group, Group, QFilterCondition> {}

extension GroupQuerySortBy on QueryBuilder<Group, Group, QSortBy> {
  QueryBuilder<Group, Group, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"description", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"description", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"inactive", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByInactiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"inactive", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByOfficial() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"official", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByOfficialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"official", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }
}

extension GroupQuerySortThenBy on QueryBuilder<Group, Group, QSortThenBy> {
  QueryBuilder<Group, Group, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"description", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"description", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"inactive", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByInactiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"inactive", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByOfficial() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"official", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByOfficialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"official", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.desc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<Group, Group, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }
}

extension GroupQueryWhereDistinct on QueryBuilder<Group, Group, QDistinct> {
  QueryBuilder<Group, Group, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"createdAt");
    });
  }

  QueryBuilder<Group, Group, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"description", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Group, Group, QDistinct> distinctByFocusedLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"focusedLanguages");
    });
  }

  QueryBuilder<Group, Group, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Group, Group, QDistinct> distinctByInactive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"inactive");
    });
  }

  QueryBuilder<Group, Group, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"name", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Group, Group, QDistinct> distinctByOfficial() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"official");
    });
  }

  QueryBuilder<Group, Group, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"updatedAt");
    });
  }

  QueryBuilder<Group, Group, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"version");
    });
  }
}

extension GroupQueryProperty on QueryBuilder<Group, Group, QQueryProperty> {
  QueryBuilder<Group, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<Group, List<Localizations>, QQueryOperations>
      altNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"altNames");
    });
  }

  QueryBuilder<Group, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"createdAt");
    });
  }

  QueryBuilder<Group, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"description");
    });
  }

  QueryBuilder<Group, List<Language>, QQueryOperations>
      focusedLanguagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"focusedLanguages");
    });
  }

  QueryBuilder<Group, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<Group, bool, QQueryOperations> inactiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"inactive");
    });
  }

  QueryBuilder<Group, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"name");
    });
  }

  QueryBuilder<Group, bool, QQueryOperations> officialProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"official");
    });
  }

  QueryBuilder<Group, GroupSocials, QQueryOperations> socialsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"socials");
    });
  }

  QueryBuilder<Group, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"updatedAt");
    });
  }

  QueryBuilder<Group, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"version");
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const GroupSocialsSchema = Schema(
  name: r"GroupSocials",
  id: 2559141510548206998,
  properties: {
    r"contactEmail": PropertySchema(
      id: 0,
      name: r"contactEmail",
      type: IsarType.string,
    ),
    r"discord": PropertySchema(
      id: 1,
      name: r"discord",
      type: IsarType.string,
    ),
    r"ircChannel": PropertySchema(
      id: 2,
      name: r"ircChannel",
      type: IsarType.string,
    ),
    r"ircServer": PropertySchema(
      id: 3,
      name: r"ircServer",
      type: IsarType.string,
    ),
    r"mangaUpdates": PropertySchema(
      id: 4,
      name: r"mangaUpdates",
      type: IsarType.string,
    ),
    r"twitter": PropertySchema(
      id: 5,
      name: r"twitter",
      type: IsarType.string,
    ),
    r"website": PropertySchema(
      id: 6,
      name: r"website",
      type: IsarType.string,
    )
  },
  estimateSize: _groupSocialsEstimateSize,
  serialize: _groupSocialsSerialize,
  deserialize: _groupSocialsDeserialize,
  deserializeProp: _groupSocialsDeserializeProp,
);

int _groupSocialsEstimateSize(
  GroupSocials object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.contactEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.discord;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ircChannel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ircServer;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mangaUpdates;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.twitter;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.website;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _groupSocialsSerialize(
  GroupSocials object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.contactEmail);
  writer.writeString(offsets[1], object.discord);
  writer.writeString(offsets[2], object.ircChannel);
  writer.writeString(offsets[3], object.ircServer);
  writer.writeString(offsets[4], object.mangaUpdates);
  writer.writeString(offsets[5], object.twitter);
  writer.writeString(offsets[6], object.website);
}

GroupSocials _groupSocialsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GroupSocials(
    contactEmail: reader.readStringOrNull(offsets[0]),
    discord: reader.readStringOrNull(offsets[1]),
    ircChannel: reader.readStringOrNull(offsets[2]),
    ircServer: reader.readStringOrNull(offsets[3]),
    mangaUpdates: reader.readStringOrNull(offsets[4]),
    twitter: reader.readStringOrNull(offsets[5]),
    website: reader.readStringOrNull(offsets[6]),
  );
  return object;
}

P _groupSocialsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

extension GroupSocialsQueryFilter
    on QueryBuilder<GroupSocials, GroupSocials, QFilterCondition> {
  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"contactEmail",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"contactEmail",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"contactEmail",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"contactEmail",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"contactEmail",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"contactEmail",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"contactEmail",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"contactEmail",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"contactEmail",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"contactEmail",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"contactEmail",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      contactEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"contactEmail",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"discord",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"discord",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"discord",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"discord",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"discord",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"discord",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"discord",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"discord",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"discord",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"discord",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"discord",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      discordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"discord",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"ircChannel",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"ircChannel",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"ircChannel",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"ircChannel",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"ircChannel",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"ircChannel",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"ircChannel",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"ircChannel",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"ircChannel",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"ircChannel",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"ircChannel",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircChannelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"ircChannel",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"ircServer",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"ircServer",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"ircServer",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"ircServer",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"ircServer",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"ircServer",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"ircServer",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"ircServer",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"ircServer",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"ircServer",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"ircServer",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      ircServerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"ircServer",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"mangaUpdates",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"mangaUpdates",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"mangaUpdates",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"mangaUpdates",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"mangaUpdates",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"mangaUpdates",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"mangaUpdates",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"mangaUpdates",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"mangaUpdates",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"mangaUpdates",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"mangaUpdates",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      mangaUpdatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"mangaUpdates",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"twitter",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"twitter",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"twitter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"twitter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"twitter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"twitter",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"twitter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"twitter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"twitter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"twitter",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"twitter",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      twitterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"twitter",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"website",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"website",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"website",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"website",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"website",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"website",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"website",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"website",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"website",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"website",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"website",
        value: "",
      ));
    });
  }

  QueryBuilder<GroupSocials, GroupSocials, QAfterFilterCondition>
      websiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"website",
        value: "",
      ));
    });
  }
}

extension GroupSocialsQueryObject
    on QueryBuilder<GroupSocials, GroupSocials, QFilterCondition> {}
