abstract class TwoWayEnumSerde implements Enum {
	TwoWayEnumSerde.fromJson(String value);
	String toJson();
	String asHumanReadable();
}
