// GENERATED CODE - DO NOT MODIFY BY HAND

part of "cover_art.dart";

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoverSizeAdapter extends TypeAdapter<CoverSize> {
  @override
  final int typeId = 2;

  @override
  CoverSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CoverSize.original;
      case 1:
        return CoverSize.medium;
      case 2:
        return CoverSize.small;
      default:
        return CoverSize.original;
    }
  }

  @override
  void write(BinaryWriter writer, CoverSize obj) {
    switch (obj) {
      case CoverSize.original:
        writer.writeByte(0);
        break;
      case CoverSize.medium:
        writer.writeByte(1);
        break;
      case CoverSize.small:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoverSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCoverArtCollection on Isar {
  IsarCollection<CoverArt> get covers => this.collection();
}

const CoverArtSchema = CollectionSchema(
  name: r"CoverArt",
  id: 2191863464653854851,
  properties: {
    r"createdAt": PropertySchema(
      id: 0,
      name: r"createdAt",
      type: IsarType.dateTime,
    ),
    r"description": PropertySchema(
      id: 1,
      name: r"description",
      type: IsarType.string,
    ),
    r"fileId": PropertySchema(
      id: 2,
      name: r"fileId",
      type: IsarType.string,
    ),
    r"fileType": PropertySchema(
      id: 3,
      name: r"fileType",
      type: IsarType.byte,
      enumMap: _CoverArtfileTypeEnumValueMap,
    ),
    r"id": PropertySchema(
      id: 4,
      name: r"id",
      type: IsarType.string,
    ),
    r"locale": PropertySchema(
      id: 5,
      name: r"locale",
      type: IsarType.object,
      target: r"Locale",
    ),
    r"manga": PropertySchema(
      id: 6,
      name: r"manga",
      type: IsarType.string,
    ),
    r"updatedAt": PropertySchema(
      id: 7,
      name: r"updatedAt",
      type: IsarType.dateTime,
    ),
    r"user": PropertySchema(
      id: 8,
      name: r"user",
      type: IsarType.string,
    ),
    r"version": PropertySchema(
      id: 9,
      name: r"version",
      type: IsarType.long,
    ),
    r"volume": PropertySchema(
      id: 10,
      name: r"volume",
      type: IsarType.string,
    )
  },
  estimateSize: _coverArtEstimateSize,
  serialize: _coverArtSerialize,
  deserialize: _coverArtDeserialize,
  deserializeProp: _coverArtDeserializeProp,
  idName: r"isarId",
  indexes: {},
  links: {},
  embeddedSchemas: {r"Locale": LocaleSchema},
  getId: _coverArtGetId,
  getLinks: _coverArtGetLinks,
  attach: _coverArtAttach,
  version: "3.0.5",
);

int _coverArtEstimateSize(
  CoverArt object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fileId.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.locale;
    if (value != null) {
      bytesCount +=
          3 + LocaleSchema.estimateSize(value, allOffsets[Locale]!, allOffsets);
    }
  }
  bytesCount += 3 + object.manga.length * 3;
  {
    final value = object.user;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.volume;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _coverArtSerialize(
  CoverArt object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.fileId);
  writer.writeByte(offsets[3], object.fileType.index);
  writer.writeString(offsets[4], object.id);
  writer.writeObject<Locale>(
    offsets[5],
    allOffsets,
    LocaleSchema.serialize,
    object.locale,
  );
  writer.writeString(offsets[6], object.manga);
  writer.writeDateTime(offsets[7], object.updatedAt);
  writer.writeString(offsets[8], object.user);
  writer.writeLong(offsets[9], object.version);
  writer.writeString(offsets[10], object.volume);
}

CoverArt _coverArtDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CoverArt(
    createdAt: reader.readDateTime(offsets[0]),
    description: reader.readStringOrNull(offsets[1]),
    fileId: reader.readString(offsets[2]),
    fileType:
        _CoverArtfileTypeValueEnumMap[reader.readByteOrNull(offsets[3])] ??
            ImageFileType.jpeg,
    id: reader.readString(offsets[4]),
    locale: reader.readObjectOrNull<Locale>(
      offsets[5],
      LocaleSchema.deserialize,
      allOffsets,
    ),
    manga: reader.readString(offsets[6]),
    updatedAt: reader.readDateTime(offsets[7]),
    user: reader.readStringOrNull(offsets[8]),
    version: reader.readLong(offsets[9]),
    volume: reader.readStringOrNull(offsets[10]),
  );
  return object;
}

P _coverArtDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_CoverArtfileTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          ImageFileType.jpeg) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<Locale>(
        offset,
        LocaleSchema.deserialize,
        allOffsets,
      )) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

const _CoverArtfileTypeEnumValueMap = {
  "jpeg": 0,
  "png": 1,
  "gif": 2,
};
const _CoverArtfileTypeValueEnumMap = {
  0: ImageFileType.jpeg,
  1: ImageFileType.png,
  2: ImageFileType.gif,
};

Id _coverArtGetId(CoverArt object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _coverArtGetLinks(CoverArt object) {
  return [];
}

void _coverArtAttach(IsarCollection<dynamic> col, Id id, CoverArt object) {}

extension CoverArtQueryWhereSort on QueryBuilder<CoverArt, CoverArt, QWhere> {
  QueryBuilder<CoverArt, CoverArt, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CoverArtQueryWhere on QueryBuilder<CoverArt, CoverArt, QWhereClause> {
  QueryBuilder<CoverArt, CoverArt, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<CoverArt, CoverArt, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterWhereClause> isarIdBetween(
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

extension CoverArtQueryFilter
    on QueryBuilder<CoverArt, CoverArt, QFilterCondition> {
  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"createdAt",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"description",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"description",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionLessThan(
    String? value, {
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionStartsWith(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionEndsWith(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionContains(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionMatches(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"description",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"description",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fileId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"fileId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"fileId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"fileId",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"fileId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"fileId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"fileId",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"fileId",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fileId",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"fileId",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileTypeEqualTo(
      ImageFileType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fileType",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileTypeGreaterThan(
    ImageFileType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"fileType",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileTypeLessThan(
    ImageFileType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"fileType",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> fileTypeBetween(
    ImageFileType lower,
    ImageFileType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"fileType",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idContains(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idMatches(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> localeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"locale",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> localeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"locale",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"manga",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"manga",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"manga",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"manga",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"manga",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"manga",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"manga",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"manga",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"manga",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> mangaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"manga",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"updatedAt",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"user",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"user",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"user",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"user",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"user",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"user",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"user",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"user",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"user",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"user",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"user",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> userIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"user",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> versionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"version",
        value: value,
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> versionGreaterThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> versionLessThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> versionBetween(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"volume",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"volume",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeEqualTo(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeGreaterThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeLessThan(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeBetween(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeStartsWith(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeEndsWith(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeContains(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeMatches(
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

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"volume",
        value: "",
      ));
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> volumeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"volume",
        value: "",
      ));
    });
  }
}

extension CoverArtQueryObject
    on QueryBuilder<CoverArt, CoverArt, QFilterCondition> {
  QueryBuilder<CoverArt, CoverArt, QAfterFilterCondition> locale(
      FilterQuery<Locale> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"locale");
    });
  }
}

extension CoverArtQueryLinks
    on QueryBuilder<CoverArt, CoverArt, QFilterCondition> {}

extension CoverArtQuerySortBy on QueryBuilder<CoverArt, CoverArt, QSortBy> {
  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"description", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"description", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByFileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fileId", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByFileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fileId", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByFileType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fileType", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByFileTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fileType", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"manga", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"manga", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"user", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"user", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"volume", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> sortByVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"volume", Sort.desc);
    });
  }
}

extension CoverArtQuerySortThenBy
    on QueryBuilder<CoverArt, CoverArt, QSortThenBy> {
  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"description", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"description", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByFileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fileId", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByFileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fileId", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByFileType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fileType", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByFileTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"fileType", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"manga", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"manga", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"updatedAt", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"user", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"user", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"volume", Sort.asc);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QAfterSortBy> thenByVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"volume", Sort.desc);
    });
  }
}

extension CoverArtQueryWhereDistinct
    on QueryBuilder<CoverArt, CoverArt, QDistinct> {
  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"createdAt");
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"description", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByFileId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"fileId", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByFileType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"fileType");
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByManga(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"manga", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"updatedAt");
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByUser(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"user", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"version");
    });
  }

  QueryBuilder<CoverArt, CoverArt, QDistinct> distinctByVolume(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"volume", caseSensitive: caseSensitive);
    });
  }
}

extension CoverArtQueryProperty
    on QueryBuilder<CoverArt, CoverArt, QQueryProperty> {
  QueryBuilder<CoverArt, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<CoverArt, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"createdAt");
    });
  }

  QueryBuilder<CoverArt, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"description");
    });
  }

  QueryBuilder<CoverArt, String, QQueryOperations> fileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"fileId");
    });
  }

  QueryBuilder<CoverArt, ImageFileType, QQueryOperations> fileTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"fileType");
    });
  }

  QueryBuilder<CoverArt, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<CoverArt, Locale?, QQueryOperations> localeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"locale");
    });
  }

  QueryBuilder<CoverArt, String, QQueryOperations> mangaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"manga");
    });
  }

  QueryBuilder<CoverArt, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"updatedAt");
    });
  }

  QueryBuilder<CoverArt, String?, QQueryOperations> userProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"user");
    });
  }

  QueryBuilder<CoverArt, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"version");
    });
  }

  QueryBuilder<CoverArt, String?, QQueryOperations> volumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"volume");
    });
  }
}
