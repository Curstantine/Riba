import "dart:async";

import "package:flutter/foundation.dart";

/// Create a debouncer that would wait for [duration] before calling the
/// [callback], and cancel the said callback if another call to [run] is
/// made before the [duration] is up.
class Debounce {
	final Duration duration;

	Debounce({required this.duration});

	FutureOr<void> Function()? callback;
	Timer? _timer;

	void run(VoidCallback callback) {
		this.callback = callback;
		_timer?.cancel();
		_timer = Timer(duration, () => this.callback?.call());
	}
}