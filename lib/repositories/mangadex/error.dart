import "dart:convert";

class MDError {
  final String title;
  final int status;

  const MDError({required this.title, required this.status});

  factory MDError.fromMap(Map<String, dynamic> map) {
    return MDError(
      title: map["title"] as String,
      status: map["status"] as int,
    );
  }

  factory MDError.fromJson(String source) =>
      MDError.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MDException implements Exception {
  const MDException(this.response);
  final MDError response;

  get title => response.title;
  get status => response.status;

  @override
  String toString() => "MDException: ${response.title}";
}
