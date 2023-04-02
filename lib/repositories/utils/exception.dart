import "package:riba/repositories/mangadex/models/error.dart";
import "package:riba/repositories/utils/url.dart";

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

class IncompleteDataException implements Exception {
  final String message;

  /// Exception thrown when a ser/de or a collector is missing required data.
  const IncompleteDataException(this.message);

  @override
  String toString() => "IncompleteDataException: $message";
}
