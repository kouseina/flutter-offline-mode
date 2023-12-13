// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LinkAdapter extends TypeAdapter<_$LinkImpl> {
  @override
  final int typeId = 0;

  @override
  _$LinkImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$LinkImpl(
      id: fields[0] as String?,
      title: fields[1] as String?,
      address: fields[2] as String?,
      user: fields[3] as User?,
    );
  }

  @override
  void write(BinaryWriter writer, _$LinkImpl obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LinkImpl _$$LinkImplFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
    disallowNullValues: const ['id'],
  );
  return _$LinkImpl(
    id: json['id'] as String?,
    title: json['title'] as String?,
    address: json['address'] as String?,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$$LinkImplToJson(_$LinkImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['title'] = instance.title;
  val['address'] = instance.address;
  val['user'] = instance.user;
  return val;
}
