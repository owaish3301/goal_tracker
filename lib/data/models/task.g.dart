// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskCollection on Isar {
  IsarCollection<Task> get tasks => this.collection();
}

const TaskSchema = CollectionSchema(
  name: r'Task',
  id: 2998003626758701373,
  properties: {
    r'actualDuration': PropertySchema(
      id: 0,
      name: r'actualDuration',
      type: IsarType.long,
    ),
    r'actualStartTime': PropertySchema(
      id: 1,
      name: r'actualStartTime',
      type: IsarType.dateTime,
    ),
    r'completedAt': PropertySchema(
      id: 2,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'notes': PropertySchema(
      id: 4,
      name: r'notes',
      type: IsarType.string,
    ),
    r'originalScheduledTime': PropertySchema(
      id: 5,
      name: r'originalScheduledTime',
      type: IsarType.dateTime,
    ),
    r'productivityScore': PropertySchema(
      id: 6,
      name: r'productivityScore',
      type: IsarType.double,
    ),
    r'scheduledDate': PropertySchema(
      id: 7,
      name: r'scheduledDate',
      type: IsarType.dateTime,
    ),
    r'scheduledDuration': PropertySchema(
      id: 8,
      name: r'scheduledDuration',
      type: IsarType.long,
    ),
    r'scheduledStartTime': PropertySchema(
      id: 9,
      name: r'scheduledStartTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 10,
      name: r'status',
      type: IsarType.string,
      enumMap: _TaskstatusEnumValueMap,
    ),
    r'wasManuallyRescheduled': PropertySchema(
      id: 11,
      name: r'wasManuallyRescheduled',
      type: IsarType.bool,
    )
  },
  estimateSize: _taskEstimateSize,
  serialize: _taskSerialize,
  deserialize: _taskDeserialize,
  deserializeProp: _taskDeserializeProp,
  idName: r'id',
  indexes: {
    r'scheduledDate': IndexSchema(
      id: -6773496565145745994,
      name: r'scheduledDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scheduledDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'goal': LinkSchema(
      id: -2209890815044215538,
      name: r'goal',
      target: r'Goal',
      single: true,
    ),
    r'completedMilestone': LinkSchema(
      id: -6440058724040574831,
      name: r'completedMilestone',
      target: r'Milestone',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _taskGetId,
  getLinks: _taskGetLinks,
  attach: _taskAttach,
  version: '3.1.0+1',
);

int _taskEstimateSize(
  Task object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.name.length * 3;
  return bytesCount;
}

void _taskSerialize(
  Task object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actualDuration);
  writer.writeDateTime(offsets[1], object.actualStartTime);
  writer.writeDateTime(offsets[2], object.completedAt);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.notes);
  writer.writeDateTime(offsets[5], object.originalScheduledTime);
  writer.writeDouble(offsets[6], object.productivityScore);
  writer.writeDateTime(offsets[7], object.scheduledDate);
  writer.writeLong(offsets[8], object.scheduledDuration);
  writer.writeDateTime(offsets[9], object.scheduledStartTime);
  writer.writeString(offsets[10], object.status.name);
  writer.writeBool(offsets[11], object.wasManuallyRescheduled);
}

Task _taskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Task();
  object.actualDuration = reader.readLongOrNull(offsets[0]);
  object.actualStartTime = reader.readDateTimeOrNull(offsets[1]);
  object.completedAt = reader.readDateTimeOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[4]);
  object.originalScheduledTime = reader.readDateTimeOrNull(offsets[5]);
  object.productivityScore = reader.readDoubleOrNull(offsets[6]);
  object.scheduledDate = reader.readDateTime(offsets[7]);
  object.scheduledDuration = reader.readLong(offsets[8]);
  object.scheduledStartTime = reader.readDateTime(offsets[9]);
  object.status =
      _TaskstatusValueEnumMap[reader.readStringOrNull(offsets[10])] ??
          TaskStatus.pending;
  object.wasManuallyRescheduled = reader.readBool(offsets[11]);
  return object;
}

P _taskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (_TaskstatusValueEnumMap[reader.readStringOrNull(offset)] ??
          TaskStatus.pending) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TaskstatusEnumValueMap = {
  r'pending': r'pending',
  r'completed': r'completed',
  r'skipped': r'skipped',
  r'rescheduled': r'rescheduled',
};
const _TaskstatusValueEnumMap = {
  r'pending': TaskStatus.pending,
  r'completed': TaskStatus.completed,
  r'skipped': TaskStatus.skipped,
  r'rescheduled': TaskStatus.rescheduled,
};

Id _taskGetId(Task object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taskGetLinks(Task object) {
  return [object.goal, object.completedMilestone];
}

void _taskAttach(IsarCollection<dynamic> col, Id id, Task object) {
  object.id = id;
  object.goal.attach(col, col.isar.collection<Goal>(), r'goal', id);
  object.completedMilestone
      .attach(col, col.isar.collection<Milestone>(), r'completedMilestone', id);
}

extension TaskQueryWhereSort on QueryBuilder<Task, Task, QWhere> {
  QueryBuilder<Task, Task, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Task, Task, QAfterWhere> anyScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'scheduledDate'),
      );
    });
  }
}

extension TaskQueryWhere on QueryBuilder<Task, Task, QWhereClause> {
  QueryBuilder<Task, Task, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Task, Task, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> idBetween(
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

  QueryBuilder<Task, Task, QAfterWhereClause> scheduledDateEqualTo(
      DateTime scheduledDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'scheduledDate',
        value: [scheduledDate],
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> scheduledDateNotEqualTo(
      DateTime scheduledDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledDate',
              lower: [],
              upper: [scheduledDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledDate',
              lower: [scheduledDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledDate',
              lower: [scheduledDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledDate',
              lower: [],
              upper: [scheduledDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> scheduledDateGreaterThan(
    DateTime scheduledDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledDate',
        lower: [scheduledDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> scheduledDateLessThan(
    DateTime scheduledDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledDate',
        lower: [],
        upper: [scheduledDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> scheduledDateBetween(
    DateTime lowerScheduledDate,
    DateTime upperScheduledDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledDate',
        lower: [lowerScheduledDate],
        includeLower: includeLower,
        upper: [upperScheduledDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> statusEqualTo(TaskStatus status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> statusNotEqualTo(
      TaskStatus status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TaskQueryFilter on QueryBuilder<Task, Task, QFilterCondition> {
  QueryBuilder<Task, Task, QAfterFilterCondition> actualDurationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actualDuration',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualDurationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actualDuration',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualDurationEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualDurationGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualDurationLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualDurationBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualStartTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actualStartTime',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualStartTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actualStartTime',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualStartTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualStartTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualStartTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualStartTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualStartTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualStartTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> actualStartTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualStartTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> completedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      originalScheduledTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalScheduledTime',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      originalScheduledTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalScheduledTime',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> originalScheduledTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalScheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      originalScheduledTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalScheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> originalScheduledTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalScheduledTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> originalScheduledTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalScheduledTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> productivityScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productivityScore',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> productivityScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productivityScore',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> productivityScoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productivityScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> productivityScoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productivityScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> productivityScoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productivityScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> productivityScoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productivityScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledDurationEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledStartTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledStartTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledStartTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledStartTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledStartTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledStartTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> scheduledStartTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledStartTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusEqualTo(
    TaskStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusGreaterThan(
    TaskStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusLessThan(
    TaskStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusBetween(
    TaskStatus lower,
    TaskStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> wasManuallyRescheduledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasManuallyRescheduled',
        value: value,
      ));
    });
  }
}

extension TaskQueryObject on QueryBuilder<Task, Task, QFilterCondition> {}

extension TaskQueryLinks on QueryBuilder<Task, Task, QFilterCondition> {
  QueryBuilder<Task, Task, QAfterFilterCondition> goal(FilterQuery<Goal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'goal');
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> goalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'goal', 0, true, 0, true);
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> completedMilestone(
      FilterQuery<Milestone> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'completedMilestone');
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> completedMilestoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completedMilestone', 0, true, 0, true);
    });
  }
}

extension TaskQuerySortBy on QueryBuilder<Task, Task, QSortBy> {
  QueryBuilder<Task, Task, QAfterSortBy> sortByActualDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDuration', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByActualDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDuration', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByActualStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualStartTime', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByActualStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualStartTime', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByOriginalScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalScheduledTime', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByOriginalScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalScheduledTime', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByProductivityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityScore', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByProductivityScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityScore', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByScheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByScheduledDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDuration', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByScheduledDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDuration', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByScheduledStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledStartTime', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByScheduledStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledStartTime', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByWasManuallyRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasManuallyRescheduled', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByWasManuallyRescheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasManuallyRescheduled', Sort.desc);
    });
  }
}

extension TaskQuerySortThenBy on QueryBuilder<Task, Task, QSortThenBy> {
  QueryBuilder<Task, Task, QAfterSortBy> thenByActualDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDuration', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByActualDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDuration', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByActualStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualStartTime', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByActualStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualStartTime', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByOriginalScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalScheduledTime', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByOriginalScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalScheduledTime', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByProductivityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityScore', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByProductivityScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityScore', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByScheduledDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDate', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByScheduledDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDuration', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByScheduledDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledDuration', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByScheduledStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledStartTime', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByScheduledStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledStartTime', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByWasManuallyRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasManuallyRescheduled', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByWasManuallyRescheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasManuallyRescheduled', Sort.desc);
    });
  }
}

extension TaskQueryWhereDistinct on QueryBuilder<Task, Task, QDistinct> {
  QueryBuilder<Task, Task, QDistinct> distinctByActualDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualDuration');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByActualStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualStartTime');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByOriginalScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalScheduledTime');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByProductivityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productivityScore');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByScheduledDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledDate');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByScheduledDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledDuration');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByScheduledStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledStartTime');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByWasManuallyRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasManuallyRescheduled');
    });
  }
}

extension TaskQueryProperty on QueryBuilder<Task, Task, QQueryProperty> {
  QueryBuilder<Task, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Task, int?, QQueryOperations> actualDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualDuration');
    });
  }

  QueryBuilder<Task, DateTime?, QQueryOperations> actualStartTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualStartTime');
    });
  }

  QueryBuilder<Task, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<Task, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Task, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Task, DateTime?, QQueryOperations>
      originalScheduledTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalScheduledTime');
    });
  }

  QueryBuilder<Task, double?, QQueryOperations> productivityScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productivityScore');
    });
  }

  QueryBuilder<Task, DateTime, QQueryOperations> scheduledDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledDate');
    });
  }

  QueryBuilder<Task, int, QQueryOperations> scheduledDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledDuration');
    });
  }

  QueryBuilder<Task, DateTime, QQueryOperations> scheduledStartTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledStartTime');
    });
  }

  QueryBuilder<Task, TaskStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Task, bool, QQueryOperations> wasManuallyRescheduledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasManuallyRescheduled');
    });
  }
}
