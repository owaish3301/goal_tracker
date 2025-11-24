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
    r'dayOfWeek': PropertySchema(
      id: 1,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'duration': PropertySchema(
      id: 2,
      name: r'duration',
      type: IsarType.long,
    ),
    r'goalId': PropertySchema(
      id: 3,
      name: r'goalId',
      type: IsarType.long,
    ),
    r'hadFollowingTask': PropertySchema(
      id: 4,
      name: r'hadFollowingTask',
      type: IsarType.bool,
    ),
    r'hadPriorTask': PropertySchema(
      id: 5,
      name: r'hadPriorTask',
      type: IsarType.bool,
    ),
    r'hourOfDay': PropertySchema(
      id: 6,
      name: r'hourOfDay',
      type: IsarType.long,
    ),
    r'isWeekend': PropertySchema(
      id: 7,
      name: r'isWeekend',
      type: IsarType.bool,
    ),
    r'minutesFromScheduled': PropertySchema(
      id: 8,
      name: r'minutesFromScheduled',
      type: IsarType.long,
    ),
    r'predictedScore': PropertySchema(
      id: 9,
      name: r'predictedScore',
      type: IsarType.double,
    ),
    r'predictionError': PropertySchema(
      id: 10,
      name: r'predictionError',
      type: IsarType.double,
    ),
    r'productivityScore': PropertySchema(
      id: 11,
      name: r'productivityScore',
      type: IsarType.double,
    ),
    r'recordedAt': PropertySchema(
      id: 12,
      name: r'recordedAt',
      type: IsarType.dateTime,
    ),
    r'scheduledTaskId': PropertySchema(
      id: 13,
      name: r'scheduledTaskId',
      type: IsarType.long,
    ),
    r'timeSlotType': PropertySchema(
      id: 14,
      name: r'timeSlotType',
      type: IsarType.long,
    ),
    r'wasCompleted': PropertySchema(
      id: 15,
      name: r'wasCompleted',
      type: IsarType.bool,
    ),
    r'wasRescheduled': PropertySchema(
      id: 16,
      name: r'wasRescheduled',
      type: IsarType.bool,
    ),
    r'weekOfYear': PropertySchema(
      id: 17,
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
  writer.writeLong(offsets[1], object.dayOfWeek);
  writer.writeLong(offsets[2], object.duration);
  writer.writeLong(offsets[3], object.goalId);
  writer.writeBool(offsets[4], object.hadFollowingTask);
  writer.writeBool(offsets[5], object.hadPriorTask);
  writer.writeLong(offsets[6], object.hourOfDay);
  writer.writeBool(offsets[7], object.isWeekend);
  writer.writeLong(offsets[8], object.minutesFromScheduled);
  writer.writeDouble(offsets[9], object.predictedScore);
  writer.writeDouble(offsets[10], object.predictionError);
  writer.writeDouble(offsets[11], object.productivityScore);
  writer.writeDateTime(offsets[12], object.recordedAt);
  writer.writeLong(offsets[13], object.scheduledTaskId);
  writer.writeLong(offsets[14], object.timeSlotType);
  writer.writeBool(offsets[15], object.wasCompleted);
  writer.writeBool(offsets[16], object.wasRescheduled);
  writer.writeLong(offsets[17], object.weekOfYear);
}

ProductivityData _productivityDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProductivityData();
  object.actualDurationMinutes = reader.readLong(offsets[0]);
  object.dayOfWeek = reader.readLong(offsets[1]);
  object.duration = reader.readLong(offsets[2]);
  object.goalId = reader.readLong(offsets[3]);
  object.hadFollowingTask = reader.readBool(offsets[4]);
  object.hadPriorTask = reader.readBool(offsets[5]);
  object.hourOfDay = reader.readLong(offsets[6]);
  object.id = id;
  object.isWeekend = reader.readBool(offsets[7]);
  object.minutesFromScheduled = reader.readLong(offsets[8]);
  object.predictedScore = reader.readDoubleOrNull(offsets[9]);
  object.predictionError = reader.readDoubleOrNull(offsets[10]);
  object.productivityScore = reader.readDouble(offsets[11]);
  object.recordedAt = reader.readDateTime(offsets[12]);
  object.scheduledTaskId = reader.readLong(offsets[13]);
  object.timeSlotType = reader.readLong(offsets[14]);
  object.wasCompleted = reader.readBool(offsets[15]);
  object.wasRescheduled = reader.readBool(offsets[16]);
  object.weekOfYear = reader.readLong(offsets[17]);
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
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
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
      distinctByScheduledTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledTaskId');
    });
  }

  QueryBuilder<ProductivityData, ProductivityData, QDistinct>
      distinctByTimeSlotType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSlotType');
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

  QueryBuilder<ProductivityData, int, QQueryOperations>
      scheduledTaskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTaskId');
    });
  }

  QueryBuilder<ProductivityData, int, QQueryOperations> timeSlotTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSlotType');
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
