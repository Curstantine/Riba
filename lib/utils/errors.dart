import "package:riba/repositories/mangadex/error.dart";

class ErrorState {
  final String title;
  final String description;

  const ErrorState({required this.title, required this.description});

  @override
  String toString() => "$title: $description";
}

ErrorState handleError(Object error) {
  late String title;
  late String description;

  if (error is MDException) {
    title = "Failed to reach MangaDex!";
    description = error.title;
  } else {
    title = "Came across an unknown error!";
    description = error.toString();
  }

  return ErrorState(title: title, description: description);
}
