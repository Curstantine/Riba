import "package:riba/repositories/mangadex/error.dart";

import "url.dart";

const placeholderError = MDException(MDError(title: "Test", status: 404));

class MDException implements Exception {
  final MDError response;
  final URL? url;

  /// Exception thrown when a [MDError] was serialized from a request to the server.
  const MDException(this.response, {this.url});

  String get title => response.title;
  int get status => response.status;

  @override
  String toString() => "MDException: ${response.title}";
}

class LanguageNotSupportedException implements Exception {
  final String languageCode;

  /// Exception thrown when a [Language] is not found.
  const LanguageNotSupportedException(this.languageCode);

  @override
  String toString() => "Language $languageCode not found.";
}
