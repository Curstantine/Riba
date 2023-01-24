import "package:json_annotation/json_annotation.dart";

part "error.g.dart";

@JsonSerializable()
class MDError {
  final String title;
  final int status;

  const MDError({required this.title, required this.status});

  factory MDError.fromJson(Map<String, dynamic> json) => _$MDErrorFromJson(json);
}

class MDException implements Exception {
  const MDException(this.response);
  final MDError response;

  get title => response.title;
  get status => response.status;

  @override
  String toString() => "MDException: ${response.title}";
}
