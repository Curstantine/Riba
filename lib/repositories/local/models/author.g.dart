// GENERATED CODE - DO NOT MODIFY BY HAND

part of "author.dart";

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetAuthorCollection on Isar {
  IsarCollection<Author> get authors => this.collection();
}

const AuthorSchema = CollectionSchema(
  name: r"Author",
  id: 889148532872689203,
  properties: {
    r"createdAt": PropertySchema(
      id: 0,
      name: r"createdAt",
      type: IsarType.dateTime,
    ),
    r"description": PropertySchema(
      id: 1,
      name: r"description",
      type: IsarType.object,
      target: r"Localizations",
    ),
    r"id": PropertySchema(
      id: 2,
      name: r"id",
      type: IsarType.string,
    ),
    r"name": PropertySchema(
      id: 3,
      name: r"name",
      type: IsarType.string,
    ),
    r"socials": PropertySchema(
      id: 4,
      name: r"socials",
      type: IsarType.object,
      target: r"AuthorSocial",
    ),
    r"version": PropertySchema(
      id: 5,
      name: r"version",
      type: IsarType.long,
    )
  },
  estimateSize: _authorEstimateSize,
  serialize: _authorSerialize,
  deserialize: _authorDeserialize,
  deserializeProp: _authorDeserializeProp,
  idName: r"isarId",
  indexes: {},
  links: {},
  embeddedSchemas: {
    r"Localizations": LocalizationsSchema,
    r"Locale": LocaleSchema,
    r"AuthorSocial": AuthorSocialSchema
  },
  getId: _authorGetId,
  getLinks: _authorGetLinks,
  attach: _authorAttach,
  version: "3.0.5",
);

int _authorEstimateSize(
  Author object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      LocalizationsSchema.estimateSize(
          object.description, allOffsets[Localizations]!, allOffsets);
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 +
      AuthorSocialSchema.estimateSize(
          object.socials, allOffsets[AuthorSocial]!, allOffsets);
  return bytesCount;
}

void _authorSerialize(
  Author object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeObject<Localizations>(
    offsets[1],
    allOffsets,
    LocalizationsSchema.serialize,
    object.description,
  );
  writer.writeString(offsets[2], object.id);
  writer.writeString(offsets[3], object.name);
  writer.writeObject<AuthorSocial>(
    offsets[4],
    allOffsets,
    AuthorSocialSchema.serialize,
    object.socials,
  );
  writer.writeLong(offsets[5], object.version);
}

Author _authorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Author(
    createdAt: reader.readDateTime(offsets[0]),
    description: reader.readObjectOrNull<Localizations>(
          offsets[1],
          LocalizationsSchema.deserialize,
          allOffsets,
        ) ??
        Localizations(),
    id: reader.readString(offsets[2]),
    name: reader.readString(offsets[3]),
    socials: reader.readObjectOrNull<AuthorSocial>(
          offsets[4],
          AuthorSocialSchema.deserialize,
          allOffsets,
        ) ??
        AuthorSocial(),
    version: reader.readLong(offsets[5]),
  );
  return object;
}

P _authorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readObjectOrNull<Localizations>(
            offset,
            LocalizationsSchema.deserialize,
            allOffsets,
          ) ??
          Localizations()) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readObjectOrNull<AuthorSocial>(
            offset,
            AuthorSocialSchema.deserialize,
            allOffsets,
          ) ??
          AuthorSocial()) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

Id _authorGetId(Author object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _authorGetLinks(Author object) {
  return [];
}

void _authorAttach(IsarCollection<dynamic> col, Id id, Author object) {}

extension AuthorQueryWhereSort on QueryBuilder<Author, Author, QWhere> {
  QueryBuilder<Author, Author, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AuthorQueryWhere on QueryBuilder<Author, Author, QWhereClause> {
  QueryBuilder<Author, Author, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Author, Author, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Author, Author, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Author, Author, QAfterWhereClause> isarIdBetween(
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

extension AuthorQueryFilter on QueryBuilder<Author, Author, QFilterCondition> {
  QueryBuilder<Author, Author, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"createdAt",
        value: value,
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"id",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> idMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"id",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"id",
        value: "",
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"isarId",
        value: value,
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"name",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"name",
        value: "",
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"name",
        value: "",
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> versionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"version",
        value: value,
      ));
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> versionGreaterThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> versionLessThan(
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

  QueryBuilder<Author, Author, QAfterFilterCondition> versionBetween(
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

extension AuthorQueryObject on QueryBuilder<Author, Author, QFilterCondition> {
  QueryBuilder<Author, Author, QAfterFilterCondition> description(
      FilterQuery<Localizations> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"description");
    });
  }

  QueryBuilder<Author, Author, QAfterFilterCondition> socials(
      FilterQuery<AuthorSocial> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r"socials");
    });
  }
}

extension AuthorQueryLinks on QueryBuilder<Author, Author, QFilterCondition> {}

extension AuthorQuerySortBy on QueryBuilder<Author, Author, QSortBy> {
  QueryBuilder<Author, Author, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.desc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }
}

extension AuthorQuerySortThenBy on QueryBuilder<Author, Author, QSortThenBy> {
  QueryBuilder<Author, Author, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"createdAt", Sort.desc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"id", Sort.desc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"isarId", Sort.desc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"name", Sort.desc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.asc);
    });
  }

  QueryBuilder<Author, Author, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r"version", Sort.desc);
    });
  }
}

extension AuthorQueryWhereDistinct on QueryBuilder<Author, Author, QDistinct> {
  QueryBuilder<Author, Author, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"createdAt");
    });
  }

  QueryBuilder<Author, Author, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"id", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Author, Author, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"name", caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Author, Author, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r"version");
    });
  }
}

extension AuthorQueryProperty on QueryBuilder<Author, Author, QQueryProperty> {
  QueryBuilder<Author, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"isarId");
    });
  }

  QueryBuilder<Author, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"createdAt");
    });
  }

  QueryBuilder<Author, Localizations, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"description");
    });
  }

  QueryBuilder<Author, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"id");
    });
  }

  QueryBuilder<Author, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"name");
    });
  }

  QueryBuilder<Author, AuthorSocial, QQueryOperations> socialsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r"socials");
    });
  }

  QueryBuilder<Author, int, QQueryOperations> versionProperty() {
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

const AuthorSocialSchema = Schema(
  name: r"AuthorSocial",
  id: -2859736065198832577,
  properties: {
    r"booth": PropertySchema(
      id: 0,
      name: r"booth",
      type: IsarType.string,
    ),
    r"fanBox": PropertySchema(
      id: 1,
      name: r"fanBox",
      type: IsarType.string,
    ),
    r"fantia": PropertySchema(
      id: 2,
      name: r"fantia",
      type: IsarType.string,
    ),
    r"melonBook": PropertySchema(
      id: 3,
      name: r"melonBook",
      type: IsarType.string,
    ),
    r"naver": PropertySchema(
      id: 4,
      name: r"naver",
      type: IsarType.string,
    ),
    r"nicoVideo": PropertySchema(
      id: 5,
      name: r"nicoVideo",
      type: IsarType.string,
    ),
    r"pixiv": PropertySchema(
      id: 6,
      name: r"pixiv",
      type: IsarType.string,
    ),
    r"skeb": PropertySchema(
      id: 7,
      name: r"skeb",
      type: IsarType.string,
    ),
    r"tumblr": PropertySchema(
      id: 8,
      name: r"tumblr",
      type: IsarType.string,
    ),
    r"twitter": PropertySchema(
      id: 9,
      name: r"twitter",
      type: IsarType.string,
    ),
    r"website": PropertySchema(
      id: 10,
      name: r"website",
      type: IsarType.string,
    ),
    r"weibo": PropertySchema(
      id: 11,
      name: r"weibo",
      type: IsarType.string,
    ),
    r"youtube": PropertySchema(
      id: 12,
      name: r"youtube",
      type: IsarType.string,
    )
  },
  estimateSize: _authorSocialEstimateSize,
  serialize: _authorSocialSerialize,
  deserialize: _authorSocialDeserialize,
  deserializeProp: _authorSocialDeserializeProp,
);

int _authorSocialEstimateSize(
  AuthorSocial object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.booth;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fanBox;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fantia;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.melonBook;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.naver;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nicoVideo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pixiv;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.skeb;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.tumblr;
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
  {
    final value = object.weibo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.youtube;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _authorSocialSerialize(
  AuthorSocial object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.booth);
  writer.writeString(offsets[1], object.fanBox);
  writer.writeString(offsets[2], object.fantia);
  writer.writeString(offsets[3], object.melonBook);
  writer.writeString(offsets[4], object.naver);
  writer.writeString(offsets[5], object.nicoVideo);
  writer.writeString(offsets[6], object.pixiv);
  writer.writeString(offsets[7], object.skeb);
  writer.writeString(offsets[8], object.tumblr);
  writer.writeString(offsets[9], object.twitter);
  writer.writeString(offsets[10], object.website);
  writer.writeString(offsets[11], object.weibo);
  writer.writeString(offsets[12], object.youtube);
}

AuthorSocial _authorSocialDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AuthorSocial(
    booth: reader.readStringOrNull(offsets[0]),
    fanBox: reader.readStringOrNull(offsets[1]),
    fantia: reader.readStringOrNull(offsets[2]),
    melonBook: reader.readStringOrNull(offsets[3]),
    naver: reader.readStringOrNull(offsets[4]),
    nicoVideo: reader.readStringOrNull(offsets[5]),
    pixiv: reader.readStringOrNull(offsets[6]),
    skeb: reader.readStringOrNull(offsets[7]),
    tumblr: reader.readStringOrNull(offsets[8]),
    twitter: reader.readStringOrNull(offsets[9]),
    website: reader.readStringOrNull(offsets[10]),
    weibo: reader.readStringOrNull(offsets[11]),
    youtube: reader.readStringOrNull(offsets[12]),
  );
  return object;
}

P _authorSocialDeserializeProp<P>(
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
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError("Unknown property with id $propertyId");
  }
}

extension AuthorSocialQueryFilter
    on QueryBuilder<AuthorSocial, AuthorSocial, QFilterCondition> {
  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      boothIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"booth",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      boothIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"booth",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> boothEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"booth",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      boothGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"booth",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> boothLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"booth",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> boothBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"booth",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      boothStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"booth",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> boothEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"booth",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> boothContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"booth",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> boothMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"booth",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      boothIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"booth",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      boothIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"booth",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"fanBox",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"fanBox",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> fanBoxEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fanBox",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"fanBox",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"fanBox",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> fanBoxBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"fanBox",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"fanBox",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"fanBox",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"fanBox",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> fanBoxMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"fanBox",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fanBox",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fanBoxIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"fanBox",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"fantia",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"fantia",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> fantiaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fantia",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"fantia",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"fantia",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> fantiaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"fantia",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"fantia",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"fantia",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"fantia",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> fantiaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"fantia",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"fantia",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      fantiaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"fantia",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"melonBook",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"melonBook",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"melonBook",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"melonBook",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"melonBook",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"melonBook",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"melonBook",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"melonBook",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"melonBook",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"melonBook",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"melonBook",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      melonBookIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"melonBook",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      naverIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"naver",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      naverIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"naver",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> naverEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"naver",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      naverGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"naver",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> naverLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"naver",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> naverBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"naver",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      naverStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"naver",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> naverEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"naver",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> naverContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"naver",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> naverMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"naver",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      naverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"naver",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      naverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"naver",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"nicoVideo",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"nicoVideo",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"nicoVideo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"nicoVideo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"nicoVideo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"nicoVideo",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"nicoVideo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"nicoVideo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"nicoVideo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"nicoVideo",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"nicoVideo",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      nicoVideoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"nicoVideo",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      pixivIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"pixiv",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      pixivIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"pixiv",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> pixivEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"pixiv",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      pixivGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"pixiv",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> pixivLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"pixiv",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> pixivBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"pixiv",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      pixivStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"pixiv",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> pixivEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"pixiv",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> pixivContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"pixiv",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> pixivMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"pixiv",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      pixivIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"pixiv",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      pixivIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"pixiv",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> skebIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"skeb",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      skebIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"skeb",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> skebEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"skeb",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      skebGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"skeb",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> skebLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"skeb",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> skebBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"skeb",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      skebStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"skeb",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> skebEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"skeb",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> skebContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"skeb",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> skebMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"skeb",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      skebIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"skeb",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      skebIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"skeb",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"tumblr",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"tumblr",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> tumblrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"tumblr",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"tumblr",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"tumblr",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> tumblrBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"tumblr",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"tumblr",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"tumblr",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"tumblr",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> tumblrMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"tumblr",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"tumblr",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      tumblrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"tumblr",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      twitterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"twitter",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      twitterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"twitter",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      twitterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"twitter",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      twitterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"twitter",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      twitterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"twitter",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      twitterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"twitter",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      websiteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"website",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      websiteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"website",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
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

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      websiteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"website",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      websiteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"website",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      websiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"website",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      websiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"website",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      weiboIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"weibo",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      weiboIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"weibo",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> weiboEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"weibo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      weiboGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"weibo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> weiboLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"weibo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> weiboBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"weibo",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      weiboStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"weibo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> weiboEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"weibo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> weiboContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"weibo",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition> weiboMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"weibo",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      weiboIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"weibo",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      weiboIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"weibo",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r"youtube",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r"youtube",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"youtube",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r"youtube",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r"youtube",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r"youtube",
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r"youtube",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r"youtube",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r"youtube",
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r"youtube",
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r"youtube",
        value: "",
      ));
    });
  }

  QueryBuilder<AuthorSocial, AuthorSocial, QAfterFilterCondition>
      youtubeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r"youtube",
        value: "",
      ));
    });
  }
}

extension AuthorSocialQueryObject
    on QueryBuilder<AuthorSocial, AuthorSocial, QFilterCondition> {}
