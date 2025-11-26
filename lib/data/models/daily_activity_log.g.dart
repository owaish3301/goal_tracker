// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activity_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyActivityLogCollection on Isar {
  IsarCollection<DailyActivityLog> get dailyActivityLogs => this.collection();
}

const DailyActivityLogSchema = CollectionSchema(
  name: r'DailyActivityLog',
  id: 5533773889764604876,
  properties: {
    r'averageProductivity': PropertySchema(
      id: 0,
      name: r'averageProductivity',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'dayOfWeek': PropertySchema(
      id: 2,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'firstActivityAt': PropertySchema(
      id: 3,
      name: r'firstActivityAt',
      type: IsarType.dateTime,
    ),
    r'isWeekend': PropertySchema(
      id: 4,
      name: r'isWeekend',
      type: IsarType.bool,
    ),
    r'lastActivityAt': PropertySchema(
      id: 5,
      name: r'lastActivityAt',
      type: IsarType.dateTime,
    ),
    r'productivitySum': PropertySchema(
      id: 6,
      name: r'productivitySum',
      type: IsarType.double,
    ),
    r'tasksCompleted': PropertySchema(
      id: 7,
      name: r'tasksCompleted',
      type: IsarType.long,
    ),
    r'tasksScheduled': PropertySchema(
      id: 8,
      name: r'tasksScheduled',
      type: IsarType.long,
    ),
    r'tasksSkipped': PropertySchema(
      id: 9,
      name: r'tasksSkipped',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dailyActivityLogEstimateSize,
  serialize: _dailyActivityLogSerialize,
  deserialize: _dailyActivityLogDeserialize,
  deserializeProp: _dailyActivityLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyActivityLogGetId,
  getLinks: _dailyActivityLogGetLinks,
  attach: _dailyActivityLogAttach,
  version: '3.1.0+1',
);

int _dailyActivityLogEstimateSize(
  DailyActivityLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dailyActivityLogSerialize(
  DailyActivityLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageProductivity);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLong(offsets[2], object.dayOfWeek);
  writer.writeDateTime(offsets[3], object.firstActivityAt);
  writer.writeBool(offsets[4], object.isWeekend);
  writer.writeDateTime(offsets[5], object.lastActivityAt);
  writer.writeDouble(offsets[6], object.productivitySum);
  writer.writeLong(offsets[7], object.tasksCompleted);
  writer.writeLong(offsets[8], object.tasksScheduled);
  writer.writeLong(offsets[9], object.tasksSkipped);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

DailyActivityLog _dailyActivityLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyActivityLog();
  object.averageProductivity = reader.readDouble(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.dayOfWeek = reader.readLong(offsets[2]);
  object.firstActivityAt = reader.readDateTimeOrNull(offsets[3]);
  object.id = id;
  object.isWeekend = reader.readBool(offsets[4]);
  object.lastActivityAt = reader.readDateTimeOrNull(offsets[5]);
  object.productivitySum = reader.readDouble(offsets[6]);
  object.tasksCompleted = reader.readLong(offsets[7]);
  object.tasksScheduled = reader.readLong(offsets[8]);
  object.tasksSkipped = reader.readLong(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _dailyActivityLogDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyActivityLogGetId(DailyActivityLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyActivityLogGetLinks(DailyActivityLog object) {
  return [];
}

void _dailyActivityLogAttach(
    IsarCollection<dynamic> col, Id id, DailyActivityLog object) {
  object.id = id;
}

extension DailyActivityLogByIndex on IsarCollection<DailyActivityLog> {
  Future<DailyActivityLog?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyActivityLog? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyActivityLog?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyActivityLog?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyActivityLog object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyActivityLog object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyActivityLog> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyActivityLog> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyActivityLogQueryWhereSort
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QWhere> {
  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyActivityLogQueryWhere
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QWhereClause> {
  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterWhereClause>
      dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyActivityLogQueryFilter
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QFilterCondition> {
  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      averageProductivityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageProductivity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      averageProductivityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageProductivity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      averageProductivityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageProductivity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      averageProductivityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageProductivity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      dayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      firstActivityAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstActivityAt',
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      firstActivityAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firstActivityAt',
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      firstActivityAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstActivityAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      firstActivityAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstActivityAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      firstActivityAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstActivityAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      firstActivityAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstActivityAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      isWeekendEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWeekend',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      lastActivityAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastActivityAt',
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      lastActivityAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastActivityAt',
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      lastActivityAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastActivityAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      lastActivityAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastActivityAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      lastActivityAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastActivityAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      lastActivityAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastActivityAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      productivitySumEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productivitySum',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      productivitySumGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productivitySum',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      productivitySumLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productivitySum',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      productivitySumBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productivitySum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tasksCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksScheduledEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tasksScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksScheduledGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tasksScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksScheduledLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tasksScheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksScheduledBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tasksScheduled',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksSkippedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tasksSkipped',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksSkippedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tasksSkipped',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksSkippedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tasksSkipped',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      tasksSkippedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tasksSkipped',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterFilterCondition>
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

extension DailyActivityLogQueryObject
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QFilterCondition> {}

extension DailyActivityLogQueryLinks
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QFilterCondition> {}

extension DailyActivityLogQuerySortBy
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QSortBy> {
  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByAverageProductivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageProductivity', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByAverageProductivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageProductivity', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByFirstActivityAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstActivityAt', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByFirstActivityAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstActivityAt', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByIsWeekend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeekend', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByIsWeekendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeekend', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByLastActivityAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivityAt', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByLastActivityAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivityAt', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByProductivitySum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivitySum', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByProductivitySumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivitySum', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompleted', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByTasksScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksScheduled', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByTasksScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksScheduled', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByTasksSkipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksSkipped', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByTasksSkippedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksSkipped', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DailyActivityLogQuerySortThenBy
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QSortThenBy> {
  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByAverageProductivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageProductivity', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByAverageProductivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageProductivity', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByFirstActivityAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstActivityAt', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByFirstActivityAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstActivityAt', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByIsWeekend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeekend', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByIsWeekendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeekend', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByLastActivityAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivityAt', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByLastActivityAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActivityAt', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByProductivitySum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivitySum', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByProductivitySumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productivitySum', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksCompleted', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByTasksScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksScheduled', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByTasksScheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksScheduled', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByTasksSkipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksSkipped', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByTasksSkippedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksSkipped', Sort.desc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension DailyActivityLogQueryWhereDistinct
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct> {
  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByAverageProductivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageProductivity');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfWeek');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByFirstActivityAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstActivityAt');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByIsWeekend() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWeekend');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByLastActivityAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastActivityAt');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByProductivitySum() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productivitySum');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tasksCompleted');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByTasksScheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tasksScheduled');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByTasksSkipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tasksSkipped');
    });
  }

  QueryBuilder<DailyActivityLog, DailyActivityLog, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension DailyActivityLogQueryProperty
    on QueryBuilder<DailyActivityLog, DailyActivityLog, QQueryProperty> {
  QueryBuilder<DailyActivityLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyActivityLog, double, QQueryOperations>
      averageProductivityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageProductivity');
    });
  }

  QueryBuilder<DailyActivityLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyActivityLog, int, QQueryOperations> dayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfWeek');
    });
  }

  QueryBuilder<DailyActivityLog, DateTime?, QQueryOperations>
      firstActivityAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstActivityAt');
    });
  }

  QueryBuilder<DailyActivityLog, bool, QQueryOperations> isWeekendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWeekend');
    });
  }

  QueryBuilder<DailyActivityLog, DateTime?, QQueryOperations>
      lastActivityAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastActivityAt');
    });
  }

  QueryBuilder<DailyActivityLog, double, QQueryOperations>
      productivitySumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productivitySum');
    });
  }

  QueryBuilder<DailyActivityLog, int, QQueryOperations>
      tasksCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tasksCompleted');
    });
  }

  QueryBuilder<DailyActivityLog, int, QQueryOperations>
      tasksScheduledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tasksScheduled');
    });
  }

  QueryBuilder<DailyActivityLog, int, QQueryOperations> tasksSkippedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tasksSkipped');
    });
  }

  QueryBuilder<DailyActivityLog, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
