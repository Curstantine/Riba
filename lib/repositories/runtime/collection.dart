class CollectionData<T> {
  final List<T> data;
  final int limit;
  final int offset;

  /// This value should specify the total amount
  /// of results available for the given constraints, regardless of whether it is
  /// included with [data] or not.
  ///
  /// When the value is `-1`, the underlying method does not know the total amount of results
  /// up front, and the value should be ignored.
  final int total;

  /// Runtime type used to return data that is stored in a collection, that could be paginated.
  const CollectionData({
    required this.data,
    required this.limit,
    required this.offset,
    required this.total,
  });
}
