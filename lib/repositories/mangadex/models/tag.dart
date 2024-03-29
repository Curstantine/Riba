import "package:json_annotation/json_annotation.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/utils/serde_ext.dart";

import "general.dart";

part "tag.g.dart";

typedef TagEntity = MDEntityResponse<TagAttributes>;
typedef TagCollection = MDCollectionResponse<TagAttributes>;

@JsonSerializable(createToJson: false)
class TagAttributes {
	final Map<String, String> name;
	final TagGroup group;
	final Map<String, String> description;
	final int version;

	const TagAttributes({
		required this.name,
		required this.group,
		required this.description,
		required this.version,
	});

	factory TagAttributes.fromJson(Map<String, dynamic> source) => _$TagAttributesFromJson(source);
}

extension ToTag on MDResponseData<TagAttributes> {
	Tag toTag() => Tag(
		id: id,
		name: Localizations.fromMap(attributes.name),
		description: Localizations.fromMap(attributes.description),
		group: attributes.group,
		version: attributes.version,
	);
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
@JsonEnum(alwaysCreate: true)
enum TagGroup implements SerializableDataExt {
	content,
	format,
	genre,
	theme;

	@override
	factory TagGroup.fromJson(String source) => $enumDecode(_$TagGroupEnumMap, source);

	@override
	String toJson() => _$TagGroupEnumMap[this]!;

	@override
	String asHumanReadable() {
		switch (this) {
			case TagGroup.content:
				return "Content Warning";
			case TagGroup.format:
				return "Format";
			case TagGroup.genre:
				return "Genre";
			case TagGroup.theme:
				return "Theme";
		}
	}
}

@JsonEnum(alwaysCreate: true)
enum TagJoinMode implements SerializableDataExt {
	@JsonValue("AND")
	and,
	@JsonValue("OR")
	or;

	@override
	factory TagJoinMode.fromJson(String source) => $enumDecode(_$TagJoinModeEnumMap, source);

	@override
	String toJson() => _$TagJoinModeEnumMap[this]!;

	@override
	String asHumanReadable() {
		switch (this) {
			case TagJoinMode.and:
				return "And";
			case TagJoinMode.or:
				return "Or";
		}
	}
}
