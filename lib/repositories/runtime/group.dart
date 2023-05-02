// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:riba/repositories/local/models/group.dart";
import "package:riba/repositories/local/models/user.dart";

class GroupData {
  final Group group;
  final Map<String, User> users;

  const GroupData({required this.group, required this.users});
}
