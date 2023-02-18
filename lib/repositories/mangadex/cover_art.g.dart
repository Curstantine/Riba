// GENERATED CODE - DO NOT MODIFY BY HAND

part of "cover_art.dart";

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoverSizeAdapter extends TypeAdapter<CoverSize> {
  @override
  final int typeId = 2;

  @override
  CoverSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CoverSize.original;
      case 1:
        return CoverSize.medium;
      case 2:
        return CoverSize.small;
      default:
        return CoverSize.original;
    }
  }

  @override
  void write(BinaryWriter writer, CoverSize obj) {
    switch (obj) {
      case CoverSize.original:
        writer.writeByte(0);
        break;
      case CoverSize.medium:
        writer.writeByte(1);
        break;
      case CoverSize.small:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoverSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
