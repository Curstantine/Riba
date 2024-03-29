import "package:riba/repositories/mangadex/utils/serde_ext.dart";

class URL {
	final String hostname;
	final List<String> pathSegments;
	final Map<String, List<String>> parameters = {};
	bool useHttps;

	URL({
		required this.hostname,
		required this.pathSegments,
		this.useHttps = true,
	});

	URL copyWith({
		String? hostname,
		List<String>? pathSegments,
		Map<String, List<String>>? queryParameters,
		bool? useHttps,
	}) {
		return URL(
			hostname: hostname ?? this.hostname,
			pathSegments: pathSegments ?? this.pathSegments,
			useHttps: useHttps ?? this.useHttps,
		);
	}

	/// Supports `List<String>`, `String`, `int`, `double` as values.
	///
	/// Enums are supported if [SerializableDataExt] is implemented.
	/// 
	/// When new values are added, the old ones are overwritten.
	URL setParameter(String key, dynamic value) {
		if (value == null) return this;

		assert(value is String ||
			value is int ||
			value is double ||
			value is SerializableDataExt ||
			value is List<String> ||
			value is List<SerializableDataExt> ||
			value is List<dynamic> && value.isEmpty);
		// ^^ is for cases where an empty list is passed in, but the type is not inferred.
		// This case is handled below.
		if (value is List && value.isEmpty) return this;

		switch (value.runtimeType) {
			case const (List<String>):
				parameters[key] = value;
				break;

			case String:
			case int:
			case double:
				parameters[key] = [value.toString()];
				break;

			default:
				if (value is SerializableDataExt) {
					parameters[key] = [value.toJson()];
				}

				if (value is List<SerializableDataExt>) {
					parameters[key] = value.map((e) => e.toJson()).toList();
				}

			break;
		}

		return this;
	}

	URL addPathSegment(String segment) {
		pathSegments.add(segment);
		return this;
	}

	URL addPathSegments(List<String> segments) {
		pathSegments.addAll(segments);
		return this;
	}

	URL clone() {
		return copyWith(
			useHttps: useHttps,
			hostname: hostname,
			pathSegments: List.from(pathSegments),
			queryParameters: Map.from(parameters),
		);
	}

	Uri toUri() {
		return Uri(
			scheme: useHttps ? "https" : "http",
			host: hostname,
			pathSegments: pathSegments,
			queryParameters: parameters.isEmpty ? null : parameters,
		);
	}

	@override
	String toString() => toUri().toString();
}
