import "package:riba/repositories/utils/exception.dart";

class ErrorState {
  final String title;
  final String description;

  const ErrorState({required this.title, required this.description});

  @override
  String toString() => "$title: $description";
}

ErrorState handleError(Object object) {
  late String title;
  late String description;

  switch (object.runtimeType) {
    case MDException:
      object as MDException;
      title = object.status.toString();
      description = object.title;
      break;
    default:
      title = "Came across an unknown error!";
      description = object.toString();
  }

  return ErrorState(title: title, description: description);
}
