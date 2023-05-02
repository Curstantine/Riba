import "package:riba/repositories/local/models/chapter.dart";
import "package:riba/repositories/local/models/group.dart";
import "package:riba/repositories/local/models/user.dart";

class ChapterData {
  final Chapter chapter;
  final User uploader;
  final List<Group> groups;

  const ChapterData({
    required this.chapter,
    required this.uploader,
    required this.groups,
  });
}
