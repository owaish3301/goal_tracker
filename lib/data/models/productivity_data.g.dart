// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productivity_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProductivityDataCollection on Isar {
  IsarCollection<ProductivityData> get productivityDatas => this.collection();
}

const ProductivityDataSchema = CollectionSchema(
  name: r'ProductivityData',
  id: 5232010329574521347,
  properties: {
    r'actualDurationMinutes': PropertySchema(
      id: 0,
      name: r'actualDurationMinutes',
      type: IsarType.long,
    ),
    r'completionRateLast7Days': PropertySchema(
      id: 1,
      name: r'completionRateLast7Days',
      type: IsarType.double,
    ),
    r'consecutiveTasksCompleted': PropertySchema(
      id: 2,
      name: r'consecutiveTasksCompleted',
      type: IsarType.long,
    ),
    r'currentStreakAtCompletion': PropertySchema(
      id: 3,
      name: r'currentStreakAtCompletion',
      type: IsarType.long,
    ),
    r'dayOfWeek': PropertySchema(
      id: 4,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'duration': PropertySchema(
      id: 5,
      name: r'duration',
      type: IsarType.long,
    ),
    r'goalConsistencyScore': PropertySchema(
      id: 6,
      name: r'goalConsistencyScore',
      type: IsarType.double,
    ),
    r'goalId': PropertySchema(
      id: 7,
      name: r'goalId',
      type: IsarType.long,
    ),
    r'hadFollowingTask': PropertySchema(
      id: 8,
      name: r'hadFollowingTask',
      type: IsarType.bool,
    ),
    r'hadPriorTask': PropertySchema(
      id: 9,
      name: r'hadPriorTask',
      type: IsarType.bool,
    ),
    r'hourOfDay': PropertySchema(
      id: 10,
      name: r'hourOfDay',
      type: IsarType.long,
    ),
    r'isWeekend': PropertySchema(
      id: 11,
      name: r'isWeekend',
      type: IsarType.bool,
    ),
    r'minutesFromScheduled': PropertySchema(
      id: 12,
      name: r'minutesFromScheduled',
      type: IsarType.long,
    ),
    r'minutesSinceFirstActivity': PropertySchema(
      id: 13,
      name: r'minutesSinceFirstActivity',
      type: IsarType.long,
    ),
    r'minutesSinceLastCompletion': PropertySchema(
      id: 14,
      name: r'minutesSinceLastCompletion',
      type: IsarType.long,
    ),
    r'predictedScore': PropertySchema(
      id: 15,
      name: r'predictedScore',
      type: IsarType.double,
    ),
    r'predictionError': PropertySchema(
      id: 16,
      name: r'predictionError',
      type: IsarType.double,
    ),
    r'previousTaskRating': PropertySchema(
      id: 17,
      name: r'previousTaskRating',
      type: IsarType.double,
    ),
    r'productivityScore': PropertySchema(
      id: 18,
      name: r'productivityScore',
      type: IsarType.double,
    ),
    r'recordedAt': PropertySchema(
      id: 19,
      name: r'recordedAt',
      type: IsarType.dateTime,
    ),
    r'relativeTimeInDay': PropertySchema(
      id: 20,
      name: r'relativeTimeInDay',
      type: IsarType.double,
    ),
    r'scheduledTaskId': PropertySchema(
      id: 21,
      name: r'scheduledTaskId',
      type: IsarType.long,
    ),
    r'taskOrderInDay': PropertySchema(
      id: 22,
      name: r'taskOrderInDay',
      type: IsarType.long,
    ),
    r'tasksCompletedBeforeThis': PropertySchema(
      id: 23,
      name: r'tasksCompletedBeforeThis',
      type: IsarType.long,
    ),
    r'timeSlotType': PropertySchema(
      id: 24,
      name: r'timeSlotType',
      type: IsarType.long,
    ),
    r'totalTasksScheduledToday': PropertySchema(
      id: 25,
      name: r'totalTasksScheduledToday',
      type: IsarType.long,
    ),
    r'wasCompleted': PropertySchema(
      id: 26,
      name: r'wasCompleted',
      type: IsarType.bool,
    ),
    r'wasRescheduled': PropertySchema(
      id: 27,
      name: r'wasRescheduled',
      type: IsarType.bool,
    ),
    r'weekOfYear': PropertySchema(
      id: 28,
      name: r'weekOfYear',
      type: IsarType.long,
    )
  },
  estimateSize: _productivityDataEstimateSize,
  serialize: _productivityDataSerialize,
  deserialize: _productivityDataDeserialize,
  deserializeProp: _productivityDataDeserializeProp,
  idName: r'id',
  indexes: {
    r'goalId_hourOfDay_dayOfWeek': IndexSchema(
      id: -2369960948282191250,
      name: r'goalId_hourOfDay_dayOfWeek',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'goalId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'hourOfDay',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'dayOfWeek',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'recordedAt': IndexSchema(
      id: -5046025352082009396,
      name: r'recordedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'recordedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _productivityDataGetId,
  getLinks: _productivityDataGetLinks,
  attach: _productivityDataAttach,
  version: '3.1.0+1',
);

int _productivityDataEstimateSize(
  ProductivityData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _productivityDataSerialize(
  ProductivityData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actualDurationMinutes);
  writer.writeDouble(offsets[1], object.completionRateLast7Days);
  writer.writeLong(offsets[2], object.consecutiveTasksCompleted);
  writer.writeLong(offsets[3], object.currentStreakAtCompletion);
  writer.writeLong(offsets[4], object.dayOfWeek);
  writer.writeLong(offsets[5], object.duration);
  writer.writeDouble(offsets[6], object.goalConsistencyScore);
  writer.writeLong(offsets[7], object.goalId);
  writer.writeBool(offsets[8], object.hadFollowingTask);
  writer.writeBool(offsets[9], object.hadPriorTask);
  writer.writeLong(offsets[10], object.hourOfDay);
  writer.writeBool(offsets[11], object.isWeekend);
  writer.writeLong(offsets[12], object.minutesFromScheduled);
  writer.writeLong(offsets[13], object.minutesSinceFirstActivity);
  writer.writeLong(offsets[14], object.minutesSinceLastCompletion);
  writer.writeDouble(offsets[15], object.predictedScore);
  writer.writeDouble(offsets[16], object.predictionError);
  writer.writeDouble(offsets[17], object.previousTaskRating);
  writer.writeDouble(offsets[18], object.productivityScore);
  writer.writeDateTime(offsets[19], object.recordedAt);
  writer.writeDouble(offsets[20], object.relativeTimeInDay);
  writer.writeLong(offsets[21], object.scheduledTaskId);
  writer.writeLong(offsets[22], object.taskOrderInDay);
  writer.writeLong(offsets[23], object.tasksCompletedBeforeThis);
  writer.writeLong(offsets[24], object.timeSlotType);
  writer.writeLong(offsets[25], object.totalTasksScheduledToday);
  writer.writeBool(offsets[26], object.wasCompleted);
  writer.writeBool(offsets[27], object.wasRescheduled);
  writer.writeLong(offsets[28], object.weekOfYear);
}

ProductivityData _productivityDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProductivityData();
  object.actualDurationMinutes = reader.readLong(offsets[0]);
  object.completionRateLast7Days = reader.readDouble(offsets[1]);
  object.consecutiveTasksCompleted = reader.readLong(offsets[2]);
  object.currentStreakAtCompletion = reader.readLong(offsets[3]);
  object.dayOfWeek = reader.readLong(offsets[4]);
  object.duration = reader.readLong(offsets[5]);
  object.goalConsistencyScore = reader.readDouble(offsets[6]);
  object.goalId = reader.readLong(offsets[7]);
  object.hadFollowingTask = reader.readBool(offsets[8]);
  object.hadPriorTask = reader.readBool(offsets[9]);
  object.hourOfDay = reader.readLong(offsets[10]);
  object.id = id;
  object.isWeekend = reader.readBool(offsets[11]);
  object.minutesFromScheduled = reader.readLong(offsets[12]);
  object.minutesSinceFirstActivity = reader.readLong(offsets[13]);
  object.minutesSinceLastCompletion = reader.readLong(offsets[14]);
  object.predictedScore = reader.readDoubleOrNull(offsets[15]);
  object.predictionError = reader.readDoubleOrNull(offsets[16]);
  object.previousTaskRating = reader.readDouble(offsets[17]);
  object.productivityScore = reader.readDouble(offsets[18]);
  object.recordedAt = reader.readDateTime(offsets[19]);
  object.relativeTimeInDay = reader.readDouble(offsets[20]);
  object.scheduledTaskId = reader.readLong(offsets[21]);
  object.taskOrderInDay = reader.readLong(offsets[22]);
  object.tasksCompletedBeforeThis = reader.readLong(offsets[23]);
  object.timeSlotType = reader.readLong(offsets[24]);
  object.totalTasksScheduledToday = reader.readLong(offsets[25]);
  object.wasCompleted = reader.readBool(offsets[26]);
  object.wasRescheduled = reader.readBool(offsets[27]);
  object.weekOfYear = reader.readLong(offsets[28]);
  return object;
}

P _productivityDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readDoubleOrNull(offset)) as P;
    case 16:
      return (reader.readDoubleOrNull(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readDateTime(offset)) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readLong(offset)) as P;
    case 24:
      return (reader.readLong(offset)) as P;
    case 25:
      return (reader.readLong(offset)) as P;
    case 26:
      return (reader.readBool(offset)) as P;
    case 27:
      return (reader.readBool(offset)) as P;
    case 28:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _productivityDataGetId(ProductivityData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _productivityDataGetLinks(ProductivityData object) {
  return [];
}

void _productivityDataAttach(
    IsarCollection<dynamic> col, Id id, ProductivityData object) {
  object.id = id;
}

extension ProductivityDataQueryWhereSort
    on QueryBuilder<ProductivityData, ProductivityData, QWhere> {
  QueryBuilder<ProductivityData, ProductivityData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhere>
      anyGoalIdHourOfDayDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'goalId_hourOfDay_dayOfWeek'),
      );
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhere>
      anyRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'recordedAt'),
      );
    });
  }
}

extension ProductivityDataQueryWhere
    on QueryBuilder<ProductivityData, ProductivityData, QWhereClause> {
  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdEqualToAnyHourOfDayDayOfWeek(int goalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        value: [goalId],
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdNotEqualToAnyHourOfDayDayOfWeek(int goalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [],
              upper: [goalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdGreaterThanAnyHourOfDayDayOfWeek(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [goalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdLessThanAnyHourOfDayDayOfWeek(
    int goalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [],
        upper: [goalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdBetweenAnyHourOfDayDayOfWeek(
    int lowerGoalId,
    int upperGoalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [lowerGoalId],
        includeLower: includeLower,
        upper: [upperGoalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdHourOfDayEqualToAnyDayOfWeek(int goalId, int hourOfDay) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        value: [goalId, hourOfDay],
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdEqualToHourOfDayNotEqualToAnyDayOfWeek(int goalId, int hourOfDay) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId],
              upper: [goalId, hourOfDay],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId, hourOfDay],
              includeLower: false,
              upper: [goalId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId, hourOfDay],
              includeLower: false,
              upper: [goalId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId],
              upper: [goalId, hourOfDay],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdEqualToHourOfDayGreaterThanAnyDayOfWeek(
    int goalId,
    int hourOfDay, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [goalId, hourOfDay],
        includeLower: include,
        upper: [goalId],
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdEqualToHourOfDayLessThanAnyDayOfWeek(
    int goalId,
    int hourOfDay, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [goalId],
        upper: [goalId, hourOfDay],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdEqualToHourOfDayBetweenAnyDayOfWeek(
    int goalId,
    int lowerHourOfDay,
    int upperHourOfDay, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [goalId, lowerHourOfDay],
        includeLower: includeLower,
        upper: [goalId, upperHourOfDay],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdHourOfDayDayOfWeekEqualTo(
          int goalId, int hourOfDay, int dayOfWeek) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        value: [goalId, hourOfDay, dayOfWeek],
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdHourOfDayEqualToDayOfWeekNotEqualTo(
          int goalId, int hourOfDay, int dayOfWeek) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId, hourOfDay],
              upper: [goalId, hourOfDay, dayOfWeek],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId, hourOfDay, dayOfWeek],
              includeLower: false,
              upper: [goalId, hourOfDay],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId, hourOfDay, dayOfWeek],
              includeLower: false,
              upper: [goalId, hourOfDay],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'goalId_hourOfDay_dayOfWeek',
              lower: [goalId, hourOfDay],
              upper: [goalId, hourOfDay, dayOfWeek],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdHourOfDayEqualToDayOfWeekGreaterThan(
    int goalId,
    int hourOfDay,
    int dayOfWeek, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [goalId, hourOfDay, dayOfWeek],
        includeLower: include,
        upper: [goalId, hourOfDay],
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdHourOfDayEqualToDayOfWeekLessThan(
    int goalId,
    int hourOfDay,
    int dayOfWeek, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [goalId, hourOfDay],
        upper: [goalId, hourOfDay, dayOfWeek],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      goalIdHourOfDayEqualToDayOfWeekBetween(
    int goalId,
    int hourOfDay,
    int lowerDayOfWeek,
    int upperDayOfWeek, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'goalId_hourOfDay_dayOfWeek',
        lower: [goalId, hourOfDay, lowerDayOfWeek],
        includeLower: includeLower,
        upper: [goalId, hourOfDay, upperDayOfWeek],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      recordedAtEqualTo(DateTime recordedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'recordedAt',
        value: [recordedAt],
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      recordedAtNotEqualTo(DateTime recordedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordedAt',
              lower: [],
              upper: [recordedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordedAt',
              lower: [recordedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordedAt',
              lower: [recordedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordedAt',
              lower: [],
              upper: [recordedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      recordedAtGreaterThan(
    DateTime recordedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'recordedAt',
        lower: [recordedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      recordedAtLessThan(
    DateTime recordedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'recordedAt',
        lower: [],
        upper: [recordedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterWhereClause>
      recordedAtBetween(
    DateTime lowerRecordedAt,
    DateTime upperRecordedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'recordedAt',
        lower: [lowerRecordedAt],
        includeLower: includeLower,
        upper: [upperRecordedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProductivityDataQueryFilter
    on QueryBuilder<ProductivityData, ProductivityData, QFilterCondition> {
  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      actualDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      actualDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      actualDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      actualDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      completionRateLast7DaysEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionRateLast7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      completionRateLast7DaysGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionRateLast7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      completionRateLast7DaysLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionRateLast7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      completionRateLast7DaysBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionRateLast7Days',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      consecutiveTasksCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consecutiveTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      consecutiveTasksCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consecutiveTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      consecutiveTasksCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consecutiveTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      consecutiveTasksCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consecutiveTasksCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      currentStreakAtCompletionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreakAtCompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      currentStreakAtCompletionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreakAtCompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      currentStreakAtCompletionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreakAtCompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      currentStreakAtCompletionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreakAtCompletion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      dayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      dayOfWeekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      dayOfWeekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      dayOfWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      durationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      durationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      durationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      durationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      goalConsistencyScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalConsistencyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      goalConsistencyScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalConsistencyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      goalConsistencyScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalConsistencyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      goalConsistencyScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalConsistencyScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      goalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      goalIdBetween(
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      hadFollowingTaskEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hadFollowingTask',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      hadPriorTaskEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hadPriorTask',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      hourOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hourOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      hourOfDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hourOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      hourOfDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hourOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      hourOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hourOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      isWeekendEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWeekend',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesFromScheduledEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minutesFromScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesFromScheduledGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minutesFromScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesFromScheduledLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minutesFromScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesFromScheduledBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minutesFromScheduled',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesSinceFirstActivityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minutesSinceFirstActivity',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesSinceFirstActivityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minutesSinceFirstActivity',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesSinceFirstActivityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minutesSinceFirstActivity',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesSinceFirstActivityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minutesSinceFirstActivity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesSinceLastCompletionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minutesSinceLastCompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesSinceLastCompletionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minutesSinceLastCompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesSinceLastCompletionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minutesSinceLastCompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      minutesSinceLastCompletionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minutesSinceLastCompletion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictedScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predictedScore',
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictedScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predictedScore',
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictedScoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predictedScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictedScoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'predictedScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictedScoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'predictedScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictedScoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'predictedScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictionErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predictionError',
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictionErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predictionError',
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictionErrorEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predictionError',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictionErrorGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'predictionError',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictionErrorLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'predictionError',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      predictionErrorBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'predictionError',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      previousTaskRatingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previousTaskRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      previousTaskRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previousTaskRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      previousTaskRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previousTaskRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      previousTaskRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previousTaskRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      productivityScoreEqualTo(
    double value, {
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      productivityScoreGreaterThan(
    double value, {
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      productivityScoreLessThan(
    double value, {
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      productivityScoreBetween(
    double lower,
    double upper, {
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

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      recordedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      recordedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      recordedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      recordedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      relativeTimeInDayEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relativeTimeInDay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      relativeTimeInDayGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relativeTimeInDay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      relativeTimeInDayLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relativeTimeInDay',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      relativeTimeInDayBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relativeTimeInDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      scheduledTaskIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledTaskId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      scheduledTaskIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledTaskId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      scheduledTaskIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledTaskId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      scheduledTaskIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledTaskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      taskOrderInDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskOrderInDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      taskOrderInDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskOrderInDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      taskOrderInDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskOrderInDay',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      taskOrderInDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskOrderInDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      tasksCompletedBeforeThisEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tasksCompletedBeforeThis',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      tasksCompletedBeforeThisGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tasksCompletedBeforeThis',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      tasksCompletedBeforeThisLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tasksCompletedBeforeThis',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      tasksCompletedBeforeThisBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tasksCompletedBeforeThis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      timeSlotTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSlotType',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      timeSlotTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeSlotType',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      timeSlotTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeSlotType',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      timeSlotTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeSlotType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      totalTasksScheduledTodayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTasksScheduledToday',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      totalTasksScheduledTodayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTasksScheduledToday',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      totalTasksScheduledTodayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTasksScheduledToday',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      totalTasksScheduledTodayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTasksScheduledToday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      wasCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      wasRescheduledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wasRescheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      weekOfYearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekOfYear',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      weekOfYearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekOfYear',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      weekOfYearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekOfYear',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterFilterCondition>
      weekOfYearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekOfYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProductivityDataQueryObject
    on QueryBuilder<ProductivityData, ProductivityData, QFilterCondition> {}

extension ProductivityDataQueryLinks
    on QueryBuilder<ProductivityData, ProductivityData, QFilterCondition> {}

extension ProductivityDataQuerySortBy
    on QueryBuilder<ProductivityData, ProductivityData, QSortBy> {
  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByActualDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByActualDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByCompletionRateLast7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRateLast7Days', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByCompletionRateLast7DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRateLast7Days', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByConsecutiveTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveTasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByConsecutiveTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveTasksCompleted', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByCurrentStreakAtCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreakAtCompletion', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByCurrentStreakAtCompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreakAtCompletion', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByGoalConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalConsistencyScore', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByGoalConsistencyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalConsistencyScore', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByHadFollowingTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadFollowingTask', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByHadFollowingTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadFollowingTask', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByHadPriorTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadPriorTask', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByHadPriorTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadPriorTask', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByHourOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByIsWeekend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeekend', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByIsWeekendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeekend', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByMinutesFromScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesFromScheduled', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByMinutesFromScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesFromScheduled', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByMinutesSinceFirstActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceFirstActivity', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByMinutesSinceFirstActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceFirstActivity', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByMinutesSinceLastCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceLastCompletion', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByMinutesSinceLastCompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceLastCompletion', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByPredictedScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedScore', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByPredictedScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedScore', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByPredictionError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictionError', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByPredictionErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictionError', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByPreviousTaskRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousTaskRating', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByPreviousTaskRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousTaskRating', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByProductivityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityScore', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByProductivityScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityScore', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByRecordedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByRelativeTimeInDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimeInDay', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByRelativeTimeInDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimeInDay', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByScheduledTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTaskId', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByScheduledTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTaskId', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByTaskOrderInDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskOrderInDay', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByTaskOrderInDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskOrderInDay', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByTasksCompletedBeforeThis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompletedBeforeThis', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByTasksCompletedBeforeThisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompletedBeforeThis', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByTimeSlotType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotType', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByTimeSlotTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotType', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByTotalTasksScheduledToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTasksScheduledToday', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByTotalTasksScheduledTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTasksScheduledToday', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByWasCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasCompleted', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByWasCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasCompleted', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByWasRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRescheduled', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByWasRescheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRescheduled', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByWeekOfYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekOfYear', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      sortByWeekOfYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekOfYear', Sort.desc);
    });
  }
}

extension ProductivityDataQuerySortThenBy
    on QueryBuilder<ProductivityData, ProductivityData, QSortThenBy> {
  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByActualDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByActualDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByCompletionRateLast7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRateLast7Days', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByCompletionRateLast7DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRateLast7Days', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByConsecutiveTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveTasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByConsecutiveTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveTasksCompleted', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByCurrentStreakAtCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreakAtCompletion', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByCurrentStreakAtCompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreakAtCompletion', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByGoalConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalConsistencyScore', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByGoalConsistencyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalConsistencyScore', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByGoalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalId', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByHadFollowingTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadFollowingTask', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByHadFollowingTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadFollowingTask', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByHadPriorTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadPriorTask', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByHadPriorTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadPriorTask', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByHourOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByIsWeekend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeekend', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByIsWeekendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeekend', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByMinutesFromScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesFromScheduled', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByMinutesFromScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesFromScheduled', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByMinutesSinceFirstActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceFirstActivity', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByMinutesSinceFirstActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceFirstActivity', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByMinutesSinceLastCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceLastCompletion', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByMinutesSinceLastCompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceLastCompletion', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByPredictedScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedScore', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByPredictedScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedScore', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByPredictionError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictionError', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByPredictionErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictionError', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByPreviousTaskRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousTaskRating', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByPreviousTaskRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousTaskRating', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByProductivityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityScore', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByProductivityScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivityScore', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByRecordedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAt', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByRelativeTimeInDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimeInDay', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByRelativeTimeInDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimeInDay', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByScheduledTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTaskId', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByScheduledTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTaskId', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByTaskOrderInDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskOrderInDay', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByTaskOrderInDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskOrderInDay', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByTasksCompletedBeforeThis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompletedBeforeThis', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByTasksCompletedBeforeThisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompletedBeforeThis', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByTimeSlotType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotType', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByTimeSlotTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSlotType', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByTotalTasksScheduledToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTasksScheduledToday', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByTotalTasksScheduledTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTasksScheduledToday', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByWasCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasCompleted', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByWasCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasCompleted', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByWasRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRescheduled', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByWasRescheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasRescheduled', Sort.desc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByWeekOfYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekOfYear', Sort.asc);
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QAfterSortBy>
      thenByWeekOfYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekOfYear', Sort.desc);
    });
  }
}

extension ProductivityDataQueryWhereDistinct
    on QueryBuilder<ProductivityData, ProductivityData, QDistinct> {
  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByActualDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualDurationMinutes');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByCompletionRateLast7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionRateLast7Days');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByConsecutiveTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consecutiveTasksCompleted');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByCurrentStreakAtCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreakAtCompletion');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfWeek');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByGoalConsistencyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalConsistencyScore');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByGoalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalId');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByHadFollowingTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hadFollowingTask');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByHadPriorTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hadPriorTask');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourOfDay');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByIsWeekend() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWeekend');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByMinutesFromScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minutesFromScheduled');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByMinutesSinceFirstActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minutesSinceFirstActivity');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByMinutesSinceLastCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minutesSinceLastCompletion');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByPredictedScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predictedScore');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByPredictionError() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predictionError');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByPreviousTaskRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previousTaskRating');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByProductivityScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productivityScore');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByRecordedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordedAt');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByRelativeTimeInDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relativeTimeInDay');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByScheduledTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledTaskId');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByTaskOrderInDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskOrderInDay');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByTasksCompletedBeforeThis() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tasksCompletedBeforeThis');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByTimeSlotType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSlotType');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByTotalTasksScheduledToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTasksScheduledToday');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByWasCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasCompleted');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByWasRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasRescheduled');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByWeekOfYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekOfYear');
    });
  }
}

extension ProductivityDataQueryProperty
    on QueryBuilder<ProductivityData, ProductivityData, QQueryProperty> {
  QueryBuilder<ProductivityData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      actualDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualDurationMinutes');
    });
  }

  QueryBuilder<ProductivityData, double, QQueryOperations>
      completionRateLast7DaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionRateLast7Days');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      consecutiveTasksCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consecutiveTasksCompleted');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      currentStreakAtCompletionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreakAtCompletion');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations> dayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfWeek');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<ProductivityData, double, QQueryOperations>
      goalConsistencyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalConsistencyScore');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations> goalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalId');
    });
  }

  QueryBuilder<ProductivityData, bool, QQueryOperations>
      hadFollowingTaskProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hadFollowingTask');
    });
  }

  QueryBuilder<ProductivityData, bool, QQueryOperations>
      hadPriorTaskProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hadPriorTask');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations> hourOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourOfDay');
    });
  }

  QueryBuilder<ProductivityData, bool, QQueryOperations> isWeekendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWeekend');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      minutesFromScheduledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minutesFromScheduled');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      minutesSinceFirstActivityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minutesSinceFirstActivity');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      minutesSinceLastCompletionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minutesSinceLastCompletion');
    });
  }

  QueryBuilder<ProductivityData, double?, QQueryOperations>
      predictedScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predictedScore');
    });
  }

  QueryBuilder<ProductivityData, double?, QQueryOperations>
      predictionErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predictionError');
    });
  }

  QueryBuilder<ProductivityData, double, QQueryOperations>
      previousTaskRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previousTaskRating');
    });
  }

  QueryBuilder<ProductivityData, double, QQueryOperations>
      productivityScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productivityScore');
    });
  }

  QueryBuilder<ProductivityData, DateTime, QQueryOperations>
      recordedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordedAt');
    });
  }

  QueryBuilder<ProductivityData, double, QQueryOperations>
      relativeTimeInDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relativeTimeInDay');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      scheduledTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTaskId');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      taskOrderInDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskOrderInDay');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      tasksCompletedBeforeThisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tasksCompletedBeforeThis');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations> timeSlotTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSlotType');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations>
      totalTasksScheduledTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTasksScheduledToday');
    });
  }

  QueryBuilder<ProductivityData, bool, QQueryOperations>
      wasCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasCompleted');
    });
  }

  QueryBuilder<ProductivityData, bool, QQueryOperations>
      wasRescheduledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasRescheduled');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations> weekOfYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekOfYear');
    });
  }
}
