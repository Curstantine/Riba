// GENERATED CODE - DO NOT MODIFY BY HAND

part of "theme.dart";

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeIdAdapter extends TypeAdapter<ThemeId> {
  @override
  final int typeId = 0;

  @override
  ThemeId read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeId.dynamic;
      case 1:
        return ThemeId.lavender;
      default:
        return ThemeId.dynamic;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeId obj) {
    switch (obj) {
      case ThemeId.dynamic:
        writer.writeByte(0);
        break;
      case ThemeId.lavender:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
