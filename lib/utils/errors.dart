import "dart:io";

import "package:riba/repositories/utils/exception.dart";

class ErrorState {
	final String title;
	final String description;

	const ErrorState({required this.title, required this.description});

	factory ErrorState.fromSource(Object? object) {
		late String title;
		late String description;

		if (object == null) {
			title = "Came across an unknown error!";
			description = "Object was null without errors.";
			return ErrorState(title: title, description: description);
		}

		switch (object.runtimeType) {
			case MDException:
				object as MDException;
				title = object.status.toString();
				description = object.title;
			break;

			default:
				if (object is SocketException) {
					title = "No Internet Connection";
					description = object.toString();
					break;
				}

				title = "Came across an unknown error!";
				description = object.toString();
				break;
		}

		return ErrorState(title: title, description: description);
	}

	@override
	String toString() => "$title: $description";
}

