import "dart:async";

class Enumerate<T, R> {
  final List<T> items;
  final int perStep;
  final FutureOr<void> Function(Map<T, R?>) onStep;
  final void Function(List<T>)? onMismatch;

  /// Enumerates over a list of items, while handing them over to [onStep] as batches of [perStep].
  /// Useful for repeating the same operation on a list of items without worrying about the
  /// logic.
  ///
  /// T can only be either [String] or [int].
  ///
  /// [onStep] should manipulate the given [Map] and resolve their values, or leave them as `null`
  /// which will be later marked as mismatched.
  Enumerate({
    required this.items,
    required this.perStep,
    required this.onStep,
    this.onMismatch,
  }) : assert(T == String || T == int, "T must be either String or int.");

  /// Runs the enumeration.
  ///
  /// Returns a [Future] that resolves to a [Map] of all items and their resolved values.
  ///
  /// NOTE: Mismatched items are ignored, which you can handle with [onMismatch].
  Future<Map<T, R>> run() async {
    final Map<T, R> resolved = {};
    final promisedSet = Set<T>.from(items);

    while (promisedSet.isNotEmpty) {
      final items = promisedSet.take(perStep).toList();
      final results = Map<T, R?>.fromIterable(items, value: (_) => null);

      await onStep.call(results);

      final mismatch = results.entries.where((e) => e.value == null).map((e) => e.key).toList();
      if (mismatch.isNotEmpty) onMismatch?.call(mismatch);

      // We don't care about mismatched items. We skip them.
      for (final item in mismatch) {
        results.remove(item);
      }

      promisedSet.removeAll(items);
      resolved.addAll(results.cast());
    }

    return resolved;
  }
}
