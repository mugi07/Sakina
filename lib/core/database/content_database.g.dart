// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_database.dart';

// ignore_for_file: type=lint
class MetaEntries extends Table with TableInfo<MetaEntries, MetaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MetaEntries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaEntry(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  MetaEntries createAlias(String alias) {
    return MetaEntries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class MetaEntry extends DataClass implements Insertable<MetaEntry> {
  final String key;
  final String value;
  const MetaEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetaEntriesCompanion toCompanion(bool nullToAbsent) {
    return MetaEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory MetaEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetaEntry copyWith({String? key, String? value}) =>
      MetaEntry(key: key ?? this.key, value: value ?? this.value);
  MetaEntry copyWithCompanion(MetaEntriesCompanion data) {
    return MetaEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaEntry && other.key == this.key && other.value == this.value);
}

class MetaEntriesCompanion extends UpdateCompanion<MetaEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetaEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaEntriesCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return MetaEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Surahs extends Table with TableInfo<Surahs, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Surahs(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _nameTranslitMeta = const VerificationMeta('nameTranslit');
  late final GeneratedColumn<String> nameTranslit = GeneratedColumn<String>(
    'name_translit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revelationTypeMeta = const VerificationMeta('revelationType');
  late final GeneratedColumn<String> revelationType = GeneratedColumn<String>(
    'revelation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _revelationOrderMeta = const VerificationMeta('revelationOrder');
  late final GeneratedColumn<int> revelationOrder = GeneratedColumn<int>(
    'revelation_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _ayahCountMeta = const VerificationMeta('ayahCount');
  late final GeneratedColumn<int> ayahCount = GeneratedColumn<int>(
    'ayah_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _firstAyahIdMeta = const VerificationMeta('firstAyahId');
  late final GeneratedColumn<int> firstAyahId = GeneratedColumn<int>(
    'first_ayah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameAr,
    nameTranslit,
    nameEn,
    revelationType,
    revelationOrder,
    ayahCount,
    firstAyahId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(Insertable<Surah> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta, nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_translit')) {
      context.handle(
        _nameTranslitMeta,
        nameTranslit.isAcceptableOrUnknown(data['name_translit']!, _nameTranslitMeta),
      );
    } else if (isInserting) {
      context.missing(_nameTranslitMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta, nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('revelation_type')) {
      context.handle(
        _revelationTypeMeta,
        revelationType.isAcceptableOrUnknown(data['revelation_type']!, _revelationTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_revelationTypeMeta);
    }
    if (data.containsKey('revelation_order')) {
      context.handle(
        _revelationOrderMeta,
        revelationOrder.isAcceptableOrUnknown(data['revelation_order']!, _revelationOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_revelationOrderMeta);
    }
    if (data.containsKey('ayah_count')) {
      context.handle(
        _ayahCountMeta,
        ayahCount.isAcceptableOrUnknown(data['ayah_count']!, _ayahCountMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahCountMeta);
    }
    if (data.containsKey('first_ayah_id')) {
      context.handle(
        _firstAyahIdMeta,
        firstAyahId.isAcceptableOrUnknown(data['first_ayah_id']!, _firstAyahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_firstAyahIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameTranslit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_translit'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      revelationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revelation_type'],
      )!,
      revelationOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revelation_order'],
      )!,
      ayahCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_count'],
      )!,
      firstAyahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_ayah_id'],
      )!,
    );
  }

  @override
  Surahs createAlias(String alias) {
    return Surahs(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Surah extends DataClass implements Insertable<Surah> {
  final int id;
  final String nameAr;
  final String nameTranslit;
  final String nameEn;
  final String revelationType;
  final int revelationOrder;
  final int ayahCount;
  final int firstAyahId;
  const Surah({
    required this.id,
    required this.nameAr,
    required this.nameTranslit,
    required this.nameEn,
    required this.revelationType,
    required this.revelationOrder,
    required this.ayahCount,
    required this.firstAyahId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_translit'] = Variable<String>(nameTranslit);
    map['name_en'] = Variable<String>(nameEn);
    map['revelation_type'] = Variable<String>(revelationType);
    map['revelation_order'] = Variable<int>(revelationOrder);
    map['ayah_count'] = Variable<int>(ayahCount);
    map['first_ayah_id'] = Variable<int>(firstAyahId);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameTranslit: Value(nameTranslit),
      nameEn: Value(nameEn),
      revelationType: Value(revelationType),
      revelationOrder: Value(revelationOrder),
      ayahCount: Value(ayahCount),
      firstAyahId: Value(firstAyahId),
    );
  }

  factory Surah.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      id: serializer.fromJson<int>(json['id']),
      nameAr: serializer.fromJson<String>(json['name_ar']),
      nameTranslit: serializer.fromJson<String>(json['name_translit']),
      nameEn: serializer.fromJson<String>(json['name_en']),
      revelationType: serializer.fromJson<String>(json['revelation_type']),
      revelationOrder: serializer.fromJson<int>(json['revelation_order']),
      ayahCount: serializer.fromJson<int>(json['ayah_count']),
      firstAyahId: serializer.fromJson<int>(json['first_ayah_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name_ar': serializer.toJson<String>(nameAr),
      'name_translit': serializer.toJson<String>(nameTranslit),
      'name_en': serializer.toJson<String>(nameEn),
      'revelation_type': serializer.toJson<String>(revelationType),
      'revelation_order': serializer.toJson<int>(revelationOrder),
      'ayah_count': serializer.toJson<int>(ayahCount),
      'first_ayah_id': serializer.toJson<int>(firstAyahId),
    };
  }

  Surah copyWith({
    int? id,
    String? nameAr,
    String? nameTranslit,
    String? nameEn,
    String? revelationType,
    int? revelationOrder,
    int? ayahCount,
    int? firstAyahId,
  }) => Surah(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameTranslit: nameTranslit ?? this.nameTranslit,
    nameEn: nameEn ?? this.nameEn,
    revelationType: revelationType ?? this.revelationType,
    revelationOrder: revelationOrder ?? this.revelationOrder,
    ayahCount: ayahCount ?? this.ayahCount,
    firstAyahId: firstAyahId ?? this.firstAyahId,
  );
  Surah copyWithCompanion(SurahsCompanion data) {
    return Surah(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameTranslit: data.nameTranslit.present ? data.nameTranslit.value : this.nameTranslit,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      revelationType: data.revelationType.present ? data.revelationType.value : this.revelationType,
      revelationOrder: data.revelationOrder.present
          ? data.revelationOrder.value
          : this.revelationOrder,
      ayahCount: data.ayahCount.present ? data.ayahCount.value : this.ayahCount,
      firstAyahId: data.firstAyahId.present ? data.firstAyahId.value : this.firstAyahId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameTranslit: $nameTranslit, ')
          ..write('nameEn: $nameEn, ')
          ..write('revelationType: $revelationType, ')
          ..write('revelationOrder: $revelationOrder, ')
          ..write('ayahCount: $ayahCount, ')
          ..write('firstAyahId: $firstAyahId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameAr,
    nameTranslit,
    nameEn,
    revelationType,
    revelationOrder,
    ayahCount,
    firstAyahId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameTranslit == this.nameTranslit &&
          other.nameEn == this.nameEn &&
          other.revelationType == this.revelationType &&
          other.revelationOrder == this.revelationOrder &&
          other.ayahCount == this.ayahCount &&
          other.firstAyahId == this.firstAyahId);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<int> id;
  final Value<String> nameAr;
  final Value<String> nameTranslit;
  final Value<String> nameEn;
  final Value<String> revelationType;
  final Value<int> revelationOrder;
  final Value<int> ayahCount;
  final Value<int> firstAyahId;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameTranslit = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.revelationType = const Value.absent(),
    this.revelationOrder = const Value.absent(),
    this.ayahCount = const Value.absent(),
    this.firstAyahId = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required String nameAr,
    required String nameTranslit,
    required String nameEn,
    required String revelationType,
    required int revelationOrder,
    required int ayahCount,
    required int firstAyahId,
  }) : nameAr = Value(nameAr),
       nameTranslit = Value(nameTranslit),
       nameEn = Value(nameEn),
       revelationType = Value(revelationType),
       revelationOrder = Value(revelationOrder),
       ayahCount = Value(ayahCount),
       firstAyahId = Value(firstAyahId);
  static Insertable<Surah> custom({
    Expression<int>? id,
    Expression<String>? nameAr,
    Expression<String>? nameTranslit,
    Expression<String>? nameEn,
    Expression<String>? revelationType,
    Expression<int>? revelationOrder,
    Expression<int>? ayahCount,
    Expression<int>? firstAyahId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameTranslit != null) 'name_translit': nameTranslit,
      if (nameEn != null) 'name_en': nameEn,
      if (revelationType != null) 'revelation_type': revelationType,
      if (revelationOrder != null) 'revelation_order': revelationOrder,
      if (ayahCount != null) 'ayah_count': ayahCount,
      if (firstAyahId != null) 'first_ayah_id': firstAyahId,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? id,
    Value<String>? nameAr,
    Value<String>? nameTranslit,
    Value<String>? nameEn,
    Value<String>? revelationType,
    Value<int>? revelationOrder,
    Value<int>? ayahCount,
    Value<int>? firstAyahId,
  }) {
    return SurahsCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameTranslit: nameTranslit ?? this.nameTranslit,
      nameEn: nameEn ?? this.nameEn,
      revelationType: revelationType ?? this.revelationType,
      revelationOrder: revelationOrder ?? this.revelationOrder,
      ayahCount: ayahCount ?? this.ayahCount,
      firstAyahId: firstAyahId ?? this.firstAyahId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameTranslit.present) {
      map['name_translit'] = Variable<String>(nameTranslit.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (revelationType.present) {
      map['revelation_type'] = Variable<String>(revelationType.value);
    }
    if (revelationOrder.present) {
      map['revelation_order'] = Variable<int>(revelationOrder.value);
    }
    if (ayahCount.present) {
      map['ayah_count'] = Variable<int>(ayahCount.value);
    }
    if (firstAyahId.present) {
      map['first_ayah_id'] = Variable<int>(firstAyahId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameTranslit: $nameTranslit, ')
          ..write('nameEn: $nameEn, ')
          ..write('revelationType: $revelationType, ')
          ..write('revelationOrder: $revelationOrder, ')
          ..write('ayahCount: $ayahCount, ')
          ..write('firstAyahId: $firstAyahId')
          ..write(')'))
        .toString();
  }
}

class Ayahs extends Table with TableInfo<Ayahs, Ayah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Ayahs(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _surahMeta = const VerificationMeta('surah');
  late final GeneratedColumn<int> surah = GeneratedColumn<int>(
    'surah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES surahs(id)',
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _textUthmaniMeta = const VerificationMeta('textUthmani');
  late final GeneratedColumn<String> textUthmani = GeneratedColumn<String>(
    'text_uthmani',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _textSearchMeta = const VerificationMeta('textSearch');
  late final GeneratedColumn<String> textSearch = GeneratedColumn<String>(
    'text_search',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _juzMeta = const VerificationMeta('juz');
  late final GeneratedColumn<int> juz = GeneratedColumn<int>(
    'juz',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _hizbQuarterMeta = const VerificationMeta('hizbQuarter');
  late final GeneratedColumn<int> hizbQuarter = GeneratedColumn<int>(
    'hizb_quarter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sajdaMeta = const VerificationMeta('sajda');
  late final GeneratedColumn<String> sajda = GeneratedColumn<String>(
    'sajda',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surah,
    number,
    textUthmani,
    textSearch,
    juz,
    hizbQuarter,
    page,
    sajda,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayahs';
  @override
  VerificationContext validateIntegrity(Insertable<Ayah> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah')) {
      context.handle(_surahMeta, surah.isAcceptableOrUnknown(data['surah']!, _surahMeta));
    } else if (isInserting) {
      context.missing(_surahMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta, number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('text_uthmani')) {
      context.handle(
        _textUthmaniMeta,
        textUthmani.isAcceptableOrUnknown(data['text_uthmani']!, _textUthmaniMeta),
      );
    } else if (isInserting) {
      context.missing(_textUthmaniMeta);
    }
    if (data.containsKey('text_search')) {
      context.handle(
        _textSearchMeta,
        textSearch.isAcceptableOrUnknown(data['text_search']!, _textSearchMeta),
      );
    } else if (isInserting) {
      context.missing(_textSearchMeta);
    }
    if (data.containsKey('juz')) {
      context.handle(_juzMeta, juz.isAcceptableOrUnknown(data['juz']!, _juzMeta));
    } else if (isInserting) {
      context.missing(_juzMeta);
    }
    if (data.containsKey('hizb_quarter')) {
      context.handle(
        _hizbQuarterMeta,
        hizbQuarter.isAcceptableOrUnknown(data['hizb_quarter']!, _hizbQuarterMeta),
      );
    } else if (isInserting) {
      context.missing(_hizbQuarterMeta);
    }
    if (data.containsKey('page')) {
      context.handle(_pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('sajda')) {
      context.handle(_sajdaMeta, sajda.isAcceptableOrUnknown(data['sajda']!, _sajdaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ayah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ayah(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surah: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}surah'])!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      textUthmani: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_uthmani'],
      )!,
      textSearch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_search'],
      )!,
      juz: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}juz'])!,
      hizbQuarter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hizb_quarter'],
      )!,
      page: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}page'])!,
      sajda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sajda'],
      ),
    );
  }

  @override
  Ayahs createAlias(String alias) {
    return Ayahs(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Ayah extends DataClass implements Insertable<Ayah> {
  final int id;
  final int surah;
  final int number;
  final String textUthmani;
  final String textSearch;
  final int juz;
  final int hizbQuarter;
  final int page;
  final String? sajda;
  const Ayah({
    required this.id,
    required this.surah,
    required this.number,
    required this.textUthmani,
    required this.textSearch,
    required this.juz,
    required this.hizbQuarter,
    required this.page,
    this.sajda,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah'] = Variable<int>(surah);
    map['number'] = Variable<int>(number);
    map['text_uthmani'] = Variable<String>(textUthmani);
    map['text_search'] = Variable<String>(textSearch);
    map['juz'] = Variable<int>(juz);
    map['hizb_quarter'] = Variable<int>(hizbQuarter);
    map['page'] = Variable<int>(page);
    if (!nullToAbsent || sajda != null) {
      map['sajda'] = Variable<String>(sajda);
    }
    return map;
  }

  AyahsCompanion toCompanion(bool nullToAbsent) {
    return AyahsCompanion(
      id: Value(id),
      surah: Value(surah),
      number: Value(number),
      textUthmani: Value(textUthmani),
      textSearch: Value(textSearch),
      juz: Value(juz),
      hizbQuarter: Value(hizbQuarter),
      page: Value(page),
      sajda: sajda == null && nullToAbsent ? const Value.absent() : Value(sajda),
    );
  }

  factory Ayah.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ayah(
      id: serializer.fromJson<int>(json['id']),
      surah: serializer.fromJson<int>(json['surah']),
      number: serializer.fromJson<int>(json['number']),
      textUthmani: serializer.fromJson<String>(json['text_uthmani']),
      textSearch: serializer.fromJson<String>(json['text_search']),
      juz: serializer.fromJson<int>(json['juz']),
      hizbQuarter: serializer.fromJson<int>(json['hizb_quarter']),
      page: serializer.fromJson<int>(json['page']),
      sajda: serializer.fromJson<String?>(json['sajda']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surah': serializer.toJson<int>(surah),
      'number': serializer.toJson<int>(number),
      'text_uthmani': serializer.toJson<String>(textUthmani),
      'text_search': serializer.toJson<String>(textSearch),
      'juz': serializer.toJson<int>(juz),
      'hizb_quarter': serializer.toJson<int>(hizbQuarter),
      'page': serializer.toJson<int>(page),
      'sajda': serializer.toJson<String?>(sajda),
    };
  }

  Ayah copyWith({
    int? id,
    int? surah,
    int? number,
    String? textUthmani,
    String? textSearch,
    int? juz,
    int? hizbQuarter,
    int? page,
    Value<String?> sajda = const Value.absent(),
  }) => Ayah(
    id: id ?? this.id,
    surah: surah ?? this.surah,
    number: number ?? this.number,
    textUthmani: textUthmani ?? this.textUthmani,
    textSearch: textSearch ?? this.textSearch,
    juz: juz ?? this.juz,
    hizbQuarter: hizbQuarter ?? this.hizbQuarter,
    page: page ?? this.page,
    sajda: sajda.present ? sajda.value : this.sajda,
  );
  Ayah copyWithCompanion(AyahsCompanion data) {
    return Ayah(
      id: data.id.present ? data.id.value : this.id,
      surah: data.surah.present ? data.surah.value : this.surah,
      number: data.number.present ? data.number.value : this.number,
      textUthmani: data.textUthmani.present ? data.textUthmani.value : this.textUthmani,
      textSearch: data.textSearch.present ? data.textSearch.value : this.textSearch,
      juz: data.juz.present ? data.juz.value : this.juz,
      hizbQuarter: data.hizbQuarter.present ? data.hizbQuarter.value : this.hizbQuarter,
      page: data.page.present ? data.page.value : this.page,
      sajda: data.sajda.present ? data.sajda.value : this.sajda,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ayah(')
          ..write('id: $id, ')
          ..write('surah: $surah, ')
          ..write('number: $number, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textSearch: $textSearch, ')
          ..write('juz: $juz, ')
          ..write('hizbQuarter: $hizbQuarter, ')
          ..write('page: $page, ')
          ..write('sajda: $sajda')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surah, number, textUthmani, textSearch, juz, hizbQuarter, page, sajda);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ayah &&
          other.id == this.id &&
          other.surah == this.surah &&
          other.number == this.number &&
          other.textUthmani == this.textUthmani &&
          other.textSearch == this.textSearch &&
          other.juz == this.juz &&
          other.hizbQuarter == this.hizbQuarter &&
          other.page == this.page &&
          other.sajda == this.sajda);
}

class AyahsCompanion extends UpdateCompanion<Ayah> {
  final Value<int> id;
  final Value<int> surah;
  final Value<int> number;
  final Value<String> textUthmani;
  final Value<String> textSearch;
  final Value<int> juz;
  final Value<int> hizbQuarter;
  final Value<int> page;
  final Value<String?> sajda;
  const AyahsCompanion({
    this.id = const Value.absent(),
    this.surah = const Value.absent(),
    this.number = const Value.absent(),
    this.textUthmani = const Value.absent(),
    this.textSearch = const Value.absent(),
    this.juz = const Value.absent(),
    this.hizbQuarter = const Value.absent(),
    this.page = const Value.absent(),
    this.sajda = const Value.absent(),
  });
  AyahsCompanion.insert({
    this.id = const Value.absent(),
    required int surah,
    required int number,
    required String textUthmani,
    required String textSearch,
    required int juz,
    required int hizbQuarter,
    required int page,
    this.sajda = const Value.absent(),
  }) : surah = Value(surah),
       number = Value(number),
       textUthmani = Value(textUthmani),
       textSearch = Value(textSearch),
       juz = Value(juz),
       hizbQuarter = Value(hizbQuarter),
       page = Value(page);
  static Insertable<Ayah> custom({
    Expression<int>? id,
    Expression<int>? surah,
    Expression<int>? number,
    Expression<String>? textUthmani,
    Expression<String>? textSearch,
    Expression<int>? juz,
    Expression<int>? hizbQuarter,
    Expression<int>? page,
    Expression<String>? sajda,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surah != null) 'surah': surah,
      if (number != null) 'number': number,
      if (textUthmani != null) 'text_uthmani': textUthmani,
      if (textSearch != null) 'text_search': textSearch,
      if (juz != null) 'juz': juz,
      if (hizbQuarter != null) 'hizb_quarter': hizbQuarter,
      if (page != null) 'page': page,
      if (sajda != null) 'sajda': sajda,
    });
  }

  AyahsCompanion copyWith({
    Value<int>? id,
    Value<int>? surah,
    Value<int>? number,
    Value<String>? textUthmani,
    Value<String>? textSearch,
    Value<int>? juz,
    Value<int>? hizbQuarter,
    Value<int>? page,
    Value<String?>? sajda,
  }) {
    return AyahsCompanion(
      id: id ?? this.id,
      surah: surah ?? this.surah,
      number: number ?? this.number,
      textUthmani: textUthmani ?? this.textUthmani,
      textSearch: textSearch ?? this.textSearch,
      juz: juz ?? this.juz,
      hizbQuarter: hizbQuarter ?? this.hizbQuarter,
      page: page ?? this.page,
      sajda: sajda ?? this.sajda,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surah.present) {
      map['surah'] = Variable<int>(surah.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (textUthmani.present) {
      map['text_uthmani'] = Variable<String>(textUthmani.value);
    }
    if (textSearch.present) {
      map['text_search'] = Variable<String>(textSearch.value);
    }
    if (juz.present) {
      map['juz'] = Variable<int>(juz.value);
    }
    if (hizbQuarter.present) {
      map['hizb_quarter'] = Variable<int>(hizbQuarter.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (sajda.present) {
      map['sajda'] = Variable<String>(sajda.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('id: $id, ')
          ..write('surah: $surah, ')
          ..write('number: $number, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textSearch: $textSearch, ')
          ..write('juz: $juz, ')
          ..write('hizbQuarter: $hizbQuarter, ')
          ..write('page: $page, ')
          ..write('sajda: $sajda')
          ..write(')'))
        .toString();
  }
}

class TranslationEditions extends Table with TableInfo<TranslationEditions, TranslationEdition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TranslationEditions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _languageMeta = const VerificationMeta('language');
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _translatorMeta = const VerificationMeta('translator');
  late final GeneratedColumn<String> translator = GeneratedColumn<String>(
    'translator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, language, name, translator];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translation_editions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TranslationEdition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('translator')) {
      context.handle(
        _translatorMeta,
        translator.isAcceptableOrUnknown(data['translator']!, _translatorMeta),
      );
    } else if (isInserting) {
      context.missing(_translatorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TranslationEdition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranslationEdition(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      translator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translator'],
      )!,
    );
  }

  @override
  TranslationEditions createAlias(String alias) {
    return TranslationEditions(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TranslationEdition extends DataClass implements Insertable<TranslationEdition> {
  final String id;
  final String language;
  final String name;
  final String translator;
  const TranslationEdition({
    required this.id,
    required this.language,
    required this.name,
    required this.translator,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['language'] = Variable<String>(language);
    map['name'] = Variable<String>(name);
    map['translator'] = Variable<String>(translator);
    return map;
  }

  TranslationEditionsCompanion toCompanion(bool nullToAbsent) {
    return TranslationEditionsCompanion(
      id: Value(id),
      language: Value(language),
      name: Value(name),
      translator: Value(translator),
    );
  }

  factory TranslationEdition.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranslationEdition(
      id: serializer.fromJson<String>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      name: serializer.fromJson<String>(json['name']),
      translator: serializer.fromJson<String>(json['translator']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'language': serializer.toJson<String>(language),
      'name': serializer.toJson<String>(name),
      'translator': serializer.toJson<String>(translator),
    };
  }

  TranslationEdition copyWith({String? id, String? language, String? name, String? translator}) =>
      TranslationEdition(
        id: id ?? this.id,
        language: language ?? this.language,
        name: name ?? this.name,
        translator: translator ?? this.translator,
      );
  TranslationEdition copyWithCompanion(TranslationEditionsCompanion data) {
    return TranslationEdition(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      name: data.name.present ? data.name.value : this.name,
      translator: data.translator.present ? data.translator.value : this.translator,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranslationEdition(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('name: $name, ')
          ..write('translator: $translator')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, language, name, translator);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranslationEdition &&
          other.id == this.id &&
          other.language == this.language &&
          other.name == this.name &&
          other.translator == this.translator);
}

class TranslationEditionsCompanion extends UpdateCompanion<TranslationEdition> {
  final Value<String> id;
  final Value<String> language;
  final Value<String> name;
  final Value<String> translator;
  final Value<int> rowid;
  const TranslationEditionsCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.name = const Value.absent(),
    this.translator = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranslationEditionsCompanion.insert({
    required String id,
    required String language,
    required String name,
    required String translator,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       language = Value(language),
       name = Value(name),
       translator = Value(translator);
  static Insertable<TranslationEdition> custom({
    Expression<String>? id,
    Expression<String>? language,
    Expression<String>? name,
    Expression<String>? translator,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (name != null) 'name': name,
      if (translator != null) 'translator': translator,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranslationEditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? language,
    Value<String>? name,
    Value<String>? translator,
    Value<int>? rowid,
  }) {
    return TranslationEditionsCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      name: name ?? this.name,
      translator: translator ?? this.translator,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (translator.present) {
      map['translator'] = Variable<String>(translator.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationEditionsCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('name: $name, ')
          ..write('translator: $translator, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AyahTranslations extends Table with TableInfo<AyahTranslations, AyahTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AyahTranslations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ayahIdMeta = const VerificationMeta('ayahId');
  late final GeneratedColumn<int> ayahId = GeneratedColumn<int>(
    'ayah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES ayahs(id)',
  );
  static const VerificationMeta _editionMeta = const VerificationMeta('edition');
  late final GeneratedColumn<String> edition = GeneratedColumn<String>(
    'edition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES translation_editions(id)',
  );
  static const VerificationMeta _contentMeta = const VerificationMeta('content');
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [ayahId, edition, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayah_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<AyahTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ayah_id')) {
      context.handle(_ayahIdMeta, ayahId.isAcceptableOrUnknown(data['ayah_id']!, _ayahIdMeta));
    } else if (isInserting) {
      context.missing(_ayahIdMeta);
    }
    if (data.containsKey('edition')) {
      context.handle(_editionMeta, edition.isAcceptableOrUnknown(data['edition']!, _editionMeta));
    } else if (isInserting) {
      context.missing(_editionMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta, content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ayahId, edition};
  @override
  AyahTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahTranslation(
      ayahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_id'],
      )!,
      edition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  AyahTranslations createAlias(String alias) {
    return AyahTranslations(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  List<String> get customConstraints => const ['PRIMARY KEY(ayah_id, edition)'];
  @override
  bool get dontWriteConstraints => true;
}

class AyahTranslation extends DataClass implements Insertable<AyahTranslation> {
  final int ayahId;
  final String edition;
  final String content;
  const AyahTranslation({required this.ayahId, required this.edition, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ayah_id'] = Variable<int>(ayahId);
    map['edition'] = Variable<String>(edition);
    map['content'] = Variable<String>(content);
    return map;
  }

  AyahTranslationsCompanion toCompanion(bool nullToAbsent) {
    return AyahTranslationsCompanion(
      ayahId: Value(ayahId),
      edition: Value(edition),
      content: Value(content),
    );
  }

  factory AyahTranslation.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahTranslation(
      ayahId: serializer.fromJson<int>(json['ayah_id']),
      edition: serializer.fromJson<String>(json['edition']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ayah_id': serializer.toJson<int>(ayahId),
      'edition': serializer.toJson<String>(edition),
      'content': serializer.toJson<String>(content),
    };
  }

  AyahTranslation copyWith({int? ayahId, String? edition, String? content}) => AyahTranslation(
    ayahId: ayahId ?? this.ayahId,
    edition: edition ?? this.edition,
    content: content ?? this.content,
  );
  AyahTranslation copyWithCompanion(AyahTranslationsCompanion data) {
    return AyahTranslation(
      ayahId: data.ayahId.present ? data.ayahId.value : this.ayahId,
      edition: data.edition.present ? data.edition.value : this.edition,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AyahTranslation(')
          ..write('ayahId: $ayahId, ')
          ..write('edition: $edition, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ayahId, edition, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahTranslation &&
          other.ayahId == this.ayahId &&
          other.edition == this.edition &&
          other.content == this.content);
}

class AyahTranslationsCompanion extends UpdateCompanion<AyahTranslation> {
  final Value<int> ayahId;
  final Value<String> edition;
  final Value<String> content;
  const AyahTranslationsCompanion({
    this.ayahId = const Value.absent(),
    this.edition = const Value.absent(),
    this.content = const Value.absent(),
  });
  AyahTranslationsCompanion.insert({
    required int ayahId,
    required String edition,
    required String content,
  }) : ayahId = Value(ayahId),
       edition = Value(edition),
       content = Value(content);
  static Insertable<AyahTranslation> custom({
    Expression<int>? ayahId,
    Expression<String>? edition,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (ayahId != null) 'ayah_id': ayahId,
      if (edition != null) 'edition': edition,
      if (content != null) 'content': content,
    });
  }

  AyahTranslationsCompanion copyWith({
    Value<int>? ayahId,
    Value<String>? edition,
    Value<String>? content,
  }) {
    return AyahTranslationsCompanion(
      ayahId: ayahId ?? this.ayahId,
      edition: edition ?? this.edition,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ayahId.present) {
      map['ayah_id'] = Variable<int>(ayahId.value);
    }
    if (edition.present) {
      map['edition'] = Variable<String>(edition.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahTranslationsCompanion(')
          ..write('ayahId: $ayahId, ')
          ..write('edition: $edition, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class Countries extends Table with TableInfo<Countries, Country> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Countries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
    'name_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [code, nameEn, nameFr, nameAr];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'countries';
  @override
  VerificationContext validateIntegrity(Insertable<Country> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(_codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta, nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(_nameFrMeta, nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta, nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Country map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Country(
      code: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      ),
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
    );
  }

  @override
  Countries createAlias(String alias) {
    return Countries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Country extends DataClass implements Insertable<Country> {
  final String code;
  final String nameEn;
  final String? nameFr;
  final String? nameAr;
  const Country({required this.code, required this.nameEn, this.nameFr, this.nameAr});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || nameFr != null) {
      map['name_fr'] = Variable<String>(nameFr);
    }
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    return map;
  }

  CountriesCompanion toCompanion(bool nullToAbsent) {
    return CountriesCompanion(
      code: Value(code),
      nameEn: Value(nameEn),
      nameFr: nameFr == null && nullToAbsent ? const Value.absent() : Value(nameFr),
      nameAr: nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
    );
  }

  factory Country.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Country(
      code: serializer.fromJson<String>(json['code']),
      nameEn: serializer.fromJson<String>(json['name_en']),
      nameFr: serializer.fromJson<String?>(json['name_fr']),
      nameAr: serializer.fromJson<String?>(json['name_ar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name_en': serializer.toJson<String>(nameEn),
      'name_fr': serializer.toJson<String?>(nameFr),
      'name_ar': serializer.toJson<String?>(nameAr),
    };
  }

  Country copyWith({
    String? code,
    String? nameEn,
    Value<String?> nameFr = const Value.absent(),
    Value<String?> nameAr = const Value.absent(),
  }) => Country(
    code: code ?? this.code,
    nameEn: nameEn ?? this.nameEn,
    nameFr: nameFr.present ? nameFr.value : this.nameFr,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
  );
  Country copyWithCompanion(CountriesCompanion data) {
    return Country(
      code: data.code.present ? data.code.value : this.code,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Country(')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameAr: $nameAr')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, nameEn, nameFr, nameAr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Country &&
          other.code == this.code &&
          other.nameEn == this.nameEn &&
          other.nameFr == this.nameFr &&
          other.nameAr == this.nameAr);
}

class CountriesCompanion extends UpdateCompanion<Country> {
  final Value<String> code;
  final Value<String> nameEn;
  final Value<String?> nameFr;
  final Value<String?> nameAr;
  final Value<int> rowid;
  const CountriesCompanion({
    this.code = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CountriesCompanion.insert({
    required String code,
    required String nameEn,
    this.nameFr = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       nameEn = Value(nameEn);
  static Insertable<Country> custom({
    Expression<String>? code,
    Expression<String>? nameEn,
    Expression<String>? nameFr,
    Expression<String>? nameAr,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (nameEn != null) 'name_en': nameEn,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameAr != null) 'name_ar': nameAr,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CountriesCompanion copyWith({
    Value<String>? code,
    Value<String>? nameEn,
    Value<String?>? nameFr,
    Value<String?>? nameAr,
    Value<int>? rowid,
  }) {
    return CountriesCompanion(
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameFr: nameFr ?? this.nameFr,
      nameAr: nameAr ?? this.nameAr,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountriesCompanion(')
          ..write('code: $code, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameAr: $nameAr, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Cities extends Table with TableInfo<Cities, City> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Cities(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
    'name_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta('countryCode');
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES countries(code)',
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta('timezone');
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _populationMeta = const VerificationMeta('population');
  late final GeneratedColumn<int> population = GeneratedColumn<int>(
    'population',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _searchKeyMeta = const VerificationMeta('searchKey');
  late final GeneratedColumn<String> searchKey = GeneratedColumn<String>(
    'search_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameFr,
    nameAr,
    countryCode,
    latitude,
    longitude,
    timezone,
    population,
    searchKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cities';
  @override
  VerificationContext validateIntegrity(Insertable<City> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(_nameFrMeta, nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta));
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta, nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(data['country_code']!, _countryCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_countryCodeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('population')) {
      context.handle(
        _populationMeta,
        population.isAcceptableOrUnknown(data['population']!, _populationMeta),
      );
    } else if (isInserting) {
      context.missing(_populationMeta);
    }
    if (data.containsKey('search_key')) {
      context.handle(
        _searchKeyMeta,
        searchKey.isAcceptableOrUnknown(data['search_key']!, _searchKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_searchKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  City map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return City(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      ),
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      ),
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      population: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}population'],
      )!,
      searchKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_key'],
      )!,
    );
  }

  @override
  Cities createAlias(String alias) {
    return Cities(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class City extends DataClass implements Insertable<City> {
  final int id;
  final String name;
  final String? nameFr;
  final String? nameAr;
  final String countryCode;
  final double latitude;
  final double longitude;
  final String timezone;
  final int population;
  final String searchKey;
  const City({
    required this.id,
    required this.name,
    this.nameFr,
    this.nameAr,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.population,
    required this.searchKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameFr != null) {
      map['name_fr'] = Variable<String>(nameFr);
    }
    if (!nullToAbsent || nameAr != null) {
      map['name_ar'] = Variable<String>(nameAr);
    }
    map['country_code'] = Variable<String>(countryCode);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['timezone'] = Variable<String>(timezone);
    map['population'] = Variable<int>(population);
    map['search_key'] = Variable<String>(searchKey);
    return map;
  }

  CitiesCompanion toCompanion(bool nullToAbsent) {
    return CitiesCompanion(
      id: Value(id),
      name: Value(name),
      nameFr: nameFr == null && nullToAbsent ? const Value.absent() : Value(nameFr),
      nameAr: nameAr == null && nullToAbsent ? const Value.absent() : Value(nameAr),
      countryCode: Value(countryCode),
      latitude: Value(latitude),
      longitude: Value(longitude),
      timezone: Value(timezone),
      population: Value(population),
      searchKey: Value(searchKey),
    );
  }

  factory City.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return City(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameFr: serializer.fromJson<String?>(json['name_fr']),
      nameAr: serializer.fromJson<String?>(json['name_ar']),
      countryCode: serializer.fromJson<String>(json['country_code']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      timezone: serializer.fromJson<String>(json['timezone']),
      population: serializer.fromJson<int>(json['population']),
      searchKey: serializer.fromJson<String>(json['search_key']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'name_fr': serializer.toJson<String?>(nameFr),
      'name_ar': serializer.toJson<String?>(nameAr),
      'country_code': serializer.toJson<String>(countryCode),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'timezone': serializer.toJson<String>(timezone),
      'population': serializer.toJson<int>(population),
      'search_key': serializer.toJson<String>(searchKey),
    };
  }

  City copyWith({
    int? id,
    String? name,
    Value<String?> nameFr = const Value.absent(),
    Value<String?> nameAr = const Value.absent(),
    String? countryCode,
    double? latitude,
    double? longitude,
    String? timezone,
    int? population,
    String? searchKey,
  }) => City(
    id: id ?? this.id,
    name: name ?? this.name,
    nameFr: nameFr.present ? nameFr.value : this.nameFr,
    nameAr: nameAr.present ? nameAr.value : this.nameAr,
    countryCode: countryCode ?? this.countryCode,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    timezone: timezone ?? this.timezone,
    population: population ?? this.population,
    searchKey: searchKey ?? this.searchKey,
  );
  City copyWithCompanion(CitiesCompanion data) {
    return City(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      countryCode: data.countryCode.present ? data.countryCode.value : this.countryCode,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      population: data.population.present ? data.population.value : this.population,
      searchKey: data.searchKey.present ? data.searchKey.value : this.searchKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('City(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameAr: $nameAr, ')
          ..write('countryCode: $countryCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timezone: $timezone, ')
          ..write('population: $population, ')
          ..write('searchKey: $searchKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameFr,
    nameAr,
    countryCode,
    latitude,
    longitude,
    timezone,
    population,
    searchKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is City &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameFr == this.nameFr &&
          other.nameAr == this.nameAr &&
          other.countryCode == this.countryCode &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.timezone == this.timezone &&
          other.population == this.population &&
          other.searchKey == this.searchKey);
}

class CitiesCompanion extends UpdateCompanion<City> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nameFr;
  final Value<String?> nameAr;
  final Value<String> countryCode;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> timezone;
  final Value<int> population;
  final Value<String> searchKey;
  const CitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.timezone = const Value.absent(),
    this.population = const Value.absent(),
    this.searchKey = const Value.absent(),
  });
  CitiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameFr = const Value.absent(),
    this.nameAr = const Value.absent(),
    required String countryCode,
    required double latitude,
    required double longitude,
    required String timezone,
    required int population,
    required String searchKey,
  }) : name = Value(name),
       countryCode = Value(countryCode),
       latitude = Value(latitude),
       longitude = Value(longitude),
       timezone = Value(timezone),
       population = Value(population),
       searchKey = Value(searchKey);
  static Insertable<City> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameFr,
    Expression<String>? nameAr,
    Expression<String>? countryCode,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? timezone,
    Expression<int>? population,
    Expression<String>? searchKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameAr != null) 'name_ar': nameAr,
      if (countryCode != null) 'country_code': countryCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (timezone != null) 'timezone': timezone,
      if (population != null) 'population': population,
      if (searchKey != null) 'search_key': searchKey,
    });
  }

  CitiesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? nameFr,
    Value<String?>? nameAr,
    Value<String>? countryCode,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String>? timezone,
    Value<int>? population,
    Value<String>? searchKey,
  }) {
    return CitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameFr: nameFr ?? this.nameFr,
      nameAr: nameAr ?? this.nameAr,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      population: population ?? this.population,
      searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (population.present) {
      map['population'] = Variable<int>(population.value);
    }
    if (searchKey.present) {
      map['search_key'] = Variable<String>(searchKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameAr: $nameAr, ')
          ..write('countryCode: $countryCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timezone: $timezone, ')
          ..write('population: $population, ')
          ..write('searchKey: $searchKey')
          ..write(')'))
        .toString();
  }
}

class AdhkarCategories extends Table with TableInfo<AdhkarCategories, AdhkarCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AdhkarCategories(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta('titleAr');
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta('titleEn');
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _titleFrMeta = const VerificationMeta('titleFr');
  late final GeneratedColumn<String> titleFr = GeneratedColumn<String>(
    'title_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _itemCountMeta = const VerificationMeta('itemCount');
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
    'item_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, position, titleAr, titleEn, titleFr, itemCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'adhkar_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdhkarCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title_ar')) {
      context.handle(_titleArMeta, titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta));
    } else if (isInserting) {
      context.missing(_titleArMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(_titleEnMeta, titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta));
    } else if (isInserting) {
      context.missing(_titleEnMeta);
    }
    if (data.containsKey('title_fr')) {
      context.handle(_titleFrMeta, titleFr.isAcceptableOrUnknown(data['title_fr']!, _titleFrMeta));
    }
    if (data.containsKey('item_count')) {
      context.handle(
        _itemCountMeta,
        itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta),
      );
    } else if (isInserting) {
      context.missing(_itemCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdhkarCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdhkarCategory(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      )!,
      titleFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_fr'],
      ),
      itemCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_count'],
      )!,
    );
  }

  @override
  AdhkarCategories createAlias(String alias) {
    return AdhkarCategories(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AdhkarCategory extends DataClass implements Insertable<AdhkarCategory> {
  final int id;
  final int position;
  final String titleAr;
  final String titleEn;
  final String? titleFr;
  final int itemCount;
  const AdhkarCategory({
    required this.id,
    required this.position,
    required this.titleAr,
    required this.titleEn,
    this.titleFr,
    required this.itemCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['position'] = Variable<int>(position);
    map['title_ar'] = Variable<String>(titleAr);
    map['title_en'] = Variable<String>(titleEn);
    if (!nullToAbsent || titleFr != null) {
      map['title_fr'] = Variable<String>(titleFr);
    }
    map['item_count'] = Variable<int>(itemCount);
    return map;
  }

  AdhkarCategoriesCompanion toCompanion(bool nullToAbsent) {
    return AdhkarCategoriesCompanion(
      id: Value(id),
      position: Value(position),
      titleAr: Value(titleAr),
      titleEn: Value(titleEn),
      titleFr: titleFr == null && nullToAbsent ? const Value.absent() : Value(titleFr),
      itemCount: Value(itemCount),
    );
  }

  factory AdhkarCategory.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdhkarCategory(
      id: serializer.fromJson<int>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      titleAr: serializer.fromJson<String>(json['title_ar']),
      titleEn: serializer.fromJson<String>(json['title_en']),
      titleFr: serializer.fromJson<String?>(json['title_fr']),
      itemCount: serializer.fromJson<int>(json['item_count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'position': serializer.toJson<int>(position),
      'title_ar': serializer.toJson<String>(titleAr),
      'title_en': serializer.toJson<String>(titleEn),
      'title_fr': serializer.toJson<String?>(titleFr),
      'item_count': serializer.toJson<int>(itemCount),
    };
  }

  AdhkarCategory copyWith({
    int? id,
    int? position,
    String? titleAr,
    String? titleEn,
    Value<String?> titleFr = const Value.absent(),
    int? itemCount,
  }) => AdhkarCategory(
    id: id ?? this.id,
    position: position ?? this.position,
    titleAr: titleAr ?? this.titleAr,
    titleEn: titleEn ?? this.titleEn,
    titleFr: titleFr.present ? titleFr.value : this.titleFr,
    itemCount: itemCount ?? this.itemCount,
  );
  AdhkarCategory copyWithCompanion(AdhkarCategoriesCompanion data) {
    return AdhkarCategory(
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleFr: data.titleFr.present ? data.titleFr.value : this.titleFr,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdhkarCategory(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('titleAr: $titleAr, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleFr: $titleFr, ')
          ..write('itemCount: $itemCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, position, titleAr, titleEn, titleFr, itemCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdhkarCategory &&
          other.id == this.id &&
          other.position == this.position &&
          other.titleAr == this.titleAr &&
          other.titleEn == this.titleEn &&
          other.titleFr == this.titleFr &&
          other.itemCount == this.itemCount);
}

class AdhkarCategoriesCompanion extends UpdateCompanion<AdhkarCategory> {
  final Value<int> id;
  final Value<int> position;
  final Value<String> titleAr;
  final Value<String> titleEn;
  final Value<String?> titleFr;
  final Value<int> itemCount;
  const AdhkarCategoriesCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleFr = const Value.absent(),
    this.itemCount = const Value.absent(),
  });
  AdhkarCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int position,
    required String titleAr,
    required String titleEn,
    this.titleFr = const Value.absent(),
    required int itemCount,
  }) : position = Value(position),
       titleAr = Value(titleAr),
       titleEn = Value(titleEn),
       itemCount = Value(itemCount);
  static Insertable<AdhkarCategory> custom({
    Expression<int>? id,
    Expression<int>? position,
    Expression<String>? titleAr,
    Expression<String>? titleEn,
    Expression<String>? titleFr,
    Expression<int>? itemCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (titleAr != null) 'title_ar': titleAr,
      if (titleEn != null) 'title_en': titleEn,
      if (titleFr != null) 'title_fr': titleFr,
      if (itemCount != null) 'item_count': itemCount,
    });
  }

  AdhkarCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? position,
    Value<String>? titleAr,
    Value<String>? titleEn,
    Value<String?>? titleFr,
    Value<int>? itemCount,
  }) {
    return AdhkarCategoriesCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      titleFr: titleFr ?? this.titleFr,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleFr.present) {
      map['title_fr'] = Variable<String>(titleFr.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdhkarCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('titleAr: $titleAr, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleFr: $titleFr, ')
          ..write('itemCount: $itemCount')
          ..write(')'))
        .toString();
  }
}

class Adhkar extends Table with TableInfo<Adhkar, AdhkarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Adhkar(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES adhkar_categories(id)',
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _textArMeta = const VerificationMeta('textAr');
  late final GeneratedColumn<String> textAr = GeneratedColumn<String>(
    'text_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _transliterationMeta = const VerificationMeta('transliteration');
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _textEnMeta = const VerificationMeta('textEn');
  late final GeneratedColumn<String> textEn = GeneratedColumn<String>(
    'text_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _textFrMeta = const VerificationMeta('textFr');
  late final GeneratedColumn<String> textFr = GeneratedColumn<String>(
    'text_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _repeatCountMeta = const VerificationMeta('repeatCount');
  late final GeneratedColumn<int> repeatCount = GeneratedColumn<int>(
    'repeat_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    position,
    textAr,
    transliteration,
    textEn,
    textFr,
    repeatCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'adhkar';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdhkarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('text_ar')) {
      context.handle(_textArMeta, textAr.isAcceptableOrUnknown(data['text_ar']!, _textArMeta));
    } else if (isInserting) {
      context.missing(_textArMeta);
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(data['transliteration']!, _transliterationMeta),
      );
    }
    if (data.containsKey('text_en')) {
      context.handle(_textEnMeta, textEn.isAcceptableOrUnknown(data['text_en']!, _textEnMeta));
    }
    if (data.containsKey('text_fr')) {
      context.handle(_textFrMeta, textFr.isAcceptableOrUnknown(data['text_fr']!, _textFrMeta));
    }
    if (data.containsKey('repeat_count')) {
      context.handle(
        _repeatCountMeta,
        repeatCount.isAcceptableOrUnknown(data['repeat_count']!, _repeatCountMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdhkarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdhkarData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      textAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_ar'],
      )!,
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      ),
      textEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_en'],
      ),
      textFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_fr'],
      ),
      repeatCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_count'],
      )!,
    );
  }

  @override
  Adhkar createAlias(String alias) {
    return Adhkar(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AdhkarData extends DataClass implements Insertable<AdhkarData> {
  final int id;
  final int category;
  final int position;
  final String textAr;
  final String? transliteration;
  final String? textEn;
  final String? textFr;
  final int repeatCount;
  const AdhkarData({
    required this.id,
    required this.category,
    required this.position,
    required this.textAr,
    this.transliteration,
    this.textEn,
    this.textFr,
    required this.repeatCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<int>(category);
    map['position'] = Variable<int>(position);
    map['text_ar'] = Variable<String>(textAr);
    if (!nullToAbsent || transliteration != null) {
      map['transliteration'] = Variable<String>(transliteration);
    }
    if (!nullToAbsent || textEn != null) {
      map['text_en'] = Variable<String>(textEn);
    }
    if (!nullToAbsent || textFr != null) {
      map['text_fr'] = Variable<String>(textFr);
    }
    map['repeat_count'] = Variable<int>(repeatCount);
    return map;
  }

  AdhkarCompanion toCompanion(bool nullToAbsent) {
    return AdhkarCompanion(
      id: Value(id),
      category: Value(category),
      position: Value(position),
      textAr: Value(textAr),
      transliteration: transliteration == null && nullToAbsent
          ? const Value.absent()
          : Value(transliteration),
      textEn: textEn == null && nullToAbsent ? const Value.absent() : Value(textEn),
      textFr: textFr == null && nullToAbsent ? const Value.absent() : Value(textFr),
      repeatCount: Value(repeatCount),
    );
  }

  factory AdhkarData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdhkarData(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<int>(json['category']),
      position: serializer.fromJson<int>(json['position']),
      textAr: serializer.fromJson<String>(json['text_ar']),
      transliteration: serializer.fromJson<String?>(json['transliteration']),
      textEn: serializer.fromJson<String?>(json['text_en']),
      textFr: serializer.fromJson<String?>(json['text_fr']),
      repeatCount: serializer.fromJson<int>(json['repeat_count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<int>(category),
      'position': serializer.toJson<int>(position),
      'text_ar': serializer.toJson<String>(textAr),
      'transliteration': serializer.toJson<String?>(transliteration),
      'text_en': serializer.toJson<String?>(textEn),
      'text_fr': serializer.toJson<String?>(textFr),
      'repeat_count': serializer.toJson<int>(repeatCount),
    };
  }

  AdhkarData copyWith({
    int? id,
    int? category,
    int? position,
    String? textAr,
    Value<String?> transliteration = const Value.absent(),
    Value<String?> textEn = const Value.absent(),
    Value<String?> textFr = const Value.absent(),
    int? repeatCount,
  }) => AdhkarData(
    id: id ?? this.id,
    category: category ?? this.category,
    position: position ?? this.position,
    textAr: textAr ?? this.textAr,
    transliteration: transliteration.present ? transliteration.value : this.transliteration,
    textEn: textEn.present ? textEn.value : this.textEn,
    textFr: textFr.present ? textFr.value : this.textFr,
    repeatCount: repeatCount ?? this.repeatCount,
  );
  AdhkarData copyWithCompanion(AdhkarCompanion data) {
    return AdhkarData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      position: data.position.present ? data.position.value : this.position,
      textAr: data.textAr.present ? data.textAr.value : this.textAr,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      textEn: data.textEn.present ? data.textEn.value : this.textEn,
      textFr: data.textFr.present ? data.textFr.value : this.textFr,
      repeatCount: data.repeatCount.present ? data.repeatCount.value : this.repeatCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdhkarData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('position: $position, ')
          ..write('textAr: $textAr, ')
          ..write('transliteration: $transliteration, ')
          ..write('textEn: $textEn, ')
          ..write('textFr: $textFr, ')
          ..write('repeatCount: $repeatCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, category, position, textAr, transliteration, textEn, textFr, repeatCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdhkarData &&
          other.id == this.id &&
          other.category == this.category &&
          other.position == this.position &&
          other.textAr == this.textAr &&
          other.transliteration == this.transliteration &&
          other.textEn == this.textEn &&
          other.textFr == this.textFr &&
          other.repeatCount == this.repeatCount);
}

class AdhkarCompanion extends UpdateCompanion<AdhkarData> {
  final Value<int> id;
  final Value<int> category;
  final Value<int> position;
  final Value<String> textAr;
  final Value<String?> transliteration;
  final Value<String?> textEn;
  final Value<String?> textFr;
  final Value<int> repeatCount;
  const AdhkarCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.position = const Value.absent(),
    this.textAr = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.textEn = const Value.absent(),
    this.textFr = const Value.absent(),
    this.repeatCount = const Value.absent(),
  });
  AdhkarCompanion.insert({
    this.id = const Value.absent(),
    required int category,
    required int position,
    required String textAr,
    this.transliteration = const Value.absent(),
    this.textEn = const Value.absent(),
    this.textFr = const Value.absent(),
    required int repeatCount,
  }) : category = Value(category),
       position = Value(position),
       textAr = Value(textAr),
       repeatCount = Value(repeatCount);
  static Insertable<AdhkarData> custom({
    Expression<int>? id,
    Expression<int>? category,
    Expression<int>? position,
    Expression<String>? textAr,
    Expression<String>? transliteration,
    Expression<String>? textEn,
    Expression<String>? textFr,
    Expression<int>? repeatCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (position != null) 'position': position,
      if (textAr != null) 'text_ar': textAr,
      if (transliteration != null) 'transliteration': transliteration,
      if (textEn != null) 'text_en': textEn,
      if (textFr != null) 'text_fr': textFr,
      if (repeatCount != null) 'repeat_count': repeatCount,
    });
  }

  AdhkarCompanion copyWith({
    Value<int>? id,
    Value<int>? category,
    Value<int>? position,
    Value<String>? textAr,
    Value<String?>? transliteration,
    Value<String?>? textEn,
    Value<String?>? textFr,
    Value<int>? repeatCount,
  }) {
    return AdhkarCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      position: position ?? this.position,
      textAr: textAr ?? this.textAr,
      transliteration: transliteration ?? this.transliteration,
      textEn: textEn ?? this.textEn,
      textFr: textFr ?? this.textFr,
      repeatCount: repeatCount ?? this.repeatCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (textAr.present) {
      map['text_ar'] = Variable<String>(textAr.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (textEn.present) {
      map['text_en'] = Variable<String>(textEn.value);
    }
    if (textFr.present) {
      map['text_fr'] = Variable<String>(textFr.value);
    }
    if (repeatCount.present) {
      map['repeat_count'] = Variable<int>(repeatCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdhkarCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('position: $position, ')
          ..write('textAr: $textAr, ')
          ..write('transliteration: $transliteration, ')
          ..write('textEn: $textEn, ')
          ..write('textFr: $textFr, ')
          ..write('repeatCount: $repeatCount')
          ..write(')'))
        .toString();
  }
}

class AyahSearch extends Table
    with TableInfo<AyahSearch, AyahSearchData>, VirtualTableInfo<AyahSearch, AyahSearchData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AyahSearch(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _arMeta = const VerificationMeta('ar');
  late final GeneratedColumn<String> ar = GeneratedColumn<String>(
    'ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _frMeta = const VerificationMeta('fr');
  late final GeneratedColumn<String> fr = GeneratedColumn<String>(
    'fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _enMeta = const VerificationMeta('en');
  late final GeneratedColumn<String> en = GeneratedColumn<String>(
    'en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [ar, fr, en];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayah_search';
  @override
  VerificationContext validateIntegrity(
    Insertable<AyahSearchData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ar')) {
      context.handle(_arMeta, ar.isAcceptableOrUnknown(data['ar']!, _arMeta));
    } else if (isInserting) {
      context.missing(_arMeta);
    }
    if (data.containsKey('fr')) {
      context.handle(_frMeta, fr.isAcceptableOrUnknown(data['fr']!, _frMeta));
    } else if (isInserting) {
      context.missing(_frMeta);
    }
    if (data.containsKey('en')) {
      context.handle(_enMeta, en.isAcceptableOrUnknown(data['en']!, _enMeta));
    } else if (isInserting) {
      context.missing(_enMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AyahSearchData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahSearchData(
      ar: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}ar'])!,
      fr: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}fr'])!,
      en: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}en'])!,
    );
  }

  @override
  AyahSearch createAlias(String alias) {
    return AyahSearch(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(ar, fr, en, content = \'\', detail = \'none\', tokenize = \'unicode61 remove_diacritics 2\')';
}

class AyahSearchData extends DataClass implements Insertable<AyahSearchData> {
  final String ar;
  final String fr;
  final String en;
  const AyahSearchData({required this.ar, required this.fr, required this.en});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ar'] = Variable<String>(ar);
    map['fr'] = Variable<String>(fr);
    map['en'] = Variable<String>(en);
    return map;
  }

  AyahSearchCompanion toCompanion(bool nullToAbsent) {
    return AyahSearchCompanion(ar: Value(ar), fr: Value(fr), en: Value(en));
  }

  factory AyahSearchData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahSearchData(
      ar: serializer.fromJson<String>(json['ar']),
      fr: serializer.fromJson<String>(json['fr']),
      en: serializer.fromJson<String>(json['en']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ar': serializer.toJson<String>(ar),
      'fr': serializer.toJson<String>(fr),
      'en': serializer.toJson<String>(en),
    };
  }

  AyahSearchData copyWith({String? ar, String? fr, String? en}) =>
      AyahSearchData(ar: ar ?? this.ar, fr: fr ?? this.fr, en: en ?? this.en);
  AyahSearchData copyWithCompanion(AyahSearchCompanion data) {
    return AyahSearchData(
      ar: data.ar.present ? data.ar.value : this.ar,
      fr: data.fr.present ? data.fr.value : this.fr,
      en: data.en.present ? data.en.value : this.en,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AyahSearchData(')
          ..write('ar: $ar, ')
          ..write('fr: $fr, ')
          ..write('en: $en')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ar, fr, en);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahSearchData &&
          other.ar == this.ar &&
          other.fr == this.fr &&
          other.en == this.en);
}

class AyahSearchCompanion extends UpdateCompanion<AyahSearchData> {
  final Value<String> ar;
  final Value<String> fr;
  final Value<String> en;
  final Value<int> rowid;
  const AyahSearchCompanion({
    this.ar = const Value.absent(),
    this.fr = const Value.absent(),
    this.en = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AyahSearchCompanion.insert({
    required String ar,
    required String fr,
    required String en,
    this.rowid = const Value.absent(),
  }) : ar = Value(ar),
       fr = Value(fr),
       en = Value(en);
  static Insertable<AyahSearchData> custom({
    Expression<String>? ar,
    Expression<String>? fr,
    Expression<String>? en,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ar != null) 'ar': ar,
      if (fr != null) 'fr': fr,
      if (en != null) 'en': en,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AyahSearchCompanion copyWith({
    Value<String>? ar,
    Value<String>? fr,
    Value<String>? en,
    Value<int>? rowid,
  }) {
    return AyahSearchCompanion(
      ar: ar ?? this.ar,
      fr: fr ?? this.fr,
      en: en ?? this.en,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ar.present) {
      map['ar'] = Variable<String>(ar.value);
    }
    if (fr.present) {
      map['fr'] = Variable<String>(fr.value);
    }
    if (en.present) {
      map['en'] = Variable<String>(en.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahSearchCompanion(')
          ..write('ar: $ar, ')
          ..write('fr: $fr, ')
          ..write('en: $en, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ContentDatabase extends GeneratedDatabase {
  _$ContentDatabase(QueryExecutor e) : super(e);
  $ContentDatabaseManager get managers => $ContentDatabaseManager(this);
  late final MetaEntries metaEntries = MetaEntries(this);
  late final Surahs surahs = Surahs(this);
  late final Ayahs ayahs = Ayahs(this);
  late final TranslationEditions translationEditions = TranslationEditions(this);
  late final AyahTranslations ayahTranslations = AyahTranslations(this);
  late final Countries countries = Countries(this);
  late final Cities cities = Cities(this);
  late final AdhkarCategories adhkarCategories = AdhkarCategories(this);
  late final Adhkar adhkar = Adhkar(this);
  late final AyahSearch ayahSearch = AyahSearch(this);
  late final Index ayahsSurahNumber = Index(
    'ayahs_surah_number',
    'CREATE UNIQUE INDEX ayahs_surah_number ON ayahs (surah, number)',
  );
  late final Index ayahsPage = Index('ayahs_page', 'CREATE INDEX ayahs_page ON ayahs (page)');
  late final Index citiesPopulation = Index(
    'cities_population',
    'CREATE INDEX cities_population ON cities (population DESC)',
  );
  late final Index citiesLatitude = Index(
    'cities_latitude',
    'CREATE INDEX cities_latitude ON cities (latitude)',
  );
  late final Index adhkarCategory = Index(
    'adhkar_category',
    'CREATE INDEX adhkar_category ON adhkar (category, position)',
  );
  Selectable<String> metaValue({required String key}) {
    return customSelect(
      'SELECT value FROM meta_entries WHERE "key" = ?1',
      variables: [Variable<String>(key)],
      readsFrom: {this.metaEntries},
    ).map((QueryRow row) => row.read<String>('value'));
  }

  Selectable<String> basmala() {
    return customSelect(
      'SELECT text_uthmani FROM ayahs WHERE id = 1',
      variables: [],
      readsFrom: {this.ayahs},
    ).map((QueryRow row) => row.read<String>('text_uthmani'));
  }

  Selectable<String> basmalaTranslation({required String edition}) {
    return customSelect(
      'SELECT content FROM ayah_translations WHERE ayah_id = 1 AND edition = ?1',
      variables: [Variable<String>(edition)],
      readsFrom: {this.ayahTranslations},
    ).map((QueryRow row) => row.read<String>('content'));
  }

  Selectable<Surah> allSurahs() {
    return customSelect(
      'SELECT * FROM surahs ORDER BY id',
      variables: [],
      readsFrom: {this.surahs},
    ).asyncMap(this.surahs.mapFromRow);
  }

  Selectable<SurahStartPagesResult> surahStartPages() {
    return customSelect(
      'SELECT surah, MIN(page) AS page FROM ayahs GROUP BY surah ORDER BY surah',
      variables: [],
      readsFrom: {this.ayahs},
    ).map(
      (QueryRow row) =>
          SurahStartPagesResult(surah: row.read<int>('surah'), page: row.readNullable<int>('page')),
    );
  }

  Selectable<AyahsOfPageResult> ayahsOfPage({String? edition, required int page}) {
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."surah" AS "nested_0.surah", "a"."number" AS "nested_0.number", "a"."text_uthmani" AS "nested_0.text_uthmani", "a"."text_search" AS "nested_0.text_search", "a"."juz" AS "nested_0.juz", "a"."hizb_quarter" AS "nested_0.hizb_quarter", "a"."page" AS "nested_0.page", "a"."sajda" AS "nested_0.sajda", t.content AS translation FROM ayahs AS a LEFT JOIN ayah_translations AS t ON t.ayah_id = a.id AND t.edition = ?1 WHERE a.page = ?2 ORDER BY a.id',
      variables: [Variable<String>(edition), Variable<int>(page)],
      readsFrom: {this.ayahTranslations, this.ayahs},
    ).asyncMap(
      (QueryRow row) async => AyahsOfPageResult(
        a: await this.ayahs.mapFromRow(row, tablePrefix: 'nested_0'),
        translation: row.readNullable<String>('translation'),
      ),
    );
  }

  Selectable<JuzStartsResult> juzStarts() {
    return customSelect(
      'SELECT a.juz, a.surah, a.number, a.page, a.text_uthmani, s.name_ar, s.name_translit FROM ayahs AS a INNER JOIN surahs AS s ON s.id = a.surah WHERE a.id IN (SELECT MIN(id) FROM ayahs GROUP BY juz) ORDER BY a.juz',
      variables: [],
      readsFrom: {this.ayahs, this.surahs},
    ).map(
      (QueryRow row) => JuzStartsResult(
        juz: row.read<int>('juz'),
        surah: row.read<int>('surah'),
        number: row.read<int>('number'),
        page: row.read<int>('page'),
        textUthmani: row.read<String>('text_uthmani'),
        nameAr: row.read<String>('name_ar'),
        nameTranslit: row.read<String>('name_translit'),
      ),
    );
  }

  Selectable<HizbStartsResult> hizbStarts() {
    return customSelect(
      'SELECT(a.hizb_quarter + 3)/ 4 AS hizb, a.surah, a.number, a.page, a.text_uthmani, s.name_ar, s.name_translit FROM ayahs AS a INNER JOIN surahs AS s ON s.id = a.surah WHERE a.id IN (SELECT MIN(id) FROM ayahs GROUP BY hizb_quarter) AND a.hizb_quarter % 4 = 1 ORDER BY a.hizb_quarter',
      variables: [],
      readsFrom: {this.ayahs, this.surahs},
    ).map(
      (QueryRow row) => HizbStartsResult(
        hizb: row.read<int>('hizb'),
        surah: row.read<int>('surah'),
        number: row.read<int>('number'),
        page: row.read<int>('page'),
        textUthmani: row.read<String>('text_uthmani'),
        nameAr: row.read<String>('name_ar'),
        nameTranslit: row.read<String>('name_translit'),
      ),
    );
  }

  Selectable<TranslationsOfAyahResult> translationsOfAyah({required int ayahId}) {
    return customSelect(
      'SELECT"e"."id" AS "nested_0.id", "e"."language" AS "nested_0.language", "e"."name" AS "nested_0.name", "e"."translator" AS "nested_0.translator", t.content FROM ayah_translations AS t INNER JOIN translation_editions AS e ON e.id = t.edition WHERE t.ayah_id = ?1 ORDER BY e.language DESC',
      variables: [Variable<int>(ayahId)],
      readsFrom: {this.ayahTranslations, this.translationEditions},
    ).asyncMap(
      (QueryRow row) async => TranslationsOfAyahResult(
        e: await this.translationEditions.mapFromRow(row, tablePrefix: 'nested_0'),
        content: row.read<String>('content'),
      ),
    );
  }

  Selectable<SearchCitiesResult> searchCities({required String pattern, required int limit}) {
    return customSelect(
      'SELECT"c"."id" AS "nested_0.id", "c"."name" AS "nested_0.name", "c"."name_fr" AS "nested_0.name_fr", "c"."name_ar" AS "nested_0.name_ar", "c"."country_code" AS "nested_0.country_code", "c"."latitude" AS "nested_0.latitude", "c"."longitude" AS "nested_0.longitude", "c"."timezone" AS "nested_0.timezone", "c"."population" AS "nested_0.population", "c"."search_key" AS "nested_0.search_key","co"."code" AS "nested_1.code", "co"."name_en" AS "nested_1.name_en", "co"."name_fr" AS "nested_1.name_fr", "co"."name_ar" AS "nested_1.name_ar" FROM cities AS c INNER JOIN countries AS co ON co.code = c.country_code WHERE c.search_key LIKE ?1 ORDER BY c.population DESC LIMIT ?2',
      variables: [Variable<String>(pattern), Variable<int>(limit)],
      readsFrom: {this.cities, this.countries},
    ).asyncMap(
      (QueryRow row) async => SearchCitiesResult(
        c: await this.cities.mapFromRow(row, tablePrefix: 'nested_0'),
        co: await this.countries.mapFromRow(row, tablePrefix: 'nested_1'),
      ),
    );
  }

  Selectable<CitiesInBoxResult> citiesInBox({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) {
    return customSelect(
      'SELECT"c"."id" AS "nested_0.id", "c"."name" AS "nested_0.name", "c"."name_fr" AS "nested_0.name_fr", "c"."name_ar" AS "nested_0.name_ar", "c"."country_code" AS "nested_0.country_code", "c"."latitude" AS "nested_0.latitude", "c"."longitude" AS "nested_0.longitude", "c"."timezone" AS "nested_0.timezone", "c"."population" AS "nested_0.population", "c"."search_key" AS "nested_0.search_key","co"."code" AS "nested_1.code", "co"."name_en" AS "nested_1.name_en", "co"."name_fr" AS "nested_1.name_fr", "co"."name_ar" AS "nested_1.name_ar" FROM cities AS c INNER JOIN countries AS co ON co.code = c.country_code WHERE c.latitude BETWEEN ?1 AND ?2 AND c.longitude BETWEEN ?3 AND ?4',
      variables: [
        Variable<double>(minLat),
        Variable<double>(maxLat),
        Variable<double>(minLng),
        Variable<double>(maxLng),
      ],
      readsFrom: {this.cities, this.countries},
    ).asyncMap(
      (QueryRow row) async => CitiesInBoxResult(
        c: await this.cities.mapFromRow(row, tablePrefix: 'nested_0'),
        co: await this.countries.mapFromRow(row, tablePrefix: 'nested_1'),
      ),
    );
  }

  Selectable<AdhkarCategory> allAdhkarCategories() {
    return customSelect(
      'SELECT * FROM adhkar_categories ORDER BY position',
      variables: [],
      readsFrom: {this.adhkarCategories},
    ).asyncMap(this.adhkarCategories.mapFromRow);
  }

  Selectable<AdhkarData> adhkarOfCategory({required int category}) {
    return customSelect(
      'SELECT * FROM adhkar WHERE category = ?1 ORDER BY position',
      variables: [Variable<int>(category)],
      readsFrom: {this.adhkar},
    ).asyncMap(this.adhkar.mapFromRow);
  }

  Selectable<AyahByReferenceResult> ayahByReference({
    String? edition,
    required int surah,
    required int number,
  }) {
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."surah" AS "nested_0.surah", "a"."number" AS "nested_0.number", "a"."text_uthmani" AS "nested_0.text_uthmani", "a"."text_search" AS "nested_0.text_search", "a"."juz" AS "nested_0.juz", "a"."hizb_quarter" AS "nested_0.hizb_quarter", "a"."page" AS "nested_0.page", "a"."sajda" AS "nested_0.sajda", t.content AS translation FROM ayahs AS a LEFT JOIN ayah_translations AS t ON t.ayah_id = a.id AND t.edition = ?1 WHERE a.surah = ?2 AND a.number = ?3',
      variables: [Variable<String>(edition), Variable<int>(surah), Variable<int>(number)],
      readsFrom: {this.ayahTranslations, this.ayahs},
    ).asyncMap(
      (QueryRow row) async => AyahByReferenceResult(
        a: await this.ayahs.mapFromRow(row, tablePrefix: 'nested_0'),
        translation: row.readNullable<String>('translation'),
      ),
    );
  }

  Selectable<SearchAyahsResult> searchAyahs({
    String? edition,
    required String query,
    required int limit,
  }) {
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."surah" AS "nested_0.surah", "a"."number" AS "nested_0.number", "a"."text_uthmani" AS "nested_0.text_uthmani", "a"."text_search" AS "nested_0.text_search", "a"."juz" AS "nested_0.juz", "a"."hizb_quarter" AS "nested_0.hizb_quarter", "a"."page" AS "nested_0.page", "a"."sajda" AS "nested_0.sajda", t.content AS translation FROM ayah_search AS s INNER JOIN ayahs AS a ON a.id = s."rowid" LEFT JOIN ayah_translations AS t ON t.ayah_id = a.id AND t.edition = ?1 WHERE ayah_search MATCH ?2 ORDER BY a.id LIMIT ?3',
      variables: [Variable<String>(edition), Variable<String>(query), Variable<int>(limit)],
      readsFrom: {this.ayahTranslations, this.ayahSearch, this.ayahs},
    ).asyncMap(
      (QueryRow row) async => SearchAyahsResult(
        a: await this.ayahs.mapFromRow(row, tablePrefix: 'nested_0'),
        translation: row.readNullable<String>('translation'),
      ),
    );
  }

  Selectable<AyahsByIdsResult> ayahsByIds({String? edition, required List<int> ids}) {
    var $arrayStartIndex = 2;
    final expandedids = $expandVar($arrayStartIndex, ids.length);
    $arrayStartIndex += ids.length;
    return customSelect(
      'SELECT"a"."id" AS "nested_0.id", "a"."surah" AS "nested_0.surah", "a"."number" AS "nested_0.number", "a"."text_uthmani" AS "nested_0.text_uthmani", "a"."text_search" AS "nested_0.text_search", "a"."juz" AS "nested_0.juz", "a"."hizb_quarter" AS "nested_0.hizb_quarter", "a"."page" AS "nested_0.page", "a"."sajda" AS "nested_0.sajda", t.content AS translation FROM ayahs AS a LEFT JOIN ayah_translations AS t ON t.ayah_id = a.id AND t.edition = ?1 WHERE a.id IN ($expandedids) ORDER BY a.id',
      variables: [Variable<String>(edition), for (var $ in ids) Variable<int>($)],
      readsFrom: {this.ayahTranslations, this.ayahs},
    ).asyncMap(
      (QueryRow row) async => AyahsByIdsResult(
        a: await this.ayahs.mapFromRow(row, tablePrefix: 'nested_0'),
        translation: row.readNullable<String>('translation'),
      ),
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    metaEntries,
    surahs,
    ayahs,
    translationEditions,
    ayahTranslations,
    countries,
    cities,
    adhkarCategories,
    adhkar,
    ayahSearch,
    ayahsSurahNumber,
    ayahsPage,
    citiesPopulation,
    citiesLatitude,
    adhkarCategory,
  ];
}

typedef $MetaEntriesCreateCompanionBuilder = MetaEntriesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $MetaEntriesUpdateCompanionBuilder = MetaEntriesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $MetaEntriesFilterComposer extends Composer<_$ContentDatabase, MetaEntries> {
  $MetaEntriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $MetaEntriesOrderingComposer extends Composer<_$ContentDatabase, MetaEntries> {
  $MetaEntriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $MetaEntriesAnnotationComposer extends Composer<_$ContentDatabase, MetaEntries> {
  $MetaEntriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $MetaEntriesTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          MetaEntries,
          MetaEntry,
          $MetaEntriesFilterComposer,
          $MetaEntriesOrderingComposer,
          $MetaEntriesAnnotationComposer,
          $MetaEntriesCreateCompanionBuilder,
          $MetaEntriesUpdateCompanionBuilder,
          (MetaEntry, BaseReferences<_$ContentDatabase, MetaEntries, MetaEntry>),
          MetaEntry,
          PrefetchHooks Function()
        > {
  $MetaEntriesTableManager(_$ContentDatabase db, MetaEntries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $MetaEntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $MetaEntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $MetaEntriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MetaEntriesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => MetaEntriesCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<MetaEntries, MetaEntry>(table),
                  BaseReferences<_$ContentDatabase, MetaEntries, MetaEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $MetaEntriesProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      MetaEntries,
      MetaEntry,
      $MetaEntriesFilterComposer,
      $MetaEntriesOrderingComposer,
      $MetaEntriesAnnotationComposer,
      $MetaEntriesCreateCompanionBuilder,
      $MetaEntriesUpdateCompanionBuilder,
      (MetaEntry, BaseReferences<_$ContentDatabase, MetaEntries, MetaEntry>),
      MetaEntry,
      PrefetchHooks Function()
    >;
typedef $SurahsCreateCompanionBuilder = SurahsCompanion Function({
  Value<int> id,
  required String nameAr,
  required String nameTranslit,
  required String nameEn,
  required String revelationType,
  required int revelationOrder,
  required int ayahCount,
  required int firstAyahId,
});
typedef $SurahsUpdateCompanionBuilder = SurahsCompanion Function({
  Value<int> id,
  Value<String> nameAr,
  Value<String> nameTranslit,
  Value<String> nameEn,
  Value<String> revelationType,
  Value<int> revelationOrder,
  Value<int> ayahCount,
  Value<int> firstAyahId,
});

final class $SurahsReferences extends BaseReferences<_$ContentDatabase, Surahs, Surah> {
  $SurahsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Ayahs, List<Ayah>> _ayahsRefsTable(_$ContentDatabase db) =>
      MultiTypedResultKey.fromTable(db.ayahs, aliasName: 'surahs__id__ayahs__surah');

  $AyahsProcessedTableManager get ayahsRefs {
    final manager = $AyahsTableManager(
      $_db,
      $_db.ayahs,
    ).filter((f) => f.surah.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ayahsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $SurahsFilterComposer extends Composer<_$ContentDatabase, Surahs> {
  $SurahsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameTranslit =>
      $composableBuilder(column: $table.nameTranslit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get revelationType =>
      $composableBuilder(column: $table.revelationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revelationOrder => $composableBuilder(
    column: $table.revelationOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahCount =>
      $composableBuilder(column: $table.ayahCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get firstAyahId =>
      $composableBuilder(column: $table.firstAyahId, builder: (column) => ColumnFilters(column));

  Expression<bool> ayahsRefs(Expression<bool> Function($AyahsFilterComposer f) f) {
    final $AyahsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.surah,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahsFilterComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SurahsOrderingComposer extends Composer<_$ContentDatabase, Surahs> {
  $SurahsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameTranslit =>
      $composableBuilder(column: $table.nameTranslit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get revelationType => $composableBuilder(
    column: $table.revelationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revelationOrder => $composableBuilder(
    column: $table.revelationOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahCount =>
      $composableBuilder(column: $table.ayahCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get firstAyahId =>
      $composableBuilder(column: $table.firstAyahId, builder: (column) => ColumnOrderings(column));
}

class $SurahsAnnotationComposer extends Composer<_$ContentDatabase, Surahs> {
  $SurahsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameTranslit =>
      $composableBuilder(column: $table.nameTranslit, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get revelationType =>
      $composableBuilder(column: $table.revelationType, builder: (column) => column);

  GeneratedColumn<int> get revelationOrder =>
      $composableBuilder(column: $table.revelationOrder, builder: (column) => column);

  GeneratedColumn<int> get ayahCount =>
      $composableBuilder(column: $table.ayahCount, builder: (column) => column);

  GeneratedColumn<int> get firstAyahId =>
      $composableBuilder(column: $table.firstAyahId, builder: (column) => column);

  Expression<T> ayahsRefs<T extends Object>(Expression<T> Function($AyahsAnnotationComposer a) f) {
    final $AyahsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.surah,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahsAnnotationComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SurahsTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          Surahs,
          Surah,
          $SurahsFilterComposer,
          $SurahsOrderingComposer,
          $SurahsAnnotationComposer,
          $SurahsCreateCompanionBuilder,
          $SurahsUpdateCompanionBuilder,
          (Surah, $SurahsReferences),
          Surah,
          PrefetchHooks Function({bool ayahsRefs})
        > {
  $SurahsTableManager(_$ContentDatabase db, Surahs table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $SurahsFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $SurahsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $SurahsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameTranslit = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> revelationType = const Value.absent(),
                Value<int> revelationOrder = const Value.absent(),
                Value<int> ayahCount = const Value.absent(),
                Value<int> firstAyahId = const Value.absent(),
              }) => SurahsCompanion(
                id: id,
                nameAr: nameAr,
                nameTranslit: nameTranslit,
                nameEn: nameEn,
                revelationType: revelationType,
                revelationOrder: revelationOrder,
                ayahCount: ayahCount,
                firstAyahId: firstAyahId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameAr,
                required String nameTranslit,
                required String nameEn,
                required String revelationType,
                required int revelationOrder,
                required int ayahCount,
                required int firstAyahId,
              }) => SurahsCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameTranslit: nameTranslit,
                nameEn: nameEn,
                revelationType: revelationType,
                revelationOrder: revelationOrder,
                ayahCount: ayahCount,
                firstAyahId: firstAyahId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<Surahs, Surah>(table), $SurahsReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({ayahsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ayahsRefs) db.ayahs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ayahsRefs)
                    await $_getPrefetchedData<Surah, Surahs, Ayah>(
                      currentTable: table,
                      referencedTable: $SurahsReferences._ayahsRefsTable(db),
                      managerFromTypedResult: (p0) => $SurahsReferences(db, table, p0).ayahsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.surah == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $SurahsProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      Surahs,
      Surah,
      $SurahsFilterComposer,
      $SurahsOrderingComposer,
      $SurahsAnnotationComposer,
      $SurahsCreateCompanionBuilder,
      $SurahsUpdateCompanionBuilder,
      (Surah, $SurahsReferences),
      Surah,
      PrefetchHooks Function({bool ayahsRefs})
    >;
typedef $AyahsCreateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  required int surah,
  required int number,
  required String textUthmani,
  required String textSearch,
  required int juz,
  required int hizbQuarter,
  required int page,
  Value<String?> sajda,
});
typedef $AyahsUpdateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  Value<int> surah,
  Value<int> number,
  Value<String> textUthmani,
  Value<String> textSearch,
  Value<int> juz,
  Value<int> hizbQuarter,
  Value<int> page,
  Value<String?> sajda,
});

final class $AyahsReferences extends BaseReferences<_$ContentDatabase, Ayahs, Ayah> {
  $AyahsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Surahs _surahTable(_$ContentDatabase db) =>
      db.surahs.createAlias('ayahs__surah__surahs__id');

  $SurahsProcessedTableManager get surah {
    final $_column = $_itemColumn<int>('surah')!;

    final manager = $SurahsTableManager($_db, $_db.surahs).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<AyahTranslations, List<AyahTranslation>> _ayahTranslationsRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ayahTranslations,
    aliasName: 'ayahs__id__ayah_translations__ayah_id',
  );

  $AyahTranslationsProcessedTableManager get ayahTranslationsRefs {
    final manager = $AyahTranslationsTableManager(
      $_db,
      $_db.ayahTranslations,
    ).filter((f) => f.ayahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ayahTranslationsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $AyahsFilterComposer extends Composer<_$ContentDatabase, Ayahs> {
  $AyahsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textUthmani =>
      $composableBuilder(column: $table.textUthmani, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textSearch =>
      $composableBuilder(column: $table.textSearch, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get juz =>
      $composableBuilder(column: $table.juz, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hizbQuarter =>
      $composableBuilder(column: $table.hizbQuarter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sajda =>
      $composableBuilder(column: $table.sajda, builder: (column) => ColumnFilters(column));

  $SurahsFilterComposer get surah {
    final $SurahsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surah,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $SurahsFilterComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ayahTranslationsRefs(
    Expression<bool> Function($AyahTranslationsFilterComposer f) f,
  ) {
    final $AyahTranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahTranslations,
      getReferencedColumn: (t) => t.ayahId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahTranslationsFilterComposer(
            $db: $db,
            $table: $db.ayahTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AyahsOrderingComposer extends Composer<_$ContentDatabase, Ayahs> {
  $AyahsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textUthmani =>
      $composableBuilder(column: $table.textUthmani, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textSearch =>
      $composableBuilder(column: $table.textSearch, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get juz =>
      $composableBuilder(column: $table.juz, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hizbQuarter =>
      $composableBuilder(column: $table.hizbQuarter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sajda =>
      $composableBuilder(column: $table.sajda, builder: (column) => ColumnOrderings(column));

  $SurahsOrderingComposer get surah {
    final $SurahsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surah,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $SurahsOrderingComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AyahsAnnotationComposer extends Composer<_$ContentDatabase, Ayahs> {
  $AyahsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get textUthmani =>
      $composableBuilder(column: $table.textUthmani, builder: (column) => column);

  GeneratedColumn<String> get textSearch =>
      $composableBuilder(column: $table.textSearch, builder: (column) => column);

  GeneratedColumn<int> get juz =>
      $composableBuilder(column: $table.juz, builder: (column) => column);

  GeneratedColumn<int> get hizbQuarter =>
      $composableBuilder(column: $table.hizbQuarter, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<String> get sajda =>
      $composableBuilder(column: $table.sajda, builder: (column) => column);

  $SurahsAnnotationComposer get surah {
    final $SurahsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surah,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $SurahsAnnotationComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ayahTranslationsRefs<T extends Object>(
    Expression<T> Function($AyahTranslationsAnnotationComposer a) f,
  ) {
    final $AyahTranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahTranslations,
      getReferencedColumn: (t) => t.ayahId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahTranslationsAnnotationComposer(
            $db: $db,
            $table: $db.ayahTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AyahsTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          Ayahs,
          Ayah,
          $AyahsFilterComposer,
          $AyahsOrderingComposer,
          $AyahsAnnotationComposer,
          $AyahsCreateCompanionBuilder,
          $AyahsUpdateCompanionBuilder,
          (Ayah, $AyahsReferences),
          Ayah,
          PrefetchHooks Function({bool surah, bool ayahTranslationsRefs})
        > {
  $AyahsTableManager(_$ContentDatabase db, Ayahs table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $AyahsFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $AyahsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $AyahsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surah = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> textUthmani = const Value.absent(),
                Value<String> textSearch = const Value.absent(),
                Value<int> juz = const Value.absent(),
                Value<int> hizbQuarter = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<String?> sajda = const Value.absent(),
              }) => AyahsCompanion(
                id: id,
                surah: surah,
                number: number,
                textUthmani: textUthmani,
                textSearch: textSearch,
                juz: juz,
                hizbQuarter: hizbQuarter,
                page: page,
                sajda: sajda,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surah,
                required int number,
                required String textUthmani,
                required String textSearch,
                required int juz,
                required int hizbQuarter,
                required int page,
                Value<String?> sajda = const Value.absent(),
              }) => AyahsCompanion.insert(
                id: id,
                surah: surah,
                number: number,
                textUthmani: textUthmani,
                textSearch: textSearch,
                juz: juz,
                hizbQuarter: hizbQuarter,
                page: page,
                sajda: sajda,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<Ayahs, Ayah>(table), $AyahsReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({surah = false, ayahTranslationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ayahTranslationsRefs) db.ayahTranslations],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (surah) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.surah,
                        referencedTable: $AyahsReferences._surahTable(db),
                        referencedColumn: $AyahsReferences._surahTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ayahTranslationsRefs)
                    await $_getPrefetchedData<Ayah, Ayahs, AyahTranslation>(
                      currentTable: table,
                      referencedTable: $AyahsReferences._ayahTranslationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $AyahsReferences(db, table, p0).ayahTranslationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ayahId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $AyahsProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      Ayahs,
      Ayah,
      $AyahsFilterComposer,
      $AyahsOrderingComposer,
      $AyahsAnnotationComposer,
      $AyahsCreateCompanionBuilder,
      $AyahsUpdateCompanionBuilder,
      (Ayah, $AyahsReferences),
      Ayah,
      PrefetchHooks Function({bool surah, bool ayahTranslationsRefs})
    >;
typedef $TranslationEditionsCreateCompanionBuilder = TranslationEditionsCompanion Function({
  required String id,
  required String language,
  required String name,
  required String translator,
  Value<int> rowid,
});
typedef $TranslationEditionsUpdateCompanionBuilder = TranslationEditionsCompanion Function({
  Value<String> id,
  Value<String> language,
  Value<String> name,
  Value<String> translator,
  Value<int> rowid,
});

final class $TranslationEditionsReferences
    extends BaseReferences<_$ContentDatabase, TranslationEditions, TranslationEdition> {
  $TranslationEditionsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<AyahTranslations, List<AyahTranslation>> _ayahTranslationsRefsTable(
    _$ContentDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ayahTranslations,
    aliasName: 'translation_editions__id__ayah_translations__edition',
  );

  $AyahTranslationsProcessedTableManager get ayahTranslationsRefs {
    final manager = $AyahTranslationsTableManager(
      $_db,
      $_db.ayahTranslations,
    ).filter((f) => f.edition.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ayahTranslationsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $TranslationEditionsFilterComposer extends Composer<_$ContentDatabase, TranslationEditions> {
  $TranslationEditionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translator =>
      $composableBuilder(column: $table.translator, builder: (column) => ColumnFilters(column));

  Expression<bool> ayahTranslationsRefs(
    Expression<bool> Function($AyahTranslationsFilterComposer f) f,
  ) {
    final $AyahTranslationsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahTranslations,
      getReferencedColumn: (t) => t.edition,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahTranslationsFilterComposer(
            $db: $db,
            $table: $db.ayahTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TranslationEditionsOrderingComposer
    extends Composer<_$ContentDatabase, TranslationEditions> {
  $TranslationEditionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translator =>
      $composableBuilder(column: $table.translator, builder: (column) => ColumnOrderings(column));
}

class $TranslationEditionsAnnotationComposer
    extends Composer<_$ContentDatabase, TranslationEditions> {
  $TranslationEditionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get translator =>
      $composableBuilder(column: $table.translator, builder: (column) => column);

  Expression<T> ayahTranslationsRefs<T extends Object>(
    Expression<T> Function($AyahTranslationsAnnotationComposer a) f,
  ) {
    final $AyahTranslationsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ayahTranslations,
      getReferencedColumn: (t) => t.edition,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahTranslationsAnnotationComposer(
            $db: $db,
            $table: $db.ayahTranslations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TranslationEditionsTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          TranslationEditions,
          TranslationEdition,
          $TranslationEditionsFilterComposer,
          $TranslationEditionsOrderingComposer,
          $TranslationEditionsAnnotationComposer,
          $TranslationEditionsCreateCompanionBuilder,
          $TranslationEditionsUpdateCompanionBuilder,
          (TranslationEdition, $TranslationEditionsReferences),
          TranslationEdition,
          PrefetchHooks Function({bool ayahTranslationsRefs})
        > {
  $TranslationEditionsTableManager(_$ContentDatabase db, TranslationEditions table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $TranslationEditionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TranslationEditionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TranslationEditionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> translator = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TranslationEditionsCompanion(
                id: id,
                language: language,
                name: name,
                translator: translator,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String language,
                required String name,
                required String translator,
                Value<int> rowid = const Value.absent(),
              }) => TranslationEditionsCompanion.insert(
                id: id,
                language: language,
                name: name,
                translator: translator,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<TranslationEditions, TranslationEdition>(table),
                  $TranslationEditionsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ayahTranslationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ayahTranslationsRefs) db.ayahTranslations],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ayahTranslationsRefs)
                    await $_getPrefetchedData<
                      TranslationEdition,
                      TranslationEditions,
                      AyahTranslation
                    >(
                      currentTable: table,
                      referencedTable: $TranslationEditionsReferences._ayahTranslationsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $TranslationEditionsReferences(db, table, p0).ayahTranslationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.edition == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $TranslationEditionsProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      TranslationEditions,
      TranslationEdition,
      $TranslationEditionsFilterComposer,
      $TranslationEditionsOrderingComposer,
      $TranslationEditionsAnnotationComposer,
      $TranslationEditionsCreateCompanionBuilder,
      $TranslationEditionsUpdateCompanionBuilder,
      (TranslationEdition, $TranslationEditionsReferences),
      TranslationEdition,
      PrefetchHooks Function({bool ayahTranslationsRefs})
    >;
typedef $AyahTranslationsCreateCompanionBuilder = AyahTranslationsCompanion Function({
  required int ayahId,
  required String edition,
  required String content,
});
typedef $AyahTranslationsUpdateCompanionBuilder = AyahTranslationsCompanion Function({
  Value<int> ayahId,
  Value<String> edition,
  Value<String> content,
});

final class $AyahTranslationsReferences
    extends BaseReferences<_$ContentDatabase, AyahTranslations, AyahTranslation> {
  $AyahTranslationsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Ayahs _ayahIdTable(_$ContentDatabase db) =>
      db.ayahs.createAlias('ayah_translations__ayah_id__ayahs__id');

  $AyahsProcessedTableManager get ayahId {
    final $_column = $_itemColumn<int>('ayah_id')!;

    final manager = $AyahsTableManager($_db, $_db.ayahs).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ayahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static TranslationEditions _editionTable(_$ContentDatabase db) =>
      db.translationEditions.createAlias('ayah_translations__edition__translation_editions__id');

  $TranslationEditionsProcessedTableManager get edition {
    final $_column = $_itemColumn<String>('edition')!;

    final manager = $TranslationEditionsTableManager(
      $_db,
      $_db.translationEditions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_editionTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $AyahTranslationsFilterComposer extends Composer<_$ContentDatabase, AyahTranslations> {
  $AyahTranslationsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => ColumnFilters(column));

  $AyahsFilterComposer get ayahId {
    final $AyahsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ayahId,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahsFilterComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TranslationEditionsFilterComposer get edition {
    final $TranslationEditionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.edition,
      referencedTable: $db.translationEditions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $TranslationEditionsFilterComposer(
            $db: $db,
            $table: $db.translationEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AyahTranslationsOrderingComposer extends Composer<_$ContentDatabase, AyahTranslations> {
  $AyahTranslationsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => ColumnOrderings(column));

  $AyahsOrderingComposer get ayahId {
    final $AyahsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ayahId,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahsOrderingComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TranslationEditionsOrderingComposer get edition {
    final $TranslationEditionsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.edition,
      referencedTable: $db.translationEditions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $TranslationEditionsOrderingComposer(
            $db: $db,
            $table: $db.translationEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AyahTranslationsAnnotationComposer extends Composer<_$ContentDatabase, AyahTranslations> {
  $AyahTranslationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  $AyahsAnnotationComposer get ayahId {
    final $AyahsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ayahId,
      referencedTable: $db.ayahs,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AyahsAnnotationComposer(
            $db: $db,
            $table: $db.ayahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TranslationEditionsAnnotationComposer get edition {
    final $TranslationEditionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.edition,
      referencedTable: $db.translationEditions,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $TranslationEditionsAnnotationComposer(
            $db: $db,
            $table: $db.translationEditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AyahTranslationsTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          AyahTranslations,
          AyahTranslation,
          $AyahTranslationsFilterComposer,
          $AyahTranslationsOrderingComposer,
          $AyahTranslationsAnnotationComposer,
          $AyahTranslationsCreateCompanionBuilder,
          $AyahTranslationsUpdateCompanionBuilder,
          (AyahTranslation, $AyahTranslationsReferences),
          AyahTranslation,
          PrefetchHooks Function({bool ayahId, bool edition})
        > {
  $AyahTranslationsTableManager(_$ContentDatabase db, AyahTranslations table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $AyahTranslationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $AyahTranslationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AyahTranslationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> ayahId = const Value.absent(),
            Value<String> edition = const Value.absent(),
            Value<String> content = const Value.absent(),
          }) => AyahTranslationsCompanion(ayahId: ayahId, edition: edition, content: content),
          createCompanionCallback:
              ({required int ayahId, required String edition, required String content}) =>
                  AyahTranslationsCompanion.insert(
                    ayahId: ayahId,
                    edition: edition,
                    content: content,
                  ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AyahTranslations, AyahTranslation>(table),
                  $AyahTranslationsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ayahId = false, edition = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ayahId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ayahId,
                        referencedTable: $AyahTranslationsReferences._ayahIdTable(db),
                        referencedColumn: $AyahTranslationsReferences._ayahIdTable(db).id,
                      ) as T;
                    }
                    if (edition) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.edition,
                        referencedTable: $AyahTranslationsReferences._editionTable(db),
                        referencedColumn: $AyahTranslationsReferences._editionTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AyahTranslationsProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      AyahTranslations,
      AyahTranslation,
      $AyahTranslationsFilterComposer,
      $AyahTranslationsOrderingComposer,
      $AyahTranslationsAnnotationComposer,
      $AyahTranslationsCreateCompanionBuilder,
      $AyahTranslationsUpdateCompanionBuilder,
      (AyahTranslation, $AyahTranslationsReferences),
      AyahTranslation,
      PrefetchHooks Function({bool ayahId, bool edition})
    >;
typedef $CountriesCreateCompanionBuilder = CountriesCompanion Function({
  required String code,
  required String nameEn,
  Value<String?> nameFr,
  Value<String?> nameAr,
  Value<int> rowid,
});
typedef $CountriesUpdateCompanionBuilder = CountriesCompanion Function({
  Value<String> code,
  Value<String> nameEn,
  Value<String?> nameFr,
  Value<String?> nameAr,
  Value<int> rowid,
});

final class $CountriesReferences extends BaseReferences<_$ContentDatabase, Countries, Country> {
  $CountriesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Cities, List<City>> _citiesRefsTable(_$ContentDatabase db) =>
      MultiTypedResultKey.fromTable(db.cities, aliasName: 'countries__code__cities__country_code');

  $CitiesProcessedTableManager get citiesRefs {
    final manager = $CitiesTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.countryCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_citiesRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $CountriesFilterComposer extends Composer<_$ContentDatabase, Countries> {
  $CountriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => ColumnFilters(column));

  Expression<bool> citiesRefs(Expression<bool> Function($CitiesFilterComposer f) f) {
    final $CitiesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.countryCode,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $CitiesFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CountriesOrderingComposer extends Composer<_$ContentDatabase, Countries> {
  $CountriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => ColumnOrderings(column));
}

class $CountriesAnnotationComposer extends Composer<_$ContentDatabase, Countries> {
  $CountriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  Expression<T> citiesRefs<T extends Object>(
    Expression<T> Function($CitiesAnnotationComposer a) f,
  ) {
    final $CitiesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.countryCode,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $CitiesAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CountriesTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          Countries,
          Country,
          $CountriesFilterComposer,
          $CountriesOrderingComposer,
          $CountriesAnnotationComposer,
          $CountriesCreateCompanionBuilder,
          $CountriesUpdateCompanionBuilder,
          (Country, $CountriesReferences),
          Country,
          PrefetchHooks Function({bool citiesRefs})
        > {
  $CountriesTableManager(_$ContentDatabase db, Countries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $CountriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $CountriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $CountriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String?> nameFr = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CountriesCompanion(
                code: code,
                nameEn: nameEn,
                nameFr: nameFr,
                nameAr: nameAr,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String nameEn,
                Value<String?> nameFr = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CountriesCompanion.insert(
                code: code,
                nameEn: nameEn,
                nameFr: nameFr,
                nameAr: nameAr,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable<Countries, Country>(table), $CountriesReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({citiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (citiesRefs) db.cities],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (citiesRefs)
                    await $_getPrefetchedData<Country, Countries, City>(
                      currentTable: table,
                      referencedTable: $CountriesReferences._citiesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $CountriesReferences(db, table, p0).citiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.countryCode == item.code),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $CountriesProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      Countries,
      Country,
      $CountriesFilterComposer,
      $CountriesOrderingComposer,
      $CountriesAnnotationComposer,
      $CountriesCreateCompanionBuilder,
      $CountriesUpdateCompanionBuilder,
      (Country, $CountriesReferences),
      Country,
      PrefetchHooks Function({bool citiesRefs})
    >;
typedef $CitiesCreateCompanionBuilder = CitiesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> nameFr,
  Value<String?> nameAr,
  required String countryCode,
  required double latitude,
  required double longitude,
  required String timezone,
  required int population,
  required String searchKey,
});
typedef $CitiesUpdateCompanionBuilder = CitiesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> nameFr,
  Value<String?> nameAr,
  Value<String> countryCode,
  Value<double> latitude,
  Value<double> longitude,
  Value<String> timezone,
  Value<int> population,
  Value<String> searchKey,
});

final class $CitiesReferences extends BaseReferences<_$ContentDatabase, Cities, City> {
  $CitiesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Countries _countryCodeTable(_$ContentDatabase db) =>
      db.countries.createAlias('cities__country_code__countries__code');

  $CountriesProcessedTableManager get countryCode {
    final $_column = $_itemColumn<String>('country_code')!;

    final manager = $CountriesTableManager(
      $_db,
      $_db.countries,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_countryCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $CitiesFilterComposer extends Composer<_$ContentDatabase, Cities> {
  $CitiesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get population =>
      $composableBuilder(column: $table.population, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => ColumnFilters(column));

  $CountriesFilterComposer get countryCode {
    final $CountriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.countryCode,
      referencedTable: $db.countries,
      getReferencedColumn: (t) => t.code,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $CountriesFilterComposer(
            $db: $db,
            $table: $db.countries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CitiesOrderingComposer extends Composer<_$ContentDatabase, Cities> {
  $CitiesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get population =>
      $composableBuilder(column: $table.population, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => ColumnOrderings(column));

  $CountriesOrderingComposer get countryCode {
    final $CountriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.countryCode,
      referencedTable: $db.countries,
      getReferencedColumn: (t) => t.code,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $CountriesOrderingComposer(
            $db: $db,
            $table: $db.countries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CitiesAnnotationComposer extends Composer<_$ContentDatabase, Cities> {
  $CitiesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<int> get population =>
      $composableBuilder(column: $table.population, builder: (column) => column);

  GeneratedColumn<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => column);

  $CountriesAnnotationComposer get countryCode {
    final $CountriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.countryCode,
      referencedTable: $db.countries,
      getReferencedColumn: (t) => t.code,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $CountriesAnnotationComposer(
            $db: $db,
            $table: $db.countries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CitiesTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          Cities,
          City,
          $CitiesFilterComposer,
          $CitiesOrderingComposer,
          $CitiesAnnotationComposer,
          $CitiesCreateCompanionBuilder,
          $CitiesUpdateCompanionBuilder,
          (City, $CitiesReferences),
          City,
          PrefetchHooks Function({bool countryCode})
        > {
  $CitiesTableManager(_$ContentDatabase db, Cities table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $CitiesFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $CitiesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $CitiesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameFr = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int> population = const Value.absent(),
                Value<String> searchKey = const Value.absent(),
              }) => CitiesCompanion(
                id: id,
                name: name,
                nameFr: nameFr,
                nameAr: nameAr,
                countryCode: countryCode,
                latitude: latitude,
                longitude: longitude,
                timezone: timezone,
                population: population,
                searchKey: searchKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> nameFr = const Value.absent(),
                Value<String?> nameAr = const Value.absent(),
                required String countryCode,
                required double latitude,
                required double longitude,
                required String timezone,
                required int population,
                required String searchKey,
              }) => CitiesCompanion.insert(
                id: id,
                name: name,
                nameFr: nameFr,
                nameAr: nameAr,
                countryCode: countryCode,
                latitude: latitude,
                longitude: longitude,
                timezone: timezone,
                population: population,
                searchKey: searchKey,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<Cities, City>(table), $CitiesReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({countryCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (countryCode) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.countryCode,
                        referencedTable: $CitiesReferences._countryCodeTable(db),
                        referencedColumn: $CitiesReferences._countryCodeTable(db).code,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $CitiesProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      Cities,
      City,
      $CitiesFilterComposer,
      $CitiesOrderingComposer,
      $CitiesAnnotationComposer,
      $CitiesCreateCompanionBuilder,
      $CitiesUpdateCompanionBuilder,
      (City, $CitiesReferences),
      City,
      PrefetchHooks Function({bool countryCode})
    >;
typedef $AdhkarCategoriesCreateCompanionBuilder = AdhkarCategoriesCompanion Function({
  Value<int> id,
  required int position,
  required String titleAr,
  required String titleEn,
  Value<String?> titleFr,
  required int itemCount,
});
typedef $AdhkarCategoriesUpdateCompanionBuilder = AdhkarCategoriesCompanion Function({
  Value<int> id,
  Value<int> position,
  Value<String> titleAr,
  Value<String> titleEn,
  Value<String?> titleFr,
  Value<int> itemCount,
});

final class $AdhkarCategoriesReferences
    extends BaseReferences<_$ContentDatabase, AdhkarCategories, AdhkarCategory> {
  $AdhkarCategoriesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Adhkar, List<AdhkarData>> _adhkarRefsTable(_$ContentDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.adhkar,
        aliasName: 'adhkar_categories__id__adhkar__category',
      );

  $AdhkarProcessedTableManager get adhkarRefs {
    final manager = $AdhkarTableManager(
      $_db,
      $_db.adhkar,
    ).filter((f) => f.category.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_adhkarRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $AdhkarCategoriesFilterComposer extends Composer<_$ContentDatabase, AdhkarCategories> {
  $AdhkarCategoriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleFr =>
      $composableBuilder(column: $table.titleFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => ColumnFilters(column));

  Expression<bool> adhkarRefs(Expression<bool> Function($AdhkarFilterComposer f) f) {
    final $AdhkarFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.adhkar,
      getReferencedColumn: (t) => t.category,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AdhkarFilterComposer(
            $db: $db,
            $table: $db.adhkar,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AdhkarCategoriesOrderingComposer extends Composer<_$ContentDatabase, AdhkarCategories> {
  $AdhkarCategoriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleFr =>
      $composableBuilder(column: $table.titleFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => ColumnOrderings(column));
}

class $AdhkarCategoriesAnnotationComposer extends Composer<_$ContentDatabase, AdhkarCategories> {
  $AdhkarCategoriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleFr =>
      $composableBuilder(column: $table.titleFr, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  Expression<T> adhkarRefs<T extends Object>(
    Expression<T> Function($AdhkarAnnotationComposer a) f,
  ) {
    final $AdhkarAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.adhkar,
      getReferencedColumn: (t) => t.category,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AdhkarAnnotationComposer(
            $db: $db,
            $table: $db.adhkar,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AdhkarCategoriesTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          AdhkarCategories,
          AdhkarCategory,
          $AdhkarCategoriesFilterComposer,
          $AdhkarCategoriesOrderingComposer,
          $AdhkarCategoriesAnnotationComposer,
          $AdhkarCategoriesCreateCompanionBuilder,
          $AdhkarCategoriesUpdateCompanionBuilder,
          (AdhkarCategory, $AdhkarCategoriesReferences),
          AdhkarCategory,
          PrefetchHooks Function({bool adhkarRefs})
        > {
  $AdhkarCategoriesTableManager(_$ContentDatabase db, AdhkarCategories table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $AdhkarCategoriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $AdhkarCategoriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AdhkarCategoriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                Value<String> titleEn = const Value.absent(),
                Value<String?> titleFr = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
              }) => AdhkarCategoriesCompanion(
                id: id,
                position: position,
                titleAr: titleAr,
                titleEn: titleEn,
                titleFr: titleFr,
                itemCount: itemCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int position,
                required String titleAr,
                required String titleEn,
                Value<String?> titleFr = const Value.absent(),
                required int itemCount,
              }) => AdhkarCategoriesCompanion.insert(
                id: id,
                position: position,
                titleAr: titleAr,
                titleEn: titleEn,
                titleFr: titleFr,
                itemCount: itemCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AdhkarCategories, AdhkarCategory>(table),
                  $AdhkarCategoriesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({adhkarRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (adhkarRefs) db.adhkar],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (adhkarRefs)
                    await $_getPrefetchedData<AdhkarCategory, AdhkarCategories, AdhkarData>(
                      currentTable: table,
                      referencedTable: $AdhkarCategoriesReferences._adhkarRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $AdhkarCategoriesReferences(db, table, p0).adhkarRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.category == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $AdhkarCategoriesProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      AdhkarCategories,
      AdhkarCategory,
      $AdhkarCategoriesFilterComposer,
      $AdhkarCategoriesOrderingComposer,
      $AdhkarCategoriesAnnotationComposer,
      $AdhkarCategoriesCreateCompanionBuilder,
      $AdhkarCategoriesUpdateCompanionBuilder,
      (AdhkarCategory, $AdhkarCategoriesReferences),
      AdhkarCategory,
      PrefetchHooks Function({bool adhkarRefs})
    >;
typedef $AdhkarCreateCompanionBuilder = AdhkarCompanion Function({
  Value<int> id,
  required int category,
  required int position,
  required String textAr,
  Value<String?> transliteration,
  Value<String?> textEn,
  Value<String?> textFr,
  required int repeatCount,
});
typedef $AdhkarUpdateCompanionBuilder = AdhkarCompanion Function({
  Value<int> id,
  Value<int> category,
  Value<int> position,
  Value<String> textAr,
  Value<String?> transliteration,
  Value<String?> textEn,
  Value<String?> textFr,
  Value<int> repeatCount,
});

final class $AdhkarReferences extends BaseReferences<_$ContentDatabase, Adhkar, AdhkarData> {
  $AdhkarReferences(super.$_db, super.$_table, super.$_typedResult);

  static AdhkarCategories _categoryTable(_$ContentDatabase db) =>
      db.adhkarCategories.createAlias('adhkar__category__adhkar_categories__id');

  $AdhkarCategoriesProcessedTableManager get category {
    final $_column = $_itemColumn<int>('category')!;

    final manager = $AdhkarCategoriesTableManager(
      $_db,
      $_db.adhkarCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $AdhkarFilterComposer extends Composer<_$ContentDatabase, Adhkar> {
  $AdhkarFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textAr =>
      $composableBuilder(column: $table.textAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textFr =>
      $composableBuilder(column: $table.textFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repeatCount =>
      $composableBuilder(column: $table.repeatCount, builder: (column) => ColumnFilters(column));

  $AdhkarCategoriesFilterComposer get category {
    final $AdhkarCategoriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.category,
      referencedTable: $db.adhkarCategories,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AdhkarCategoriesFilterComposer(
            $db: $db,
            $table: $db.adhkarCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AdhkarOrderingComposer extends Composer<_$ContentDatabase, Adhkar> {
  $AdhkarOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textAr =>
      $composableBuilder(column: $table.textAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textFr =>
      $composableBuilder(column: $table.textFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repeatCount =>
      $composableBuilder(column: $table.repeatCount, builder: (column) => ColumnOrderings(column));

  $AdhkarCategoriesOrderingComposer get category {
    final $AdhkarCategoriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.category,
      referencedTable: $db.adhkarCategories,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AdhkarCategoriesOrderingComposer(
            $db: $db,
            $table: $db.adhkarCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AdhkarAnnotationComposer extends Composer<_$ContentDatabase, Adhkar> {
  $AdhkarAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get textAr =>
      $composableBuilder(column: $table.textAr, builder: (column) => column);

  GeneratedColumn<String> get transliteration =>
      $composableBuilder(column: $table.transliteration, builder: (column) => column);

  GeneratedColumn<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => column);

  GeneratedColumn<String> get textFr =>
      $composableBuilder(column: $table.textFr, builder: (column) => column);

  GeneratedColumn<int> get repeatCount =>
      $composableBuilder(column: $table.repeatCount, builder: (column) => column);

  $AdhkarCategoriesAnnotationComposer get category {
    final $AdhkarCategoriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.category,
      referencedTable: $db.adhkarCategories,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $AdhkarCategoriesAnnotationComposer(
            $db: $db,
            $table: $db.adhkarCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AdhkarTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          Adhkar,
          AdhkarData,
          $AdhkarFilterComposer,
          $AdhkarOrderingComposer,
          $AdhkarAnnotationComposer,
          $AdhkarCreateCompanionBuilder,
          $AdhkarUpdateCompanionBuilder,
          (AdhkarData, $AdhkarReferences),
          AdhkarData,
          PrefetchHooks Function({bool category})
        > {
  $AdhkarTableManager(_$ContentDatabase db, Adhkar table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $AdhkarFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $AdhkarOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $AdhkarAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> category = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> textAr = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> textEn = const Value.absent(),
                Value<String?> textFr = const Value.absent(),
                Value<int> repeatCount = const Value.absent(),
              }) => AdhkarCompanion(
                id: id,
                category: category,
                position: position,
                textAr: textAr,
                transliteration: transliteration,
                textEn: textEn,
                textFr: textFr,
                repeatCount: repeatCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int category,
                required int position,
                required String textAr,
                Value<String?> transliteration = const Value.absent(),
                Value<String?> textEn = const Value.absent(),
                Value<String?> textFr = const Value.absent(),
                required int repeatCount,
              }) => AdhkarCompanion.insert(
                id: id,
                category: category,
                position: position,
                textAr: textAr,
                transliteration: transliteration,
                textEn: textEn,
                textFr: textFr,
                repeatCount: repeatCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<Adhkar, AdhkarData>(table), $AdhkarReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({category = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (category) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.category,
                        referencedTable: $AdhkarReferences._categoryTable(db),
                        referencedColumn: $AdhkarReferences._categoryTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AdhkarProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      Adhkar,
      AdhkarData,
      $AdhkarFilterComposer,
      $AdhkarOrderingComposer,
      $AdhkarAnnotationComposer,
      $AdhkarCreateCompanionBuilder,
      $AdhkarUpdateCompanionBuilder,
      (AdhkarData, $AdhkarReferences),
      AdhkarData,
      PrefetchHooks Function({bool category})
    >;
typedef $AyahSearchCreateCompanionBuilder = AyahSearchCompanion Function({
  required String ar,
  required String fr,
  required String en,
  Value<int> rowid,
});
typedef $AyahSearchUpdateCompanionBuilder = AyahSearchCompanion Function({
  Value<String> ar,
  Value<String> fr,
  Value<String> en,
  Value<int> rowid,
});

class $AyahSearchFilterComposer extends Composer<_$ContentDatabase, AyahSearch> {
  $AyahSearchFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ar =>
      $composableBuilder(column: $table.ar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fr =>
      $composableBuilder(column: $table.fr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get en =>
      $composableBuilder(column: $table.en, builder: (column) => ColumnFilters(column));
}

class $AyahSearchOrderingComposer extends Composer<_$ContentDatabase, AyahSearch> {
  $AyahSearchOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ar =>
      $composableBuilder(column: $table.ar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fr =>
      $composableBuilder(column: $table.fr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get en =>
      $composableBuilder(column: $table.en, builder: (column) => ColumnOrderings(column));
}

class $AyahSearchAnnotationComposer extends Composer<_$ContentDatabase, AyahSearch> {
  $AyahSearchAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ar =>
      $composableBuilder(column: $table.ar, builder: (column) => column);

  GeneratedColumn<String> get fr =>
      $composableBuilder(column: $table.fr, builder: (column) => column);

  GeneratedColumn<String> get en =>
      $composableBuilder(column: $table.en, builder: (column) => column);
}

class $AyahSearchTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          AyahSearch,
          AyahSearchData,
          $AyahSearchFilterComposer,
          $AyahSearchOrderingComposer,
          $AyahSearchAnnotationComposer,
          $AyahSearchCreateCompanionBuilder,
          $AyahSearchUpdateCompanionBuilder,
          (AyahSearchData, BaseReferences<_$ContentDatabase, AyahSearch, AyahSearchData>),
          AyahSearchData,
          PrefetchHooks Function()
        > {
  $AyahSearchTableManager(_$ContentDatabase db, AyahSearch table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $AyahSearchFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $AyahSearchOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $AyahSearchAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ar = const Value.absent(),
            Value<String> fr = const Value.absent(),
            Value<String> en = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AyahSearchCompanion(ar: ar, fr: fr, en: en, rowid: rowid),
          createCompanionCallback: ({
            required String ar,
            required String fr,
            required String en,
            Value<int> rowid = const Value.absent(),
          }) => AyahSearchCompanion.insert(ar: ar, fr: fr, en: en, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AyahSearch, AyahSearchData>(table),
                  BaseReferences<_$ContentDatabase, AyahSearch, AyahSearchData>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AyahSearchProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      AyahSearch,
      AyahSearchData,
      $AyahSearchFilterComposer,
      $AyahSearchOrderingComposer,
      $AyahSearchAnnotationComposer,
      $AyahSearchCreateCompanionBuilder,
      $AyahSearchUpdateCompanionBuilder,
      (AyahSearchData, BaseReferences<_$ContentDatabase, AyahSearch, AyahSearchData>),
      AyahSearchData,
      PrefetchHooks Function()
    >;

class $ContentDatabaseManager {
  final _$ContentDatabase _db;
  $ContentDatabaseManager(this._db);
  $MetaEntriesTableManager get metaEntries => $MetaEntriesTableManager(_db, _db.metaEntries);
  $SurahsTableManager get surahs => $SurahsTableManager(_db, _db.surahs);
  $AyahsTableManager get ayahs => $AyahsTableManager(_db, _db.ayahs);
  $TranslationEditionsTableManager get translationEditions =>
      $TranslationEditionsTableManager(_db, _db.translationEditions);
  $AyahTranslationsTableManager get ayahTranslations =>
      $AyahTranslationsTableManager(_db, _db.ayahTranslations);
  $CountriesTableManager get countries => $CountriesTableManager(_db, _db.countries);
  $CitiesTableManager get cities => $CitiesTableManager(_db, _db.cities);
  $AdhkarCategoriesTableManager get adhkarCategories =>
      $AdhkarCategoriesTableManager(_db, _db.adhkarCategories);
  $AdhkarTableManager get adhkar => $AdhkarTableManager(_db, _db.adhkar);
  $AyahSearchTableManager get ayahSearch => $AyahSearchTableManager(_db, _db.ayahSearch);
}

class SurahStartPagesResult {
  final int surah;
  final int? page;
  SurahStartPagesResult({required this.surah, this.page});
}

class AyahsOfPageResult {
  final Ayah a;
  final String? translation;
  AyahsOfPageResult({required this.a, this.translation});
}

class JuzStartsResult {
  final int juz;
  final int surah;
  final int number;
  final int page;
  final String textUthmani;
  final String nameAr;
  final String nameTranslit;
  JuzStartsResult({
    required this.juz,
    required this.surah,
    required this.number,
    required this.page,
    required this.textUthmani,
    required this.nameAr,
    required this.nameTranslit,
  });
}

class HizbStartsResult {
  final int hizb;
  final int surah;
  final int number;
  final int page;
  final String textUthmani;
  final String nameAr;
  final String nameTranslit;
  HizbStartsResult({
    required this.hizb,
    required this.surah,
    required this.number,
    required this.page,
    required this.textUthmani,
    required this.nameAr,
    required this.nameTranslit,
  });
}

class TranslationsOfAyahResult {
  final TranslationEdition e;
  final String content;
  TranslationsOfAyahResult({required this.e, required this.content});
}

class SearchCitiesResult {
  final City c;
  final Country co;
  SearchCitiesResult({required this.c, required this.co});
}

class CitiesInBoxResult {
  final City c;
  final Country co;
  CitiesInBoxResult({required this.c, required this.co});
}

class AyahByReferenceResult {
  final Ayah a;
  final String? translation;
  AyahByReferenceResult({required this.a, this.translation});
}

class SearchAyahsResult {
  final Ayah a;
  final String? translation;
  SearchAyahsResult({required this.a, this.translation});
}

class AyahsByIdsResult {
  final Ayah a;
  final String? translation;
  AyahsByIdsResult({required this.a, this.translation});
}
