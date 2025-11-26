// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_metrics.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitMetricsCollection on Isar {
  IsarCollection<HabitMetrics> get habitMetrics => this.collection();
}

const HabitMetricsSchema = CollectionSchema(
  name: r'HabitMetrics',
  id: 6510159081637865802,
  properties: {
    r'consistencyScore': PropertySchema(
      id: 0,
      name: r'consistencyScore',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentStreak': PropertySchema(
      id: 2,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'goalId': PropertySchema(
      id: 3,
      name: r'goalId',
      type: IsarType.long,
    ),
    r'lastCompletedDate': PropertySchema(
      id: 4,
      name: r'lastCompletedDate',
      type: IsarType.dateTime,
    ),
    r'longestStreak': PropertySchema(
      id: 5,
      name: r'longestStreak',
      type: IsarType.long,
    ),
    r'stickyDayOfWeek': PropertySchema(
      id: 6,
      name: r'stickyDayOfWeek',
      type: IsarType.long,
    ),
    r'stickyHour': PropertySchema(
      id: 7,
      name: r'stickyHour',
      type: IsarType.long,
    ),
    r'timeConsistency': PropertySchema(
      id: 8,
      name: r'timeConsistency',
      type: IsarType.double,
    ),
    r'totalCompletions': PropertySchema(
      id: 9,
      name: r'totalCompletions',
      type: IsarType.long,
    ),
    r'totalScheduled': PropertySchema(
      id: 10,
      name: r'totalScheduled',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _habitMetricsEstimateSize,
  serialize: _habitMetricsSerialize,
  deserialize: _habitMetricsDeserialize,
  deserializeProp: _habitMetricsDeserializeProp,
  idName: r'id',
  indexes: {
    r'goalId': IndexSchema(
      id: 2738626632585230611,
      name: r'goalId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'goalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _habitMetricsGetId,
  getLinks: _habitMetricsGetLinks,
  attach: _habitMetricsAttach,
  version: '3.1.0+1',
);

int _habitMetricsEstimateSize(
  HabitMetrics object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _habitMetricsSerialize(
  HabitMetrics object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.consistencyScore);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.currentStreak);
  writer.writeLong(offsets[3], object.goalId);
  writer.writeDateTime(offsets[4], object.lastCompletedDate);
  writer.writeLong(offsets[5], object.longestStreak);
  writer.writeLong(offsets[6], object.stickyDayOfWeek);
  writer.writeLong(offsets[7], object.stickyHour);
  writer.writeDouble(offsets[8], object.timeConsistency);
  writer.writeLong(offsets[9], object.totalCompletions);
  writer.writeLong(offsets[10], object.totalScheduled);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

HabitMetrics _habitMetricsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitMetrics();
  object.consistencyScore = reader.readDouble(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.currentStreak = reader.readLong(offsets[2]);
  object.goalId = reader.readLong(offsets[3]);
  object.id = id;
  object.lastCompletedDate = reader.readDateTimeOrNull(offsets[4]);
  object.longestStreak = reader.readLong(offsets[5]);
  object.stickyDayOfWeek = reader.readLongOrNull(offsets[6]);
  object.stickyHour = reader.readLongOrNull(offsets[7]);
  object.timeConsistency = reader.readDouble(offsets[8]);
  object.totalCompletions = reader.readLong(offsets[9]);
  object.totalScheduled = reader.readLong(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  return object;
}

P _habitMetricsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitMetricsGetId(HabitMetrics object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitMetricsGetLinks(HabitMetrics object) {
  return [];
}

void _habitMetricsAttach(
    IsarCollection<dynamic> col, Id id, HabitMetrics object) {
  object.id = id;
}

extension HabitMetricsByIndex on IsarCollection<HabitMetrics> {
  Future<HabitMetrics?> getByGoalId(int goalId) {
    return getByIndex(r'goalId', [goalId]);
  }

  HabitMetrics? getByGoalIdSync(int goalId) {
    return getByIndexSync(r'goalId', [goalId]);
  }

  Future<bool> deleteByGoalId(int goalId) {
    return deleteByIndex(r'goalId', [goalId]);
  }

  bool deleteByGoalIdSync(int goalId) {
    return deleteByIndexSync(r'goalId', [goalId]);
  }

  Future<List<HabitMetrics?>> getAllByGoalId(List<int> goalIdValues) {
    final values = goalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'goalId', values);
  }

  List<HabitMetrics?> getAllByGoalIdSync(List<int> goalIdValues) {
    final values = goalIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'goalId', values);
  }

  Future<int> deleteAllByGoalId(List<int> goalIdValues) {
    final values = goalIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'goalId', values);
  }

  int deleteAllByGoalIdSync(List<int> goalIdValues) {
    final values = goalIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'goalId', values);
  }

  Future<Id> putByGoalId(HabitMetrics object) {
    return putByIndex(r'goalId', object);
  }

  Id putByGoalIdSync(HabitMetrics object, {bool saveLinks = true}) {
    return putByIndexSync(r'goalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGoalId(List<HabitMetrics> objects) {
    return putAllByIndex(r'goalId', objects);
  }

  List<Id> putAllByGoalIdSync(List<HabitMetrics> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'goalId', objects, saveLinks: saveLinks);
  }
}

extension HabitMetricsQueryWhereSort
    on QueryBuilder<HabitMetrics, HabitMetrics, QWhere> {
  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhere> anyGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'goalId'),
      );
    });
  }
}

extension HabitMetricsQueryWhere
    on QueryBuilder<HabitMetrics, HabitMetrics, QWhereClause> {
  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> idBetween(
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

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> goalIdEqualTo(
      int goalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'goalId',
        value: [goalId],
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> goalIdNotEqualTo(
      int goalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> goalIdGreaterThan(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [goalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> goalIdLessThan(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [],
        upper: [goalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterWhereClause> goalIdBetween(
    int lowerGoalId,
    int upperGoalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId',
        lower: [lowerGoalId],
        includeLower: includeLower,
        upper: [upperGoalId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HabitMetricsQueryFilter
    on QueryBuilder<HabitMetrics, HabitMetrics, QFilterCondition> {
  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      consistencyScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consistencyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      consistencyScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consistencyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      consistencyScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consistencyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      consistencyScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consistencyScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition> goalIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      goalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      goalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition> goalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      lastCompletedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCompletedDate',
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      lastCompletedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCompletedDate',
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      lastCompletedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      lastCompletedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      lastCompletedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      lastCompletedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCompletedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      longestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      longestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      longestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      longestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyDayOfWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stickyDayOfWeek',
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyDayOfWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stickyDayOfWeek',
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyDayOfWeekEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickyDayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyDayOfWeekGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stickyDayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyDayOfWeekLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stickyDayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyDayOfWeekBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stickyDayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyHourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stickyHour',
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyHourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stickyHour',
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyHourEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickyHour',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyHourGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stickyHour',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyHourLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stickyHour',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      stickyHourBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stickyHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      timeConsistencyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeConsistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      timeConsistencyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeConsistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      timeConsistencyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeConsistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      timeConsistencyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeConsistency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      totalCompletionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCompletions',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      totalCompletionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCompletions',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      totalCompletionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCompletions',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      totalCompletionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCompletions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      totalScheduledEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      totalScheduledGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      totalScheduledLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      totalScheduledBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalScheduled',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HabitMetricsQueryObject
    on QueryBuilder<HabitMetrics, HabitMetrics, QFilterCondition> {}

extension HabitMetricsQueryLinks
    on QueryBuilder<HabitMetrics, HabitMetrics, QFilterCondition> {}

extension HabitMetricsQuerySortBy
    on QueryBuilder<HabitMetrics, HabitMetrics, QSortBy> {
  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistencyScore', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByConsistencyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistencyScore', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByStickyDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickyDayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByStickyDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickyDayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByStickyHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickyHour', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByStickyHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickyHour', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByTimeConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeConsistency', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByTimeConsistencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeConsistency', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByTotalCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletions', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByTotalCompletionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletions', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByTotalScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScheduled', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      sortByTotalScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScheduled', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension HabitMetricsQuerySortThenBy
    on QueryBuilder<HabitMetrics, HabitMetrics, QSortThenBy> {
  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistencyScore', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByConsistencyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistencyScore', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByStickyDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickyDayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByStickyDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickyDayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByStickyHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickyHour', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByStickyHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stickyHour', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByTimeConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeConsistency', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByTimeConsistencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeConsistency', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByTotalCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletions', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByTotalCompletionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletions', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByTotalScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScheduled', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy>
      thenByTotalScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScheduled', Sort.desc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension HabitMetricsQueryWhereDistinct
    on QueryBuilder<HabitMetrics, HabitMetrics, QDistinct> {
  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct>
      distinctByConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consistencyScore');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct>
      distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct> distinctByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalId');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct>
      distinctByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletedDate');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct>
      distinctByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longestStreak');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct>
      distinctByStickyDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stickyDayOfWeek');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct> distinctByStickyHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stickyHour');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct>
      distinctByTimeConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeConsistency');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct>
      distinctByTotalCompletions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCompletions');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct>
      distinctByTotalScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalScheduled');
    });
  }

  QueryBuilder<HabitMetrics, HabitMetrics, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension HabitMetricsQueryProperty
    on QueryBuilder<HabitMetrics, HabitMetrics, QQueryProperty> {
  QueryBuilder<HabitMetrics, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HabitMetrics, double, QQueryOperations>
      consistencyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consistencyScore');
    });
  }

  QueryBuilder<HabitMetrics, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HabitMetrics, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<HabitMetrics, int, QQueryOperations> goalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalId');
    });
  }

  QueryBuilder<HabitMetrics, DateTime?, QQueryOperations>
      lastCompletedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletedDate');
    });
  }

  QueryBuilder<HabitMetrics, int, QQueryOperations> longestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestStreak');
    });
  }

  QueryBuilder<HabitMetrics, int?, QQueryOperations> stickyDayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stickyDayOfWeek');
    });
  }

  QueryBuilder<HabitMetrics, int?, QQueryOperations> stickyHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stickyHour');
    });
  }

  QueryBuilder<HabitMetrics, double, QQueryOperations>
      timeConsistencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeConsistency');
    });
  }

  QueryBuilder<HabitMetrics, int, QQueryOperations> totalCompletionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCompletions');
    });
  }

  QueryBuilder<HabitMetrics, int, QQueryOperations> totalScheduledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalScheduled');
    });
  }

  QueryBuilder<HabitMetrics, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
