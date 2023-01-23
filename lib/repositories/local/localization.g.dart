// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const LocalizationsSchema = Schema(
  name: r'Localizations',
  id: 8014919257847374935,
  properties: {
    r'localizations': PropertySchema(
      id: 0,
      name: r'localizations',
      type: IsarType.objectList,
      target: r'Locale',
    ),
    r'values': PropertySchema(
      id: 1,
      name: r'values',
      type: IsarType.stringList,
    )
  },
  estimateSize: _localizationsEstimateSize,
  serialize: _localizationsSerialize,
  deserialize: _localizationsDeserialize,
  deserializeProp: _localizationsDeserializeProp,
);

int _localizationsEstimateSize(
  Localizations object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.localizations.length * 3;
  {
    final offsets = allOffsets[Locale]!;
    for (var i = 0; i < object.localizations.length; i++) {
      final value = object.localizations[i];
      bytesCount += LocaleSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.values.length * 3;
  {
    for (var i = 0; i < object.values.length; i++) {
      final value = object.values[i];
      if (value != null) {
        bytesCount += value.length * 3;
      }
    }
  }
  return bytesCount;
}

void _localizationsSerialize(
  Localizations object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Locale>(
    offsets[0],
    allOffsets,
    LocaleSchema.serialize,
    object.localizations,
  );
  writer.writeStringList(offsets[1], object.values);
}

Localizations _localizationsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Localizations();
  object.localizations = reader.readObjectList<Locale>(
        offsets[0],
        LocaleSchema.deserialize,
        allOffsets,
        Locale(),
      ) ??
      [];
  object.values = reader.readStringOrNullList(offsets[1]) ?? [];
  return object;
}

P _localizationsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Locale>(
            offset,
            LocaleSchema.deserialize,
            allOffsets,
            Locale(),
          ) ??
          []) as P;
    case 1:
      return (reader.readStringOrNullList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LocalizationsQueryFilter on QueryBuilder<Localizations, Localizations, QFilterCondition> {
  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> localizationsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localizations',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> localizationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localizations',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> localizationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localizations',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> localizationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localizations',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> localizationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localizations',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> localizationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'localizations',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNull(
        property: r'values',
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.elementIsNotNull(
        property: r'values',
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'values',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'values',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'values',
        value: '',
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'values',
        value: '',
      ));
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> valuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension LocalizationsQueryObject on QueryBuilder<Localizations, Localizations, QFilterCondition> {
  QueryBuilder<Localizations, Localizations, QAfterFilterCondition> localizationsElement(
      FilterQuery<Locale> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'localizations');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const LocaleSchema = Schema(
  name: r'Locale',
  id: -6418009249489833142,
  properties: {
    r'language': PropertySchema(
      id: 0,
      name: r'language',
      type: IsarType.byte,
      enumMap: _LocalelanguageEnumValueMap,
    ),
    r'romanized': PropertySchema(
      id: 1,
      name: r'romanized',
      type: IsarType.bool,
    )
  },
  estimateSize: _localeEstimateSize,
  serialize: _localeSerialize,
  deserialize: _localeDeserialize,
  deserializeProp: _localeDeserializeProp,
);

int _localeEstimateSize(
  Locale object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _localeSerialize(
  Locale object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.language.index);
  writer.writeBool(offsets[1], object.romanized);
}

Locale _localeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Locale();
  object.language =
      _LocalelanguageValueEnumMap[reader.readByteOrNull(offsets[0])] ?? Language.english;
  object.romanized = reader.readBool(offsets[1]);
  return object;
}

P _localeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_LocalelanguageValueEnumMap[reader.readByteOrNull(offset)] ?? Language.english) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LocalelanguageEnumValueMap = {
  'english': 0,
  'japanese': 1,
  'simpleChinese': 2,
  'traditionalChinese': 3,
  'korean': 4,
};
const _LocalelanguageValueEnumMap = {
  0: Language.english,
  1: Language.japanese,
  2: Language.simpleChinese,
  3: Language.traditionalChinese,
  4: Language.korean,
};

extension LocaleQueryFilter on QueryBuilder<Locale, Locale, QFilterCondition> {
  QueryBuilder<Locale, Locale, QAfterFilterCondition> languageEqualTo(Language value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'language',
        value: value,
      ));
    });
  }

  QueryBuilder<Locale, Locale, QAfterFilterCondition> languageGreaterThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'language',
        value: value,
      ));
    });
  }

  QueryBuilder<Locale, Locale, QAfterFilterCondition> languageLessThan(
    Language value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'language',
        value: value,
      ));
    });
  }

  QueryBuilder<Locale, Locale, QAfterFilterCondition> languageBetween(
    Language lower,
    Language upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'language',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Locale, Locale, QAfterFilterCondition> romanizedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'romanized',
        value: value,
      ));
    });
  }
}

extension LocaleQueryObject on QueryBuilder<Locale, Locale, QFilterCondition> {}
