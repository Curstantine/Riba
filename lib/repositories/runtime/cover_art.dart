// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/local/user.dart";

class CoverArtData {
  final CoverArt cover;
  final User? user;

  const CoverArtData({required this.cover, this.user});
}
