import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/user.dart";

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
