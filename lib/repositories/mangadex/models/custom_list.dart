import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/models/custom_list.dart";
import "package:riba/repositories/runtime/custom_list.dart";

import "general.dart";
import "relationship.dart";
import "user.dart";

part "custom_list.g.dart";

typedef CustomListEntity = MDEntityResponse<CustomListAttributes>;

@JsonSerializable(createToJson: false)
class CustomListAttributes {
  final String name;
  final CustomListVisibility visibility;
  final int version;

  const CustomListAttributes({
    required this.name,
    required this.visibility,
    required this.version,
  });

  factory CustomListAttributes.fromJson(Map<String, dynamic> json) =>
      _$CustomListAttributesFromJson(json);
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUMS
@JsonEnum()
enum CustomListVisibility {
  public,
  private;
}

extension ToCustomList on MDResponseData<CustomListAttributes> {
  CustomList toCustomList() {
    return CustomList(
      id: id,
      name: attributes.name,
      visibility: attributes.visibility,
      version: attributes.version,
      mangaIds: relationships.ofType(EntityType.manga).map((e) => e.id).toList(),
      userId: relationships.ofType(EntityType.user).first.id,
    );
  }

  CustomListData toCustomListData() {
    return CustomListData(
      list: toCustomList(),
      user: relationships.ofType<UserAttributes>(EntityType.user).first.asUser(),
    );
  }
}
