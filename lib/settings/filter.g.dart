// GENERATED CODE - DO NOT MODIFY BY HAND

part of "filter.dart";

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MangaFilterDataAdapter extends TypeAdapter<MangaFilterData> {
  @override
  final int typeId = 4;

  @override
  MangaFilterData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MangaFilterData()..excludedGroupIds = (fields[0] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, MangaFilterData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.excludedGroupIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaFilterDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
