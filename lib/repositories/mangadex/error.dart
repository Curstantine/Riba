import "package:riba/repositories/url.dart";

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
}

class MDException implements Exception {
  const MDException(this.response, {this.url});
  final MDError response;
  final URL? url;

  get title => response.title;
  get status => response.status;

  @override
  String toString() => "MDException: ${response.title}";
}
