/// Base class that a serializable/deserializable/human-readable class should extend.
abstract class SerializableDataExt {
	SerializableDataExt.fromJson(String value);
	String toJson();
	String asHumanReadable();
}
