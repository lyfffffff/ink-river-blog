// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommentEntityCollection on Isar {
  IsarCollection<CommentEntity> get commentEntitys => this.collection();
}

const CommentEntitySchema = CollectionSchema(
  name: r'CommentEntity',
  id: -3704154162047423663,
  properties: {
    r'authorInitial': PropertySchema(
      id: 0,
      name: r'authorInitial',
      type: IsarType.string,
    ),
    r'authorName': PropertySchema(
      id: 1,
      name: r'authorName',
      type: IsarType.string,
    ),
    r'commentId': PropertySchema(
      id: 2,
      name: r'commentId',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 3,
      name: r'content',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'likeCount': PropertySchema(
      id: 5,
      name: r'likeCount',
      type: IsarType.long,
    ),
    r'postId': PropertySchema(
      id: 6,
      name: r'postId',
      type: IsarType.string,
    ),
    r'timeAgo': PropertySchema(
      id: 7,
      name: r'timeAgo',
      type: IsarType.string,
    )
  },
  estimateSize: _commentEntityEstimateSize,
  serialize: _commentEntitySerialize,
  deserialize: _commentEntityDeserialize,
  deserializeProp: _commentEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'commentId': IndexSchema(
      id: 3609824276468662262,
      name: r'commentId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'commentId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'postId': IndexSchema(
      id: -544810920068516617,
      name: r'postId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'postId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _commentEntityGetId,
  getLinks: _commentEntityGetLinks,
  attach: _commentEntityAttach,
  version: '3.1.0+1',
);

int _commentEntityEstimateSize(
  CommentEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.authorInitial.length * 3;
  bytesCount += 3 + object.authorName.length * 3;
  bytesCount += 3 + object.commentId.length * 3;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.postId.length * 3;
  bytesCount += 3 + object.timeAgo.length * 3;
  return bytesCount;
}

void _commentEntitySerialize(
  CommentEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.authorInitial);
  writer.writeString(offsets[1], object.authorName);
  writer.writeString(offsets[2], object.commentId);
  writer.writeString(offsets[3], object.content);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeLong(offsets[5], object.likeCount);
  writer.writeString(offsets[6], object.postId);
  writer.writeString(offsets[7], object.timeAgo);
}

CommentEntity _commentEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CommentEntity();
  object.authorInitial = reader.readString(offsets[0]);
  object.authorName = reader.readString(offsets[1]);
  object.commentId = reader.readString(offsets[2]);
  object.content = reader.readString(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.id = id;
  object.likeCount = reader.readLong(offsets[5]);
  object.postId = reader.readString(offsets[6]);
  object.timeAgo = reader.readString(offsets[7]);
  return object;
}

P _commentEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _commentEntityGetId(CommentEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _commentEntityGetLinks(CommentEntity object) {
  return [];
}

void _commentEntityAttach(
    IsarCollection<dynamic> col, Id id, CommentEntity object) {
  object.id = id;
}

extension CommentEntityByIndex on IsarCollection<CommentEntity> {
  Future<CommentEntity?> getByCommentId(String commentId) {
    return getByIndex(r'commentId', [commentId]);
  }

  CommentEntity? getByCommentIdSync(String commentId) {
    return getByIndexSync(r'commentId', [commentId]);
  }

  Future<bool> deleteByCommentId(String commentId) {
    return deleteByIndex(r'commentId', [commentId]);
  }

  bool deleteByCommentIdSync(String commentId) {
    return deleteByIndexSync(r'commentId', [commentId]);
  }

  Future<List<CommentEntity?>> getAllByCommentId(List<String> commentIdValues) {
    final values = commentIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'commentId', values);
  }

  List<CommentEntity?> getAllByCommentIdSync(List<String> commentIdValues) {
    final values = commentIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'commentId', values);
  }

  Future<int> deleteAllByCommentId(List<String> commentIdValues) {
    final values = commentIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'commentId', values);
  }

  int deleteAllByCommentIdSync(List<String> commentIdValues) {
    final values = commentIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'commentId', values);
  }

  Future<Id> putByCommentId(CommentEntity object) {
    return putByIndex(r'commentId', object);
  }

  Id putByCommentIdSync(CommentEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'commentId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCommentId(List<CommentEntity> objects) {
    return putAllByIndex(r'commentId', objects);
  }

  List<Id> putAllByCommentIdSync(List<CommentEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'commentId', objects, saveLinks: saveLinks);
  }
}

extension CommentEntityQueryWhereSort
    on QueryBuilder<CommentEntity, CommentEntity, QWhere> {
  QueryBuilder<CommentEntity, CommentEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommentEntityQueryWhere
    on QueryBuilder<CommentEntity, CommentEntity, QWhereClause> {
  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause>
      commentIdEqualTo(String commentId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'commentId',
        value: [commentId],
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause>
      commentIdNotEqualTo(String commentId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commentId',
              lower: [],
              upper: [commentId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commentId',
              lower: [commentId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commentId',
              lower: [commentId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'commentId',
              lower: [],
              upper: [commentId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause> postIdEqualTo(
      String postId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'postId',
        value: [postId],
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterWhereClause>
      postIdNotEqualTo(String postId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId',
              lower: [],
              upper: [postId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId',
              lower: [postId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId',
              lower: [postId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'postId',
              lower: [],
              upper: [postId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CommentEntityQueryFilter
    on QueryBuilder<CommentEntity, CommentEntity, QFilterCondition> {
  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authorInitial',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'authorInitial',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'authorInitial',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'authorInitial',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'authorInitial',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'authorInitial',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'authorInitial',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'authorInitial',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authorInitial',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorInitialIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'authorInitial',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'authorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'authorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'authorName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'authorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'authorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'authorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'authorName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'authorName',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      authorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'authorName',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commentId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      commentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commentId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
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

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
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

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
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

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
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

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      likeCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'likeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      likeCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'likeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      likeCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'likeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      likeCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'likeCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'postId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'postId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'postId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      postIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'postId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeAgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeAgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeAgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeAgo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeAgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeAgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeAgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeAgo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeAgo',
        value: '',
      ));
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterFilterCondition>
      timeAgoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timeAgo',
        value: '',
      ));
    });
  }
}

extension CommentEntityQueryObject
    on QueryBuilder<CommentEntity, CommentEntity, QFilterCondition> {}

extension CommentEntityQueryLinks
    on QueryBuilder<CommentEntity, CommentEntity, QFilterCondition> {}

extension CommentEntityQuerySortBy
    on QueryBuilder<CommentEntity, CommentEntity, QSortBy> {
  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      sortByAuthorInitial() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorInitial', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      sortByAuthorInitialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorInitial', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByAuthorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorName', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      sortByAuthorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorName', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByCommentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      sortByCommentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByLikeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'likeCount', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      sortByLikeCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'likeCount', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByPostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByTimeAgo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAgo', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> sortByTimeAgoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAgo', Sort.desc);
    });
  }
}

extension CommentEntityQuerySortThenBy
    on QueryBuilder<CommentEntity, CommentEntity, QSortThenBy> {
  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      thenByAuthorInitial() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorInitial', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      thenByAuthorInitialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorInitial', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByAuthorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorName', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      thenByAuthorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authorName', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByCommentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      thenByCommentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commentId', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByLikeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'likeCount', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy>
      thenByLikeCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'likeCount', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByPostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postId', Sort.desc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByTimeAgo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAgo', Sort.asc);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QAfterSortBy> thenByTimeAgoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAgo', Sort.desc);
    });
  }
}

extension CommentEntityQueryWhereDistinct
    on QueryBuilder<CommentEntity, CommentEntity, QDistinct> {
  QueryBuilder<CommentEntity, CommentEntity, QDistinct> distinctByAuthorInitial(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'authorInitial',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QDistinct> distinctByAuthorName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'authorName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QDistinct> distinctByCommentId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QDistinct> distinctByLikeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'likeCount');
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QDistinct> distinctByPostId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'postId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommentEntity, CommentEntity, QDistinct> distinctByTimeAgo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeAgo', caseSensitive: caseSensitive);
    });
  }
}

extension CommentEntityQueryProperty
    on QueryBuilder<CommentEntity, CommentEntity, QQueryProperty> {
  QueryBuilder<CommentEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CommentEntity, String, QQueryOperations>
      authorInitialProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'authorInitial');
    });
  }

  QueryBuilder<CommentEntity, String, QQueryOperations> authorNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'authorName');
    });
  }

  QueryBuilder<CommentEntity, String, QQueryOperations> commentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commentId');
    });
  }

  QueryBuilder<CommentEntity, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<CommentEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CommentEntity, int, QQueryOperations> likeCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'likeCount');
    });
  }

  QueryBuilder<CommentEntity, String, QQueryOperations> postIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'postId');
    });
  }

  QueryBuilder<CommentEntity, String, QQueryOperations> timeAgoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeAgo');
    });
  }
}
