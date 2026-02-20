// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VideoHistoryTable extends VideoHistory
    with TableInfo<$VideoHistoryTable, VideoHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideoHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _videoPathMeta = const VerificationMeta(
    'videoPath',
  );
  @override
  late final GeneratedColumn<String> videoPath = GeneratedColumn<String>(
    'video_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    videoPath,
    thumbnailPath,
    imagePath,
    createdAt,
    title,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'video_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<VideoHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('video_path')) {
      context.handle(
        _videoPathMeta,
        videoPath.isAcceptableOrUnknown(data['video_path']!, _videoPathMeta),
      );
    } else if (isInserting) {
      context.missing(_videoPathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VideoHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VideoHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      videoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_path'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $VideoHistoryTable createAlias(String alias) {
    return $VideoHistoryTable(attachedDatabase, alias);
  }
}

class VideoHistoryData extends DataClass
    implements Insertable<VideoHistoryData> {
  final int id;
  final String videoPath;
  final String? thumbnailPath;
  final String? imagePath;
  final DateTime createdAt;
  final String title;
  const VideoHistoryData({
    required this.id,
    required this.videoPath,
    this.thumbnailPath,
    this.imagePath,
    required this.createdAt,
    required this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['video_path'] = Variable<String>(videoPath);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['title'] = Variable<String>(title);
    return map;
  }

  VideoHistoryCompanion toCompanion(bool nullToAbsent) {
    return VideoHistoryCompanion(
      id: Value(id),
      videoPath: Value(videoPath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      createdAt: Value(createdAt),
      title: Value(title),
    );
  }

  factory VideoHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VideoHistoryData(
      id: serializer.fromJson<int>(json['id']),
      videoPath: serializer.fromJson<String>(json['videoPath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'videoPath': serializer.toJson<String>(videoPath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'imagePath': serializer.toJson<String?>(imagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'title': serializer.toJson<String>(title),
    };
  }

  VideoHistoryData copyWith({
    int? id,
    String? videoPath,
    Value<String?> thumbnailPath = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    DateTime? createdAt,
    String? title,
  }) => VideoHistoryData(
    id: id ?? this.id,
    videoPath: videoPath ?? this.videoPath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    createdAt: createdAt ?? this.createdAt,
    title: title ?? this.title,
  );
  VideoHistoryData copyWithCompanion(VideoHistoryCompanion data) {
    return VideoHistoryData(
      id: data.id.present ? data.id.value : this.id,
      videoPath: data.videoPath.present ? data.videoPath.value : this.videoPath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VideoHistoryData(')
          ..write('id: $id, ')
          ..write('videoPath: $videoPath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, videoPath, thumbnailPath, imagePath, createdAt, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoHistoryData &&
          other.id == this.id &&
          other.videoPath == this.videoPath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.imagePath == this.imagePath &&
          other.createdAt == this.createdAt &&
          other.title == this.title);
}

class VideoHistoryCompanion extends UpdateCompanion<VideoHistoryData> {
  final Value<int> id;
  final Value<String> videoPath;
  final Value<String?> thumbnailPath;
  final Value<String?> imagePath;
  final Value<DateTime> createdAt;
  final Value<String> title;
  const VideoHistoryCompanion({
    this.id = const Value.absent(),
    this.videoPath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.title = const Value.absent(),
  });
  VideoHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String videoPath,
    this.thumbnailPath = const Value.absent(),
    this.imagePath = const Value.absent(),
    required DateTime createdAt,
    required String title,
  }) : videoPath = Value(videoPath),
       createdAt = Value(createdAt),
       title = Value(title);
  static Insertable<VideoHistoryData> custom({
    Expression<int>? id,
    Expression<String>? videoPath,
    Expression<String>? thumbnailPath,
    Expression<String>? imagePath,
    Expression<DateTime>? createdAt,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (videoPath != null) 'video_path': videoPath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (imagePath != null) 'image_path': imagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (title != null) 'title': title,
    });
  }

  VideoHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? videoPath,
    Value<String?>? thumbnailPath,
    Value<String?>? imagePath,
    Value<DateTime>? createdAt,
    Value<String>? title,
  }) {
    return VideoHistoryCompanion(
      id: id ?? this.id,
      videoPath: videoPath ?? this.videoPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (videoPath.present) {
      map['video_path'] = Variable<String>(videoPath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideoHistoryCompanion(')
          ..write('id: $id, ')
          ..write('videoPath: $videoPath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('imagePath: $imagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VideoHistoryTable videoHistory = $VideoHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [videoHistory];
}

typedef $$VideoHistoryTableCreateCompanionBuilder =
    VideoHistoryCompanion Function({
      Value<int> id,
      required String videoPath,
      Value<String?> thumbnailPath,
      Value<String?> imagePath,
      required DateTime createdAt,
      required String title,
    });
typedef $$VideoHistoryTableUpdateCompanionBuilder =
    VideoHistoryCompanion Function({
      Value<int> id,
      Value<String> videoPath,
      Value<String?> thumbnailPath,
      Value<String?> imagePath,
      Value<DateTime> createdAt,
      Value<String> title,
    });

class $$VideoHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $VideoHistoryTable> {
  $$VideoHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get videoPath => $composableBuilder(
    column: $table.videoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VideoHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $VideoHistoryTable> {
  $$VideoHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get videoPath => $composableBuilder(
    column: $table.videoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VideoHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $VideoHistoryTable> {
  $$VideoHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get videoPath =>
      $composableBuilder(column: $table.videoPath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);
}

class $$VideoHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VideoHistoryTable,
          VideoHistoryData,
          $$VideoHistoryTableFilterComposer,
          $$VideoHistoryTableOrderingComposer,
          $$VideoHistoryTableAnnotationComposer,
          $$VideoHistoryTableCreateCompanionBuilder,
          $$VideoHistoryTableUpdateCompanionBuilder,
          (
            VideoHistoryData,
            BaseReferences<_$AppDatabase, $VideoHistoryTable, VideoHistoryData>,
          ),
          VideoHistoryData,
          PrefetchHooks Function()
        > {
  $$VideoHistoryTableTableManager(_$AppDatabase db, $VideoHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VideoHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VideoHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VideoHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> videoPath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> title = const Value.absent(),
              }) => VideoHistoryCompanion(
                id: id,
                videoPath: videoPath,
                thumbnailPath: thumbnailPath,
                imagePath: imagePath,
                createdAt: createdAt,
                title: title,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String videoPath,
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required DateTime createdAt,
                required String title,
              }) => VideoHistoryCompanion.insert(
                id: id,
                videoPath: videoPath,
                thumbnailPath: thumbnailPath,
                imagePath: imagePath,
                createdAt: createdAt,
                title: title,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VideoHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VideoHistoryTable,
      VideoHistoryData,
      $$VideoHistoryTableFilterComposer,
      $$VideoHistoryTableOrderingComposer,
      $$VideoHistoryTableAnnotationComposer,
      $$VideoHistoryTableCreateCompanionBuilder,
      $$VideoHistoryTableUpdateCompanionBuilder,
      (
        VideoHistoryData,
        BaseReferences<_$AppDatabase, $VideoHistoryTable, VideoHistoryData>,
      ),
      VideoHistoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VideoHistoryTableTableManager get videoHistory =>
      $$VideoHistoryTableTableManager(_db, _db.videoHistory);
}
