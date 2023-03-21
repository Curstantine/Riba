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
