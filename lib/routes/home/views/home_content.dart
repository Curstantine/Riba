import "package:flutter/material.dart";
import "package:riba/repositories/local/custom_list.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/routes/manga/widgets/horizontal_list.dart";

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final seasonalFuture = MangaDex.instance.customLists.getSeasonal();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        primary: true,
        children: [buildSeasonal(context)],
      ),
    );
  }

  Widget buildSeasonal(BuildContext context) {
    return FutureBuilder<CustomList>(
      future: seasonalFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error"));
        }

        return MangaHorizontalList(title: "Seasonal", mangaIds: snapshot.data!.manga);
      },
    );
  }
}