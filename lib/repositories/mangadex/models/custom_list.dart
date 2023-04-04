import "package:riba/repositories/local/custom_list.dart";
import "package:riba/repositories/runtime/custom_list.dart";

import "general.dart";
import "relationship.dart";
import "user.dart";

typedef CustomListEntity = MDEntityResponse<CustomListAttributes>;

class CustomListAttributes {
  final String name;
  final CustomListVisibility visibility;
  final int version;

  const CustomListAttributes({
    required this.name,
    required this.visibility,
    required this.version,
  });

  factory CustomListAttributes.fromMap(Map<String, dynamic> map) {
    return CustomListAttributes(
      name: map["name"] as String,
      visibility: CustomListVisibility.fromJsonValue(map["visibility"] as String),
      version: map["version"] as int,
    );
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUMS
enum CustomListVisibility {
  public,
  private;

  static Map<CustomListVisibility, String> get jsonValues => const {
        CustomListVisibility.public: "public",
        CustomListVisibility.private: "private",
      };

  factory CustomListVisibility.fromJsonValue(String str) {
    return jsonValues.entries.firstWhere((element) => element.value == str).key;
  }
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
      user: relationships.ofType<UserAttributes>(EntityType.user).first.toUser(),
    );
  }
}
