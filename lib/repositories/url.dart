class URL {
  final String hostname;
  final List<String> pathSegments;
  final Map<String, List<String>> queryParameters = {};
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
  /// Adding a single value to a key will append it to the list of values.
  /// But adding a list of values will replace the existing list.
  ///
  /// If the value is a list, and it is empty, it will be ignored.
  URL setParameter(String key, dynamic value) {
    assert(value is List<String> || value is String || value is int || value is double);

    if (value is List && value.isEmpty) return this;
    if (value is List<String>) queryParameters[key] = value;

    if (value is String || value is int || value is double) {
      final old = queryParameters.containsKey(key) ? queryParameters[key] : [];
      queryParameters[key] = [...old!, value.toString()];
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

  URL copy() {
    return copyWith(
      useHttps: useHttps,
      hostname: hostname,
      pathSegments: List.from(pathSegments),
      queryParameters: Map.from(queryParameters),
    );
  }

  Uri toUri() {
    return Uri(
      scheme: useHttps ? "https" : "http",
      host: hostname,
      pathSegments: pathSegments,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }

  @override
  String toString() => toUri().toString();
}
