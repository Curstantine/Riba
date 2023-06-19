import "package:logging/logging.dart";

/// Base class for all view models to implement from.
abstract class ViewModel {
	abstract final Logger logger;
	ViewModel._internal();
	void dispose();
}