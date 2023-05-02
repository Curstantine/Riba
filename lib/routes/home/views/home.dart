import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/runtime/custom_list.dart";
import "package:riba/routes/manga/widgets/lists/horizontal.dart";
import "package:riba/utils/errors.dart";

class HomeContent extends StatelessWidget { 
	const HomeContent({super.key, required this.scrollOffset});

	final ValueNotifier<double> scrollOffset;

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
	final theme = Theme.of(context);
	final text = theme.textTheme;

    return FutureBuilder<CustomListData>(
		future: MangaDex.instance.customList.getSeasonal(),
		builder: (context, snapshot) {
			if (snapshot.connectionState != ConnectionState.done) {
				return const Center(child: CircularProgressIndicator());
			}

			if (snapshot.hasError || !snapshot.hasData) {
				final error = handleError(snapshot.error ?? "Data was null without errors.");

				return Center(child: Column(children: [
					Text(error.title, style: text.titleLarge),
					Text(error.description, style: text.bodyMedium),
				]));
			}

			return MangaHorizontalList(
				title: "Seasonal",
				scrollOffset: scrollOffset,
				mangaIds: snapshot.data!.list.mangaIds,
			);
		},
    );
  }
}
