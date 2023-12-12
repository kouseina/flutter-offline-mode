// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Links extends _Links with RealmEntity, RealmObjectBase, RealmObject {
  Links(
    ObjectId id, {
    String? title,
    String? address,
    User? user,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'user', user);
  }

  Links._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get title => RealmObjectBase.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObjectBase.set(this, 'title', value);

  @override
  String? get address =>
      RealmObjectBase.get<String>(this, 'address') as String?;
  @override
  set address(String? value) => RealmObjectBase.set(this, 'address', value);

  @override
  User? get user => RealmObjectBase.get<User>(this, 'user') as User?;
  @override
  set user(covariant User? value) => RealmObjectBase.set(this, 'user', value);

  @override
  Stream<RealmObjectChanges<Links>> get changes =>
      RealmObjectBase.getChanges<Links>(this);

  @override
  Links freeze() => RealmObjectBase.freezeObject<Links>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Links._);
    return const SchemaObject(ObjectType.realmObject, Links, 'Links', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string, optional: true),
      SchemaProperty('address', RealmPropertyType.string, optional: true),
      SchemaProperty('user', RealmPropertyType.object,
          optional: true, linkTarget: 'User'),
    ]);
  }
}

class User extends _User with RealmEntity, RealmObjectBase, RealmObject {
  User({
    String? id,
    String? name,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  User._();

  @override
  String? get id => RealmObjectBase.get<String>(this, 'id') as String?;
  @override
  set id(String? value) => RealmObjectBase.set(this, 'id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<User>> get changes =>
      RealmObjectBase.getChanges<User>(this);

  @override
  User freeze() => RealmObjectBase.freezeObject<User>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(User._);
    return const SchemaObject(ObjectType.realmObject, User, 'User', [
      SchemaProperty('id', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
    ]);
  }
}
