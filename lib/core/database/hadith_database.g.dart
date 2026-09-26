// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_database.dart';

// ignore_for_file: type=lint
class HadithBooks extends Table with TableInfo<HadithBooks, HadithBook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HadithBooks(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
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
  static const VerificationMeta _hadithCountMeta = const VerificationMeta('hadithCount');
  late final GeneratedColumn<int> hadithCount = GeneratedColumn<int>(
    'hadith_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, position, nameAr, nameFr, nameEn, hadithCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hadith_books';
  @override
  VerificationContext validateIntegrity(
    Insertable<HadithBook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta, nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(_nameFrMeta, nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta));
    } else if (isInserting) {
      context.missing(_nameFrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta, nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('hadith_count')) {
      context.handle(
        _hadithCountMeta,
        hadithCount.isAcceptableOrUnknown(data['hadith_count']!, _hadithCountMeta),
      );
    } else if (isInserting) {
      context.missing(_hadithCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HadithBook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HadithBook(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      hadithCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hadith_count'],
      )!,
    );
  }

  @override
  HadithBooks createAlias(String alias) {
    return HadithBooks(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class HadithBook extends DataClass implements Insertable<HadithBook> {
  final String id;
  final int position;
  final String nameAr;
  final String nameFr;
  final String nameEn;
  final int hadithCount;
  const HadithBook({
    required this.id,
    required this.position,
    required this.nameAr,
    required this.nameFr,
    required this.nameEn,
    required this.hadithCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['position'] = Variable<int>(position);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_fr'] = Variable<String>(nameFr);
    map['name_en'] = Variable<String>(nameEn);
    map['hadith_count'] = Variable<int>(hadithCount);
    return map;
  }

  HadithBooksCompanion toCompanion(bool nullToAbsent) {
    return HadithBooksCompanion(
      id: Value(id),
      position: Value(position),
      nameAr: Value(nameAr),
      nameFr: Value(nameFr),
      nameEn: Value(nameEn),
      hadithCount: Value(hadithCount),
    );
  }

  factory HadithBook.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HadithBook(
      id: serializer.fromJson<String>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      nameAr: serializer.fromJson<String>(json['name_ar']),
      nameFr: serializer.fromJson<String>(json['name_fr']),
      nameEn: serializer.fromJson<String>(json['name_en']),
      hadithCount: serializer.fromJson<int>(json['hadith_count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'position': serializer.toJson<int>(position),
      'name_ar': serializer.toJson<String>(nameAr),
      'name_fr': serializer.toJson<String>(nameFr),
      'name_en': serializer.toJson<String>(nameEn),
      'hadith_count': serializer.toJson<int>(hadithCount),
    };
  }

  HadithBook copyWith({
    String? id,
    int? position,
    String? nameAr,
    String? nameFr,
    String? nameEn,
    int? hadithCount,
  }) => HadithBook(
    id: id ?? this.id,
    position: position ?? this.position,
    nameAr: nameAr ?? this.nameAr,
    nameFr: nameFr ?? this.nameFr,
    nameEn: nameEn ?? this.nameEn,
    hadithCount: hadithCount ?? this.hadithCount,
  );
  HadithBook copyWithCompanion(HadithBooksCompanion data) {
    return HadithBook(
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      hadithCount: data.hadithCount.present ? data.hadithCount.value : this.hadithCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HadithBook(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('hadithCount: $hadithCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, position, nameAr, nameFr, nameEn, hadithCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HadithBook &&
          other.id == this.id &&
          other.position == this.position &&
          other.nameAr == this.nameAr &&
          other.nameFr == this.nameFr &&
          other.nameEn == this.nameEn &&
          other.hadithCount == this.hadithCount);
}

class HadithBooksCompanion extends UpdateCompanion<HadithBook> {
  final Value<String> id;
  final Value<int> position;
  final Value<String> nameAr;
  final Value<String> nameFr;
  final Value<String> nameEn;
  final Value<int> hadithCount;
  final Value<int> rowid;
  const HadithBooksCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.hadithCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HadithBooksCompanion.insert({
    required String id,
    required int position,
    required String nameAr,
    required String nameFr,
    required String nameEn,
    required int hadithCount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       position = Value(position),
       nameAr = Value(nameAr),
       nameFr = Value(nameFr),
       nameEn = Value(nameEn),
       hadithCount = Value(hadithCount);
  static Insertable<HadithBook> custom({
    Expression<String>? id,
    Expression<int>? position,
    Expression<String>? nameAr,
    Expression<String>? nameFr,
    Expression<String>? nameEn,
    Expression<int>? hadithCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameEn != null) 'name_en': nameEn,
      if (hadithCount != null) 'hadith_count': hadithCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HadithBooksCompanion copyWith({
    Value<String>? id,
    Value<int>? position,
    Value<String>? nameAr,
    Value<String>? nameFr,
    Value<String>? nameEn,
    Value<int>? hadithCount,
    Value<int>? rowid,
  }) {
    return HadithBooksCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      nameAr: nameAr ?? this.nameAr,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      hadithCount: hadithCount ?? this.hadithCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (hadithCount.present) {
      map['hadith_count'] = Variable<int>(hadithCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HadithBooksCompanion(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('hadithCount: $hadithCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class HadithSections extends Table with TableInfo<HadithSections, HadithSection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HadithSections(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES hadith_books(id)',
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
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _hadithCountMeta = const VerificationMeta('hadithCount');
  late final GeneratedColumn<int> hadithCount = GeneratedColumn<int>(
    'hadith_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [book, number, nameEn, hadithCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hadith_sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<HadithSection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book')) {
      context.handle(_bookMeta, book.isAcceptableOrUnknown(data['book']!, _bookMeta));
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta, number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta, nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('hadith_count')) {
      context.handle(
        _hadithCountMeta,
        hadithCount.isAcceptableOrUnknown(data['hadith_count']!, _hadithCountMeta),
      );
    } else if (isInserting) {
      context.missing(_hadithCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {book, number};
  @override
  HadithSection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HadithSection(
      book: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}book'])!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      hadithCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hadith_count'],
      )!,
    );
  }

  @override
  HadithSections createAlias(String alias) {
    return HadithSections(attachedDatabase, alias);
  }

  @override
  bool get withoutRowId => true;
  @override
  List<String> get customConstraints => const ['PRIMARY KEY(book, number)'];
  @override
  bool get dontWriteConstraints => true;
}

class HadithSection extends DataClass implements Insertable<HadithSection> {
  final String book;
  final int number;
  final String nameEn;
  final int hadithCount;
  const HadithSection({
    required this.book,
    required this.number,
    required this.nameEn,
    required this.hadithCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book'] = Variable<String>(book);
    map['number'] = Variable<int>(number);
    map['name_en'] = Variable<String>(nameEn);
    map['hadith_count'] = Variable<int>(hadithCount);
    return map;
  }

  HadithSectionsCompanion toCompanion(bool nullToAbsent) {
    return HadithSectionsCompanion(
      book: Value(book),
      number: Value(number),
      nameEn: Value(nameEn),
      hadithCount: Value(hadithCount),
    );
  }

  factory HadithSection.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HadithSection(
      book: serializer.fromJson<String>(json['book']),
      number: serializer.fromJson<int>(json['number']),
      nameEn: serializer.fromJson<String>(json['name_en']),
      hadithCount: serializer.fromJson<int>(json['hadith_count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'book': serializer.toJson<String>(book),
      'number': serializer.toJson<int>(number),
      'name_en': serializer.toJson<String>(nameEn),
      'hadith_count': serializer.toJson<int>(hadithCount),
    };
  }

  HadithSection copyWith({String? book, int? number, String? nameEn, int? hadithCount}) =>
      HadithSection(
        book: book ?? this.book,
        number: number ?? this.number,
        nameEn: nameEn ?? this.nameEn,
        hadithCount: hadithCount ?? this.hadithCount,
      );
  HadithSection copyWithCompanion(HadithSectionsCompanion data) {
    return HadithSection(
      book: data.book.present ? data.book.value : this.book,
      number: data.number.present ? data.number.value : this.number,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      hadithCount: data.hadithCount.present ? data.hadithCount.value : this.hadithCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HadithSection(')
          ..write('book: $book, ')
          ..write('number: $number, ')
          ..write('nameEn: $nameEn, ')
          ..write('hadithCount: $hadithCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(book, number, nameEn, hadithCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HadithSection &&
          other.book == this.book &&
          other.number == this.number &&
          other.nameEn == this.nameEn &&
          other.hadithCount == this.hadithCount);
}

class HadithSectionsCompanion extends UpdateCompanion<HadithSection> {
  final Value<String> book;
  final Value<int> number;
  final Value<String> nameEn;
  final Value<int> hadithCount;
  const HadithSectionsCompanion({
    this.book = const Value.absent(),
    this.number = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.hadithCount = const Value.absent(),
  });
  HadithSectionsCompanion.insert({
    required String book,
    required int number,
    required String nameEn,
    required int hadithCount,
  }) : book = Value(book),
       number = Value(number),
       nameEn = Value(nameEn),
       hadithCount = Value(hadithCount);
  static Insertable<HadithSection> custom({
    Expression<String>? book,
    Expression<int>? number,
    Expression<String>? nameEn,
    Expression<int>? hadithCount,
  }) {
    return RawValuesInsertable({
      if (book != null) 'book': book,
      if (number != null) 'number': number,
      if (nameEn != null) 'name_en': nameEn,
      if (hadithCount != null) 'hadith_count': hadithCount,
    });
  }

  HadithSectionsCompanion copyWith({
    Value<String>? book,
    Value<int>? number,
    Value<String>? nameEn,
    Value<int>? hadithCount,
  }) {
    return HadithSectionsCompanion(
      book: book ?? this.book,
      number: number ?? this.number,
      nameEn: nameEn ?? this.nameEn,
      hadithCount: hadithCount ?? this.hadithCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (hadithCount.present) {
      map['hadith_count'] = Variable<int>(hadithCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HadithSectionsCompanion(')
          ..write('book: $book, ')
          ..write('number: $number, ')
          ..write('nameEn: $nameEn, ')
          ..write('hadithCount: $hadithCount')
          ..write(')'))
        .toString();
  }
}

class Hadiths extends Table with TableInfo<Hadiths, Hadith> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Hadiths(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES hadith_books(id)',
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  late final GeneratedColumn<double> number = GeneratedColumn<double>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sectionMeta = const VerificationMeta('section');
  late final GeneratedColumn<int> section = GeneratedColumn<int>(
    'section',
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
  static const VerificationMeta _textEnMeta = const VerificationMeta('textEn');
  late final GeneratedColumn<String> textEn = GeneratedColumn<String>(
    'text_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _gradesMeta = const VerificationMeta('grades');
  late final GeneratedColumn<String> grades = GeneratedColumn<String>(
    'grades',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [id, book, number, section, textAr, textFr, textEn, grades];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hadiths';
  @override
  VerificationContext validateIntegrity(Insertable<Hadith> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book')) {
      context.handle(_bookMeta, book.isAcceptableOrUnknown(data['book']!, _bookMeta));
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta, number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('section')) {
      context.handle(_sectionMeta, section.isAcceptableOrUnknown(data['section']!, _sectionMeta));
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('text_ar')) {
      context.handle(_textArMeta, textAr.isAcceptableOrUnknown(data['text_ar']!, _textArMeta));
    }
    if (data.containsKey('text_fr')) {
      context.handle(_textFrMeta, textFr.isAcceptableOrUnknown(data['text_fr']!, _textFrMeta));
    }
    if (data.containsKey('text_en')) {
      context.handle(_textEnMeta, textEn.isAcceptableOrUnknown(data['text_en']!, _textEnMeta));
    }
    if (data.containsKey('grades')) {
      context.handle(_gradesMeta, grades.isAcceptableOrUnknown(data['grades']!, _gradesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hadith map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hadith(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      book: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}book'])!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}number'],
      )!,
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}section'],
      )!,
      textAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_ar'],
      ),
      textFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_fr'],
      ),
      textEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_en'],
      ),
      grades: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grades'],
      ),
    );
  }

  @override
  Hadiths createAlias(String alias) {
    return Hadiths(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Hadith extends DataClass implements Insertable<Hadith> {
  final int id;
  final String book;
  final double number;
  final int section;
  final String? textAr;
  final String? textFr;
  final String? textEn;
  final String? grades;
  const Hadith({
    required this.id,
    required this.book,
    required this.number,
    required this.section,
    this.textAr,
    this.textFr,
    this.textEn,
    this.grades,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book'] = Variable<String>(book);
    map['number'] = Variable<double>(number);
    map['section'] = Variable<int>(section);
    if (!nullToAbsent || textAr != null) {
      map['text_ar'] = Variable<String>(textAr);
    }
    if (!nullToAbsent || textFr != null) {
      map['text_fr'] = Variable<String>(textFr);
    }
    if (!nullToAbsent || textEn != null) {
      map['text_en'] = Variable<String>(textEn);
    }
    if (!nullToAbsent || grades != null) {
      map['grades'] = Variable<String>(grades);
    }
    return map;
  }

  HadithsCompanion toCompanion(bool nullToAbsent) {
    return HadithsCompanion(
      id: Value(id),
      book: Value(book),
      number: Value(number),
      section: Value(section),
      textAr: textAr == null && nullToAbsent ? const Value.absent() : Value(textAr),
      textFr: textFr == null && nullToAbsent ? const Value.absent() : Value(textFr),
      textEn: textEn == null && nullToAbsent ? const Value.absent() : Value(textEn),
      grades: grades == null && nullToAbsent ? const Value.absent() : Value(grades),
    );
  }

  factory Hadith.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hadith(
      id: serializer.fromJson<int>(json['id']),
      book: serializer.fromJson<String>(json['book']),
      number: serializer.fromJson<double>(json['number']),
      section: serializer.fromJson<int>(json['section']),
      textAr: serializer.fromJson<String?>(json['text_ar']),
      textFr: serializer.fromJson<String?>(json['text_fr']),
      textEn: serializer.fromJson<String?>(json['text_en']),
      grades: serializer.fromJson<String?>(json['grades']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'book': serializer.toJson<String>(book),
      'number': serializer.toJson<double>(number),
      'section': serializer.toJson<int>(section),
      'text_ar': serializer.toJson<String?>(textAr),
      'text_fr': serializer.toJson<String?>(textFr),
      'text_en': serializer.toJson<String?>(textEn),
      'grades': serializer.toJson<String?>(grades),
    };
  }

  Hadith copyWith({
    int? id,
    String? book,
    double? number,
    int? section,
    Value<String?> textAr = const Value.absent(),
    Value<String?> textFr = const Value.absent(),
    Value<String?> textEn = const Value.absent(),
    Value<String?> grades = const Value.absent(),
  }) => Hadith(
    id: id ?? this.id,
    book: book ?? this.book,
    number: number ?? this.number,
    section: section ?? this.section,
    textAr: textAr.present ? textAr.value : this.textAr,
    textFr: textFr.present ? textFr.value : this.textFr,
    textEn: textEn.present ? textEn.value : this.textEn,
    grades: grades.present ? grades.value : this.grades,
  );
  Hadith copyWithCompanion(HadithsCompanion data) {
    return Hadith(
      id: data.id.present ? data.id.value : this.id,
      book: data.book.present ? data.book.value : this.book,
      number: data.number.present ? data.number.value : this.number,
      section: data.section.present ? data.section.value : this.section,
      textAr: data.textAr.present ? data.textAr.value : this.textAr,
      textFr: data.textFr.present ? data.textFr.value : this.textFr,
      textEn: data.textEn.present ? data.textEn.value : this.textEn,
      grades: data.grades.present ? data.grades.value : this.grades,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hadith(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('number: $number, ')
          ..write('section: $section, ')
          ..write('textAr: $textAr, ')
          ..write('textFr: $textFr, ')
          ..write('textEn: $textEn, ')
          ..write('grades: $grades')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, book, number, section, textAr, textFr, textEn, grades);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hadith &&
          other.id == this.id &&
          other.book == this.book &&
          other.number == this.number &&
          other.section == this.section &&
          other.textAr == this.textAr &&
          other.textFr == this.textFr &&
          other.textEn == this.textEn &&
          other.grades == this.grades);
}

class HadithsCompanion extends UpdateCompanion<Hadith> {
  final Value<int> id;
  final Value<String> book;
  final Value<double> number;
  final Value<int> section;
  final Value<String?> textAr;
  final Value<String?> textFr;
  final Value<String?> textEn;
  final Value<String?> grades;
  const HadithsCompanion({
    this.id = const Value.absent(),
    this.book = const Value.absent(),
    this.number = const Value.absent(),
    this.section = const Value.absent(),
    this.textAr = const Value.absent(),
    this.textFr = const Value.absent(),
    this.textEn = const Value.absent(),
    this.grades = const Value.absent(),
  });
  HadithsCompanion.insert({
    this.id = const Value.absent(),
    required String book,
    required double number,
    required int section,
    this.textAr = const Value.absent(),
    this.textFr = const Value.absent(),
    this.textEn = const Value.absent(),
    this.grades = const Value.absent(),
  }) : book = Value(book),
       number = Value(number),
       section = Value(section);
  static Insertable<Hadith> custom({
    Expression<int>? id,
    Expression<String>? book,
    Expression<double>? number,
    Expression<int>? section,
    Expression<String>? textAr,
    Expression<String>? textFr,
    Expression<String>? textEn,
    Expression<String>? grades,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (book != null) 'book': book,
      if (number != null) 'number': number,
      if (section != null) 'section': section,
      if (textAr != null) 'text_ar': textAr,
      if (textFr != null) 'text_fr': textFr,
      if (textEn != null) 'text_en': textEn,
      if (grades != null) 'grades': grades,
    });
  }

  HadithsCompanion copyWith({
    Value<int>? id,
    Value<String>? book,
    Value<double>? number,
    Value<int>? section,
    Value<String?>? textAr,
    Value<String?>? textFr,
    Value<String?>? textEn,
    Value<String?>? grades,
  }) {
    return HadithsCompanion(
      id: id ?? this.id,
      book: book ?? this.book,
      number: number ?? this.number,
      section: section ?? this.section,
      textAr: textAr ?? this.textAr,
      textFr: textFr ?? this.textFr,
      textEn: textEn ?? this.textEn,
      grades: grades ?? this.grades,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (number.present) {
      map['number'] = Variable<double>(number.value);
    }
    if (section.present) {
      map['section'] = Variable<int>(section.value);
    }
    if (textAr.present) {
      map['text_ar'] = Variable<String>(textAr.value);
    }
    if (textFr.present) {
      map['text_fr'] = Variable<String>(textFr.value);
    }
    if (textEn.present) {
      map['text_en'] = Variable<String>(textEn.value);
    }
    if (grades.present) {
      map['grades'] = Variable<String>(grades.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HadithsCompanion(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('number: $number, ')
          ..write('section: $section, ')
          ..write('textAr: $textAr, ')
          ..write('textFr: $textFr, ')
          ..write('textEn: $textEn, ')
          ..write('grades: $grades')
          ..write(')'))
        .toString();
  }
}

class HadithSearch extends Table
    with
        TableInfo<HadithSearch, HadithSearchData>,
        VirtualTableInfo<HadithSearch, HadithSearchData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HadithSearch(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'hadith_search';
  @override
  VerificationContext validateIntegrity(
    Insertable<HadithSearchData> instance, {
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
  HadithSearchData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HadithSearchData(
      ar: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}ar'])!,
      fr: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}fr'])!,
      en: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}en'])!,
    );
  }

  @override
  HadithSearch createAlias(String alias) {
    return HadithSearch(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(ar, fr, en, content = \'\', detail = \'none\', tokenize = \'unicode61 remove_diacritics 2\')';
}

class HadithSearchData extends DataClass implements Insertable<HadithSearchData> {
  final String ar;
  final String fr;
  final String en;
  const HadithSearchData({required this.ar, required this.fr, required this.en});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ar'] = Variable<String>(ar);
    map['fr'] = Variable<String>(fr);
    map['en'] = Variable<String>(en);
    return map;
  }

  HadithSearchCompanion toCompanion(bool nullToAbsent) {
    return HadithSearchCompanion(ar: Value(ar), fr: Value(fr), en: Value(en));
  }

  factory HadithSearchData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HadithSearchData(
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

  HadithSearchData copyWith({String? ar, String? fr, String? en}) =>
      HadithSearchData(ar: ar ?? this.ar, fr: fr ?? this.fr, en: en ?? this.en);
  HadithSearchData copyWithCompanion(HadithSearchCompanion data) {
    return HadithSearchData(
      ar: data.ar.present ? data.ar.value : this.ar,
      fr: data.fr.present ? data.fr.value : this.fr,
      en: data.en.present ? data.en.value : this.en,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HadithSearchData(')
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
      (other is HadithSearchData &&
          other.ar == this.ar &&
          other.fr == this.fr &&
          other.en == this.en);
}

class HadithSearchCompanion extends UpdateCompanion<HadithSearchData> {
  final Value<String> ar;
  final Value<String> fr;
  final Value<String> en;
  final Value<int> rowid;
  const HadithSearchCompanion({
    this.ar = const Value.absent(),
    this.fr = const Value.absent(),
    this.en = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HadithSearchCompanion.insert({
    required String ar,
    required String fr,
    required String en,
    this.rowid = const Value.absent(),
  }) : ar = Value(ar),
       fr = Value(fr),
       en = Value(en);
  static Insertable<HadithSearchData> custom({
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

  HadithSearchCompanion copyWith({
    Value<String>? ar,
    Value<String>? fr,
    Value<String>? en,
    Value<int>? rowid,
  }) {
    return HadithSearchCompanion(
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
    return (StringBuffer('HadithSearchCompanion(')
          ..write('ar: $ar, ')
          ..write('fr: $fr, ')
          ..write('en: $en, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class HadithMeta extends Table with TableInfo<HadithMeta, HadithMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  HadithMeta(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'hadith_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<HadithMetaData> instance, {
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
  HadithMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HadithMetaData(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  HadithMeta createAlias(String alias) {
    return HadithMeta(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class HadithMetaData extends DataClass implements Insertable<HadithMetaData> {
  final String key;
  final String value;
  const HadithMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  HadithMetaCompanion toCompanion(bool nullToAbsent) {
    return HadithMetaCompanion(key: Value(key), value: Value(value));
  }

  factory HadithMetaData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HadithMetaData(
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

  HadithMetaData copyWith({String? key, String? value}) =>
      HadithMetaData(key: key ?? this.key, value: value ?? this.value);
  HadithMetaData copyWithCompanion(HadithMetaCompanion data) {
    return HadithMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HadithMetaData(')
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
      (other is HadithMetaData && other.key == this.key && other.value == this.value);
}

class HadithMetaCompanion extends UpdateCompanion<HadithMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const HadithMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HadithMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<HadithMetaData> custom({
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

  HadithMetaCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return HadithMetaCompanion(
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
    return (StringBuffer('HadithMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$HadithDatabase extends GeneratedDatabase {
  _$HadithDatabase(QueryExecutor e) : super(e);
  $HadithDatabaseManager get managers => $HadithDatabaseManager(this);
  late final HadithBooks hadithBooks = HadithBooks(this);
  late final HadithSections hadithSections = HadithSections(this);
  late final Hadiths hadiths = Hadiths(this);
  late final HadithSearch hadithSearch = HadithSearch(this);
  late final HadithMeta hadithMeta = HadithMeta(this);
  late final Index hadithsBookSection = Index(
    'hadiths_book_section',
    'CREATE INDEX hadiths_book_section ON hadiths (book, section, number)',
  );
  late final Index hadithsBookNumber = Index(
    'hadiths_book_number',
    'CREATE UNIQUE INDEX hadiths_book_number ON hadiths (book, number)',
  );
  Selectable<HadithBook> allBooks() {
    return customSelect(
      'SELECT * FROM hadith_books ORDER BY position',
      variables: [],
      readsFrom: {this.hadithBooks},
    ).asyncMap(this.hadithBooks.mapFromRow);
  }

  Selectable<HadithSection> sectionsOfBook({required String book}) {
    return customSelect(
      'SELECT * FROM hadith_sections WHERE book = ?1 ORDER BY number',
      variables: [Variable<String>(book)],
      readsFrom: {this.hadithSections},
    ).asyncMap(this.hadithSections.mapFromRow);
  }

  Selectable<Hadith> hadithsOfSection({required String book, required int section}) {
    return customSelect(
      'SELECT * FROM hadiths WHERE book = ?1 AND section = ?2 ORDER BY number',
      variables: [Variable<String>(book), Variable<int>(section)],
      readsFrom: {this.hadiths},
    ).asyncMap(this.hadiths.mapFromRow);
  }

  Selectable<Hadith> hadithById({required int id}) {
    return customSelect(
      'SELECT * FROM hadiths WHERE id = ?1',
      variables: [Variable<int>(id)],
      readsFrom: {this.hadiths},
    ).asyncMap(this.hadiths.mapFromRow);
  }

  Selectable<Hadith> dailyCandidates() {
    return customSelect(
      'SELECT * FROM hadiths WHERE book IN (\'nawawi\', \'qudsi\') ORDER BY id',
      variables: [],
      readsFrom: {this.hadiths},
    ).asyncMap(this.hadiths.mapFromRow);
  }

  Selectable<Hadith> searchHadiths({required String query, required int limit}) {
    return customSelect(
      'SELECT h.* FROM hadith_search AS s INNER JOIN hadiths AS h ON h.id = s."rowid" WHERE hadith_search MATCH ?1 ORDER BY h.id LIMIT ?2',
      variables: [Variable<String>(query), Variable<int>(limit)],
      readsFrom: {this.hadithSearch, this.hadiths},
    ).asyncMap(this.hadiths.mapFromRow);
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    hadithBooks,
    hadithSections,
    hadiths,
    hadithSearch,
    hadithMeta,
    hadithsBookSection,
    hadithsBookNumber,
  ];
}

typedef $HadithBooksCreateCompanionBuilder = HadithBooksCompanion Function({
  required String id,
  required int position,
  required String nameAr,
  required String nameFr,
  required String nameEn,
  required int hadithCount,
  Value<int> rowid,
});
typedef $HadithBooksUpdateCompanionBuilder = HadithBooksCompanion Function({
  Value<String> id,
  Value<int> position,
  Value<String> nameAr,
  Value<String> nameFr,
  Value<String> nameEn,
  Value<int> hadithCount,
  Value<int> rowid,
});

final class $HadithBooksReferences
    extends BaseReferences<_$HadithDatabase, HadithBooks, HadithBook> {
  $HadithBooksReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<HadithSections, List<HadithSection>> _hadithSectionsRefsTable(
    _$HadithDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.hadithSections,
    aliasName: 'hadith_books__id__hadith_sections__book',
  );

  $HadithSectionsProcessedTableManager get hadithSectionsRefs {
    final manager = $HadithSectionsTableManager(
      $_db,
      $_db.hadithSections,
    ).filter((f) => f.book.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_hadithSectionsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<Hadiths, List<Hadith>> _hadithsRefsTable(_$HadithDatabase db) =>
      MultiTypedResultKey.fromTable(db.hadiths, aliasName: 'hadith_books__id__hadiths__book');

  $HadithsProcessedTableManager get hadithsRefs {
    final manager = $HadithsTableManager(
      $_db,
      $_db.hadiths,
    ).filter((f) => f.book.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_hadithsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $HadithBooksFilterComposer extends Composer<_$HadithDatabase, HadithBooks> {
  $HadithBooksFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hadithCount =>
      $composableBuilder(column: $table.hadithCount, builder: (column) => ColumnFilters(column));

  Expression<bool> hadithSectionsRefs(
    Expression<bool> Function($HadithSectionsFilterComposer f) f,
  ) {
    final $HadithSectionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hadithSections,
      getReferencedColumn: (t) => t.book,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithSectionsFilterComposer(
            $db: $db,
            $table: $db.hadithSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> hadithsRefs(Expression<bool> Function($HadithsFilterComposer f) f) {
    final $HadithsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hadiths,
      getReferencedColumn: (t) => t.book,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithsFilterComposer(
            $db: $db,
            $table: $db.hadiths,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $HadithBooksOrderingComposer extends Composer<_$HadithDatabase, HadithBooks> {
  $HadithBooksOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hadithCount =>
      $composableBuilder(column: $table.hadithCount, builder: (column) => ColumnOrderings(column));
}

class $HadithBooksAnnotationComposer extends Composer<_$HadithDatabase, HadithBooks> {
  $HadithBooksAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<int> get hadithCount =>
      $composableBuilder(column: $table.hadithCount, builder: (column) => column);

  Expression<T> hadithSectionsRefs<T extends Object>(
    Expression<T> Function($HadithSectionsAnnotationComposer a) f,
  ) {
    final $HadithSectionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hadithSections,
      getReferencedColumn: (t) => t.book,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithSectionsAnnotationComposer(
            $db: $db,
            $table: $db.hadithSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> hadithsRefs<T extends Object>(
    Expression<T> Function($HadithsAnnotationComposer a) f,
  ) {
    final $HadithsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hadiths,
      getReferencedColumn: (t) => t.book,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithsAnnotationComposer(
            $db: $db,
            $table: $db.hadiths,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $HadithBooksTableManager
    extends
        RootTableManager<
          _$HadithDatabase,
          HadithBooks,
          HadithBook,
          $HadithBooksFilterComposer,
          $HadithBooksOrderingComposer,
          $HadithBooksAnnotationComposer,
          $HadithBooksCreateCompanionBuilder,
          $HadithBooksUpdateCompanionBuilder,
          (HadithBook, $HadithBooksReferences),
          HadithBook,
          PrefetchHooks Function({bool hadithSectionsRefs, bool hadithsRefs})
        > {
  $HadithBooksTableManager(_$HadithDatabase db, HadithBooks table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $HadithBooksFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $HadithBooksOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $HadithBooksAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameFr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<int> hadithCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HadithBooksCompanion(
                id: id,
                position: position,
                nameAr: nameAr,
                nameFr: nameFr,
                nameEn: nameEn,
                hadithCount: hadithCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int position,
                required String nameAr,
                required String nameFr,
                required String nameEn,
                required int hadithCount,
                Value<int> rowid = const Value.absent(),
              }) => HadithBooksCompanion.insert(
                id: id,
                position: position,
                nameAr: nameAr,
                nameFr: nameFr,
                nameEn: nameEn,
                hadithCount: hadithCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<HadithBooks, HadithBook>(table),
                  $HadithBooksReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({hadithSectionsRefs = false, hadithsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (hadithSectionsRefs) db.hadithSections,
                if (hadithsRefs) db.hadiths,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (hadithSectionsRefs)
                    await $_getPrefetchedData<HadithBook, HadithBooks, HadithSection>(
                      currentTable: table,
                      referencedTable: $HadithBooksReferences._hadithSectionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $HadithBooksReferences(db, table, p0).hadithSectionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.book == item.id),
                      typedResults: items,
                    ),
                  if (hadithsRefs)
                    await $_getPrefetchedData<HadithBook, HadithBooks, Hadith>(
                      currentTable: table,
                      referencedTable: $HadithBooksReferences._hadithsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $HadithBooksReferences(db, table, p0).hadithsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.book == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $HadithBooksProcessedTableManager =
    ProcessedTableManager<
      _$HadithDatabase,
      HadithBooks,
      HadithBook,
      $HadithBooksFilterComposer,
      $HadithBooksOrderingComposer,
      $HadithBooksAnnotationComposer,
      $HadithBooksCreateCompanionBuilder,
      $HadithBooksUpdateCompanionBuilder,
      (HadithBook, $HadithBooksReferences),
      HadithBook,
      PrefetchHooks Function({bool hadithSectionsRefs, bool hadithsRefs})
    >;
typedef $HadithSectionsCreateCompanionBuilder = HadithSectionsCompanion Function({
  required String book,
  required int number,
  required String nameEn,
  required int hadithCount,
});
typedef $HadithSectionsUpdateCompanionBuilder = HadithSectionsCompanion Function({
  Value<String> book,
  Value<int> number,
  Value<String> nameEn,
  Value<int> hadithCount,
});

final class $HadithSectionsReferences
    extends BaseReferences<_$HadithDatabase, HadithSections, HadithSection> {
  $HadithSectionsReferences(super.$_db, super.$_table, super.$_typedResult);

  static HadithBooks _bookTable(_$HadithDatabase db) =>
      db.hadithBooks.createAlias('hadith_sections__book__hadith_books__id');

  $HadithBooksProcessedTableManager get book {
    final $_column = $_itemColumn<String>('book')!;

    final manager = $HadithBooksTableManager(
      $_db,
      $_db.hadithBooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $HadithSectionsFilterComposer extends Composer<_$HadithDatabase, HadithSections> {
  $HadithSectionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hadithCount =>
      $composableBuilder(column: $table.hadithCount, builder: (column) => ColumnFilters(column));

  $HadithBooksFilterComposer get book {
    final $HadithBooksFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.book,
      referencedTable: $db.hadithBooks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithBooksFilterComposer(
            $db: $db,
            $table: $db.hadithBooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HadithSectionsOrderingComposer extends Composer<_$HadithDatabase, HadithSections> {
  $HadithSectionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hadithCount =>
      $composableBuilder(column: $table.hadithCount, builder: (column) => ColumnOrderings(column));

  $HadithBooksOrderingComposer get book {
    final $HadithBooksOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.book,
      referencedTable: $db.hadithBooks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithBooksOrderingComposer(
            $db: $db,
            $table: $db.hadithBooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HadithSectionsAnnotationComposer extends Composer<_$HadithDatabase, HadithSections> {
  $HadithSectionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<int> get hadithCount =>
      $composableBuilder(column: $table.hadithCount, builder: (column) => column);

  $HadithBooksAnnotationComposer get book {
    final $HadithBooksAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.book,
      referencedTable: $db.hadithBooks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithBooksAnnotationComposer(
            $db: $db,
            $table: $db.hadithBooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HadithSectionsTableManager
    extends
        RootTableManager<
          _$HadithDatabase,
          HadithSections,
          HadithSection,
          $HadithSectionsFilterComposer,
          $HadithSectionsOrderingComposer,
          $HadithSectionsAnnotationComposer,
          $HadithSectionsCreateCompanionBuilder,
          $HadithSectionsUpdateCompanionBuilder,
          (HadithSection, $HadithSectionsReferences),
          HadithSection,
          PrefetchHooks Function({bool book})
        > {
  $HadithSectionsTableManager(_$HadithDatabase db, HadithSections table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $HadithSectionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $HadithSectionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $HadithSectionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> book = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<int> hadithCount = const Value.absent(),
              }) => HadithSectionsCompanion(
                book: book,
                number: number,
                nameEn: nameEn,
                hadithCount: hadithCount,
              ),
          createCompanionCallback:
              ({
                required String book,
                required int number,
                required String nameEn,
                required int hadithCount,
              }) => HadithSectionsCompanion.insert(
                book: book,
                number: number,
                nameEn: nameEn,
                hadithCount: hadithCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<HadithSections, HadithSection>(table),
                  $HadithSectionsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({book = false}) {
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
                    if (book) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.book,
                        referencedTable: $HadithSectionsReferences._bookTable(db),
                        referencedColumn: $HadithSectionsReferences._bookTable(db).id,
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

typedef $HadithSectionsProcessedTableManager =
    ProcessedTableManager<
      _$HadithDatabase,
      HadithSections,
      HadithSection,
      $HadithSectionsFilterComposer,
      $HadithSectionsOrderingComposer,
      $HadithSectionsAnnotationComposer,
      $HadithSectionsCreateCompanionBuilder,
      $HadithSectionsUpdateCompanionBuilder,
      (HadithSection, $HadithSectionsReferences),
      HadithSection,
      PrefetchHooks Function({bool book})
    >;
typedef $HadithsCreateCompanionBuilder = HadithsCompanion Function({
  Value<int> id,
  required String book,
  required double number,
  required int section,
  Value<String?> textAr,
  Value<String?> textFr,
  Value<String?> textEn,
  Value<String?> grades,
});
typedef $HadithsUpdateCompanionBuilder = HadithsCompanion Function({
  Value<int> id,
  Value<String> book,
  Value<double> number,
  Value<int> section,
  Value<String?> textAr,
  Value<String?> textFr,
  Value<String?> textEn,
  Value<String?> grades,
});

final class $HadithsReferences extends BaseReferences<_$HadithDatabase, Hadiths, Hadith> {
  $HadithsReferences(super.$_db, super.$_table, super.$_typedResult);

  static HadithBooks _bookTable(_$HadithDatabase db) =>
      db.hadithBooks.createAlias('hadiths__book__hadith_books__id');

  $HadithBooksProcessedTableManager get book {
    final $_column = $_itemColumn<String>('book')!;

    final manager = $HadithBooksTableManager(
      $_db,
      $_db.hadithBooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $HadithsFilterComposer extends Composer<_$HadithDatabase, Hadiths> {
  $HadithsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get number =>
      $composableBuilder(column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get section =>
      $composableBuilder(column: $table.section, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textAr =>
      $composableBuilder(column: $table.textAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textFr =>
      $composableBuilder(column: $table.textFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grades =>
      $composableBuilder(column: $table.grades, builder: (column) => ColumnFilters(column));

  $HadithBooksFilterComposer get book {
    final $HadithBooksFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.book,
      referencedTable: $db.hadithBooks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithBooksFilterComposer(
            $db: $db,
            $table: $db.hadithBooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HadithsOrderingComposer extends Composer<_$HadithDatabase, Hadiths> {
  $HadithsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get number =>
      $composableBuilder(column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get section =>
      $composableBuilder(column: $table.section, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textAr =>
      $composableBuilder(column: $table.textAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textFr =>
      $composableBuilder(column: $table.textFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grades =>
      $composableBuilder(column: $table.grades, builder: (column) => ColumnOrderings(column));

  $HadithBooksOrderingComposer get book {
    final $HadithBooksOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.book,
      referencedTable: $db.hadithBooks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithBooksOrderingComposer(
            $db: $db,
            $table: $db.hadithBooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HadithsAnnotationComposer extends Composer<_$HadithDatabase, Hadiths> {
  $HadithsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<int> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get textAr =>
      $composableBuilder(column: $table.textAr, builder: (column) => column);

  GeneratedColumn<String> get textFr =>
      $composableBuilder(column: $table.textFr, builder: (column) => column);

  GeneratedColumn<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => column);

  GeneratedColumn<String> get grades =>
      $composableBuilder(column: $table.grades, builder: (column) => column);

  $HadithBooksAnnotationComposer get book {
    final $HadithBooksAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.book,
      referencedTable: $db.hadithBooks,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $HadithBooksAnnotationComposer(
            $db: $db,
            $table: $db.hadithBooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HadithsTableManager
    extends
        RootTableManager<
          _$HadithDatabase,
          Hadiths,
          Hadith,
          $HadithsFilterComposer,
          $HadithsOrderingComposer,
          $HadithsAnnotationComposer,
          $HadithsCreateCompanionBuilder,
          $HadithsUpdateCompanionBuilder,
          (Hadith, $HadithsReferences),
          Hadith,
          PrefetchHooks Function({bool book})
        > {
  $HadithsTableManager(_$HadithDatabase db, Hadiths table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $HadithsFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $HadithsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $HadithsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> book = const Value.absent(),
                Value<double> number = const Value.absent(),
                Value<int> section = const Value.absent(),
                Value<String?> textAr = const Value.absent(),
                Value<String?> textFr = const Value.absent(),
                Value<String?> textEn = const Value.absent(),
                Value<String?> grades = const Value.absent(),
              }) => HadithsCompanion(
                id: id,
                book: book,
                number: number,
                section: section,
                textAr: textAr,
                textFr: textFr,
                textEn: textEn,
                grades: grades,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String book,
                required double number,
                required int section,
                Value<String?> textAr = const Value.absent(),
                Value<String?> textFr = const Value.absent(),
                Value<String?> textEn = const Value.absent(),
                Value<String?> grades = const Value.absent(),
              }) => HadithsCompanion.insert(
                id: id,
                book: book,
                number: number,
                section: section,
                textAr: textAr,
                textFr: textFr,
                textEn: textEn,
                grades: grades,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable<Hadiths, Hadith>(table), $HadithsReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({book = false}) {
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
                    if (book) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.book,
                        referencedTable: $HadithsReferences._bookTable(db),
                        referencedColumn: $HadithsReferences._bookTable(db).id,
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

typedef $HadithsProcessedTableManager =
    ProcessedTableManager<
      _$HadithDatabase,
      Hadiths,
      Hadith,
      $HadithsFilterComposer,
      $HadithsOrderingComposer,
      $HadithsAnnotationComposer,
      $HadithsCreateCompanionBuilder,
      $HadithsUpdateCompanionBuilder,
      (Hadith, $HadithsReferences),
      Hadith,
      PrefetchHooks Function({bool book})
    >;
typedef $HadithSearchCreateCompanionBuilder = HadithSearchCompanion Function({
  required String ar,
  required String fr,
  required String en,
  Value<int> rowid,
});
typedef $HadithSearchUpdateCompanionBuilder = HadithSearchCompanion Function({
  Value<String> ar,
  Value<String> fr,
  Value<String> en,
  Value<int> rowid,
});

class $HadithSearchFilterComposer extends Composer<_$HadithDatabase, HadithSearch> {
  $HadithSearchFilterComposer({
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

class $HadithSearchOrderingComposer extends Composer<_$HadithDatabase, HadithSearch> {
  $HadithSearchOrderingComposer({
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

class $HadithSearchAnnotationComposer extends Composer<_$HadithDatabase, HadithSearch> {
  $HadithSearchAnnotationComposer({
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

class $HadithSearchTableManager
    extends
        RootTableManager<
          _$HadithDatabase,
          HadithSearch,
          HadithSearchData,
          $HadithSearchFilterComposer,
          $HadithSearchOrderingComposer,
          $HadithSearchAnnotationComposer,
          $HadithSearchCreateCompanionBuilder,
          $HadithSearchUpdateCompanionBuilder,
          (HadithSearchData, BaseReferences<_$HadithDatabase, HadithSearch, HadithSearchData>),
          HadithSearchData,
          PrefetchHooks Function()
        > {
  $HadithSearchTableManager(_$HadithDatabase db, HadithSearch table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $HadithSearchFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $HadithSearchOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $HadithSearchAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ar = const Value.absent(),
            Value<String> fr = const Value.absent(),
            Value<String> en = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => HadithSearchCompanion(ar: ar, fr: fr, en: en, rowid: rowid),
          createCompanionCallback: ({
            required String ar,
            required String fr,
            required String en,
            Value<int> rowid = const Value.absent(),
          }) => HadithSearchCompanion.insert(ar: ar, fr: fr, en: en, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<HadithSearch, HadithSearchData>(table),
                  BaseReferences<_$HadithDatabase, HadithSearch, HadithSearchData>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $HadithSearchProcessedTableManager =
    ProcessedTableManager<
      _$HadithDatabase,
      HadithSearch,
      HadithSearchData,
      $HadithSearchFilterComposer,
      $HadithSearchOrderingComposer,
      $HadithSearchAnnotationComposer,
      $HadithSearchCreateCompanionBuilder,
      $HadithSearchUpdateCompanionBuilder,
      (HadithSearchData, BaseReferences<_$HadithDatabase, HadithSearch, HadithSearchData>),
      HadithSearchData,
      PrefetchHooks Function()
    >;
typedef $HadithMetaCreateCompanionBuilder = HadithMetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $HadithMetaUpdateCompanionBuilder = HadithMetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $HadithMetaFilterComposer extends Composer<_$HadithDatabase, HadithMeta> {
  $HadithMetaFilterComposer({
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

class $HadithMetaOrderingComposer extends Composer<_$HadithDatabase, HadithMeta> {
  $HadithMetaOrderingComposer({
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

class $HadithMetaAnnotationComposer extends Composer<_$HadithDatabase, HadithMeta> {
  $HadithMetaAnnotationComposer({
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

class $HadithMetaTableManager
    extends
        RootTableManager<
          _$HadithDatabase,
          HadithMeta,
          HadithMetaData,
          $HadithMetaFilterComposer,
          $HadithMetaOrderingComposer,
          $HadithMetaAnnotationComposer,
          $HadithMetaCreateCompanionBuilder,
          $HadithMetaUpdateCompanionBuilder,
          (HadithMetaData, BaseReferences<_$HadithDatabase, HadithMeta, HadithMetaData>),
          HadithMetaData,
          PrefetchHooks Function()
        > {
  $HadithMetaTableManager(_$HadithDatabase db, HadithMeta table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $HadithMetaFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $HadithMetaOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $HadithMetaAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => HadithMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => HadithMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<HadithMeta, HadithMetaData>(table),
                  BaseReferences<_$HadithDatabase, HadithMeta, HadithMetaData>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $HadithMetaProcessedTableManager =
    ProcessedTableManager<
      _$HadithDatabase,
      HadithMeta,
      HadithMetaData,
      $HadithMetaFilterComposer,
      $HadithMetaOrderingComposer,
      $HadithMetaAnnotationComposer,
      $HadithMetaCreateCompanionBuilder,
      $HadithMetaUpdateCompanionBuilder,
      (HadithMetaData, BaseReferences<_$HadithDatabase, HadithMeta, HadithMetaData>),
      HadithMetaData,
      PrefetchHooks Function()
    >;

class $HadithDatabaseManager {
  final _$HadithDatabase _db;
  $HadithDatabaseManager(this._db);
  $HadithBooksTableManager get hadithBooks => $HadithBooksTableManager(_db, _db.hadithBooks);
  $HadithSectionsTableManager get hadithSections =>
      $HadithSectionsTableManager(_db, _db.hadithSections);
  $HadithsTableManager get hadiths => $HadithsTableManager(_db, _db.hadiths);
  $HadithSearchTableManager get hadithSearch => $HadithSearchTableManager(_db, _db.hadithSearch);
  $HadithMetaTableManager get hadithMeta => $HadithMetaTableManager(_db, _db.hadithMeta);
}
