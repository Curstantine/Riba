import "package:json_annotation/json_annotation.dart";

part "error.g.dart";

@JsonSerializable(createToJson: false)
class MDError {
  final String title;
  final int status;
  final String? detail;

  const MDError({required this.title, required this.status, this.detail});

  factory MDError.fromJson(Map<String, dynamic> json) => _$MDErrorFromJson(json);
}
