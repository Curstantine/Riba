// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_local_meta.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChapterLocalMetaCWProxy {
  ChapterLocalMeta id(String id);

  ChapterLocalMeta isRead(bool isRead);

  ChapterLocalMeta isDownloaded(bool isDownloaded);

  ChapterLocalMeta isFavorite(bool isFavorite);

  ChapterLocalMeta lastReadPage(int lastReadPage);

  ChapterLocalMeta lastReadAt(DateTime lastReadAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChapterLocalMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChapterLocalMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  ChapterLocalMeta call({
    String? id,
    bool? isRead,
    bool? isDownloaded,
    bool? isFavorite,
    int? lastReadPage,
    DateTime? lastReadAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChapterLocalMeta.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChapterLocalMeta.copyWith.fieldName(...)`
class _$ChapterLocalMetaCWProxyImpl implements _$ChapterLocalMetaCWProxy {
  const _$ChapterLocalMetaCWProxyImpl(this._value);

  final ChapterLocalMeta _value;

  @override
  ChapterLocalMeta id(String id) => this(id: id);

  @override
  ChapterLocalMeta isRead(bool isRead) => this(isRead: isRead);

  @override
  ChapterLocalMeta isDownloaded(bool isDownloaded) =>
      this(isDownloaded: isDownloaded);

  @override
  ChapterLocalMeta isFavorite(bool isFavorite) => this(isFavorite: isFavorite);

  @override
  ChapterLocalMeta lastReadPage(int lastReadPage) =>
      this(lastReadPage: lastReadPage);

  @override
  ChapterLocalMeta lastReadAt(DateTime lastReadAt) =>
      this(lastReadAt: lastReadAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChapterLocalMeta(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChapterLocalMeta(...).copyWith(id: 12, name: "My name")
  /// ````
  ChapterLocalMeta call({
    Object? id = const $CopyWithPlaceholder(),
    Object? isRead = const $CopyWithPlaceholder(),
    Object? isDownloaded = const $CopyWithPlaceholder(),
    Object? isFavorite = const $CopyWithPlaceholder(),
    Object? lastReadPage = const $CopyWithPlaceholder(),
    Object? lastReadAt = const $CopyWithPlaceholder(),
  }) {
    return ChapterLocalMeta(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      isRead: isRead == const $CopyWithPlaceholder() || isRead == null
          ? _value.isRead
          // ignore: cast_nullable_to_non_nullable
          : isRead as bool,
      isDownloaded:
          isDownloaded == const $CopyWithPlaceholder() || isDownloaded == null
              ? _value.isDownloaded
              // ignore: cast_nullable_to_non_nullable
              : isDownloaded as bool,
      isFavorite:
          isFavorite == const $CopyWithPlaceholder() || isFavorite == null
              ? _value.isFavorite
              // ignore: cast_nullable_to_non_nullable
              : isFavorite as bool,
      lastReadPage:
          lastReadPage == const $CopyWithPlaceholder() || lastReadPage == null
              ? _value.lastReadPage
              // ignore: cast_nullable_to_non_nullable
              : lastReadPage as int,
      lastReadAt:
          lastReadAt == const $CopyWithPlaceholder() || lastReadAt == null
              ? _value.lastReadAt
              // ignore: cast_nullable_to_non_nullable
              : lastReadAt as DateTime,
    );
  }
}

extension $ChapterLocalMetaCopyWith on ChapterLocalMeta {
  /// Returns a callable class that can be used as follows: `instanceOfChapterLocalMeta.copyWith(...)` or like so:`instanceOfChapterLocalMeta.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChapterLocalMetaCWProxy get copyWith => _$ChapterLocalMetaCWProxyImpl(this);
}

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChapterLocalMetaCollection on Isar {
  IsarCollection<ChapterLocalMeta> get chapterMeta => this.collection();
}

const ChapterLocalMetaSchema = CollectionSchema(
  name: r'ChapterLocalMeta',
  id: -4760458010664121924,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.string,
    ),
    r'isDownloaded': PropertySchema(
      id: 1,
      name: r'isDownloaded',
      type: IsarType.bool,
    ),
    r'isFavorite': PropertySchema(
      id: 2,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'isRead': PropertySchema(
      id: 3,
      name: r'isRead',
      type: IsarType.bool,
    ),
    r'lastReadAt': PropertySchema(
      id: 4,
      name: r'lastReadAt',
      type: IsarType.dateTime,
    ),
    r'lastReadPage': PropertySchema(
      id: 5,
      name: r'lastReadPage',
      type: IsarType.long,
    )
  },
  estimateSize: _chapterLocalMetaEstimateSize,
  serialize: _chapterLocalMetaSerialize,
  deserialize: _chapterLocalMetaDeserialize,
  deserializeProp: _chapterLocalMetaDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _chapterLocalMetaGetId,
  getLinks: _chapterLocalMetaGetLinks,
  attach: _chapterLocalMetaAttach,
  version: '3.1.0+1',
);

int _chapterLocalMetaEstimateSize(
  ChapterLocalMeta object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _chapterLocalMetaSerialize(
  ChapterLocalMeta object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.id);
  writer.writeBool(offsets[1], object.isDownloaded);
  writer.writeBool(offsets[2], object.isFavorite);
  writer.writeBool(offsets[3], object.isRead);
  writer.writeDateTime(offsets[4], object.lastReadAt);
  writer.writeLong(offsets[5], object.lastReadPage);
}

ChapterLocalMeta _chapterLocalMetaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterLocalMeta(
    id: reader.readString(offsets[0]),
    isDownloaded: reader.readBool(offsets[1]),
    isFavorite: reader.readBool(offsets[2]),
    isRead: reader.readBool(offsets[3]),
    lastReadAt: reader.readDateTime(offsets[4]),
    lastReadPage: reader.readLong(offsets[5]),
  );
  return object;
}

P _chapterLocalMetaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _chapterLocalMetaGetId(ChapterLocalMeta object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _chapterLocalMetaGetLinks(ChapterLocalMeta object) {
  return [];
}

void _chapterLocalMetaAttach(
    IsarCollection<dynamic> col, Id id, ChapterLocalMeta object) {}

extension ChapterLocalMetaQueryWhereSort
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QWhere> {
  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChapterLocalMetaQueryWhere
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QWhereClause> {
  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterWhereClause>
      isarIdBetween(
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

extension ChapterLocalMetaQueryFilter
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QFilterCondition> {
  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      isDownloadedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDownloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      isReadEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRead',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      lastReadAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      lastReadAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      lastReadAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      lastReadAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      lastReadPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      lastReadPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      lastReadPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterFilterCondition>
      lastReadPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChapterLocalMetaQueryObject
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QFilterCondition> {}

extension ChapterLocalMetaQueryLinks
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QFilterCondition> {}

extension ChapterLocalMetaQuerySortBy
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QSortBy> {
  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByIsDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRead', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByIsReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRead', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      sortByLastReadPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.desc);
    });
  }
}

extension ChapterLocalMetaQuerySortThenBy
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QSortThenBy> {
  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIsDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownloaded', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRead', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIsReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRead', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.asc);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QAfterSortBy>
      thenByLastReadPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.desc);
    });
  }
}

extension ChapterLocalMetaQueryWhereDistinct
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QDistinct> {
  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QDistinct>
      distinctByIsDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDownloaded');
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QDistinct>
      distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QDistinct>
      distinctByIsRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRead');
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QDistinct>
      distinctByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadAt');
    });
  }

  QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QDistinct>
      distinctByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadPage');
    });
  }
}

extension ChapterLocalMetaQueryProperty
    on QueryBuilder<ChapterLocalMeta, ChapterLocalMeta, QQueryProperty> {
  QueryBuilder<ChapterLocalMeta, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ChapterLocalMeta, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChapterLocalMeta, bool, QQueryOperations>
      isDownloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDownloaded');
    });
  }

  QueryBuilder<ChapterLocalMeta, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<ChapterLocalMeta, bool, QQueryOperations> isReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRead');
    });
  }

  QueryBuilder<ChapterLocalMeta, DateTime, QQueryOperations>
      lastReadAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadAt');
    });
  }

  QueryBuilder<ChapterLocalMeta, int, QQueryOperations> lastReadPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadPage');
    });
  }
}
