abstract class TwoWayEnumSerde extends Enum {
  TwoWayEnumSerde.fromJson(String value);
  String toJson();
  String asHumanReadable();
}
