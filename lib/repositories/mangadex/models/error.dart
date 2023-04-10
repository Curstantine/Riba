class MDError {
  final String title;
  final int status;
  final String? detail;

  const MDError({required this.title, required this.status, this.detail});

  factory MDError.fromMap(Map<String, dynamic> map) {
    return MDError(
      title: map["title"] as String,
      status: map["status"] as int,
      detail: map["detail"] as String?,
    );
  }
}
