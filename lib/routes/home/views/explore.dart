import "dart:async";

import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/manga.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/home/model.dart";
import "package:riba/routes/manga/widgets/lists/horizontal.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:rxdart/rxdart.dart";

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

		return SafeArea(
			child: ListView(
				primary: true,
				padding: Edges.topSmall,
				children: [buildSeasonal(text)],
			),
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
					final error = handleError(snapshot.error ?? "Data was null without errors.");

					return SizedBox(
						height: 275,
						child: Center(child: Column(children: [
							Text(error.title, style: text.titleLarge),
							Text(error.description, style: text.bodyMedium),
						])),
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

class ExploreContentViewModel {
	final logger = Logger("ExploreContent");
	final seasonalScroll = ValueNotifier<double>(0);

	final _seasonalController = BehaviorSubject<Map<String, MangaData>>();
	ValueStream<Map<String, MangaData>> get seasonalStream => _seasonalController.stream;
	
	ExploreContentViewModel() {
		Settings.instance.contentFilter
			.watchLazily()
			.map((e) => loadSeasonalMangaData(force: true));
	}

	Future<void> loadSeasonalMangaData({bool force = false}) async {
		if (_seasonalController.hasValue && !force) {
			logger.info("Seasonal manga data already loaded, returning cached data.");
			return _seasonalController.add(_seasonalController.value);
		}

		try {
			final settings = Settings.instance.contentFilter;
			final seasonalList = await MangaDex.instance.customList.getSeasonal();
			final manga = await MangaDex.instance.manga.getMany(
				overrides: MangaDexMangaQueryFilter(
					ids: seasonalList.list.mangaIds,
					contentRatings: settings.contentRatings.value,
					originalLanguages: settings.originalLanguages.value,
				),
			);

			_seasonalController.add(manga);
		} catch (e) {
			_seasonalController.addError(e);
		}
	}
}