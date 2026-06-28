// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallpaperEntityAdapter extends TypeAdapter<WallpaperEntity> {
  @override
  final typeId = 0;

  @override
  WallpaperEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallpaperEntity(
      id: (fields[0] as num).toInt(),
      width: (fields[1] as num).toInt(),
      height: (fields[2] as num).toInt(),
      imageUrl: fields[3] as String,
      photographer: fields[4] as String,
      photographerUrl: fields[5] as String,
      title: fields[6] as String,
      likedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WallpaperEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.photographer)
      ..writeByte(5)
      ..write(obj.photographerUrl)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.likedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallpaperEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
