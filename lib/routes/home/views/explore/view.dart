
import "package:flutter/material.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/home/model.dart";
import "package:riba/routes/home/views/explore/model.dart";
import "package:riba/routes/home/views/explore/search.dart";
import "package:riba/routes/manga/widgets/lists/horizontal.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";

class ExploreContent extends StatefulWidget {
	const ExploreContent({super.key});

	@override
	State<ExploreContent> createState() => _ExploreContentState();
}

class _ExploreContentState extends State<ExploreContent> {	
	ExploreContentViewModel get viewModel => HomeViewModel.instance.exploreViewModel;

	@override
	void initState() {
		super.initState();
		viewModel.loadSeasonalMangaData();
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;

		return ListView(
			primary: true,
			children: [
				const SearchBarImpl(),
				const SizedBox(height: Edges.medium),
				buildSeasonal(text),
			],
		);
	}

	Widget buildSeasonal(TextTheme text) {
		return StreamBuilder<Map<String, MangaData>>(
			stream: viewModel.seasonalStream,
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.active) {
					return const SizedBox(
						height: 275,
						child: Center(child: CircularProgressIndicator()));
				}

				if (snapshot.hasError || !snapshot.hasData) {
					return SizedBox(
						height: 275,
						child:  ErrorCard(error: snapshot.error)
					);
				}

				return MangaHorizontalList(
					title: "Seasonal",
					scrollOffset: viewModel.seasonalScroll,
					mangaData: snapshot.requireData,
				);
			},
		);
	}
}
