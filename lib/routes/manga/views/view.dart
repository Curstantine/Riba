import "dart:async";
import "dart:io";

import "package:flutter/material.dart" hide Locale, Localizations;
import "package:flutter/services.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/chapter.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/buttons.dart";
import "package:riba/routes/manga/widgets/chips.dart";
import "package:riba/routes/manga/widgets/lists/chapter.dart";
import "package:riba/routes/manga/widgets/sheets/cover.dart";
import "package:riba/routes/manga/widgets/sheets/rating.dart";
import "package:riba/settings/manga_filter/store.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/hash.dart";
import "package:riba/utils/lazy.dart";
import "package:riba/utils/theme.dart";

class MangaView extends StatefulWidget {
	const MangaView({super.key, required this.id});

	final String id;

	@override
	State<MangaView> createState() => _MangaViewState();
}

class _MangaViewState extends State<MangaView> {
	final expandedAppBarHeight = 500.0;
	final logger = Logger("MangaView");
	final scrollController = ScrollController();

	final showAppBar = ValueNotifier(false);
	final isDescriptionExpanded = ValueNotifier(false);
	final areFiltersApplied = ValueNotifier(false);

	late final preferredCoverIdStream = MangaDex.instance.manga.database.where()
		.isarIdEqualTo(fastHash(widget.id))
		.preferredCoverIdProperty()
		.watch()
		.asyncMap((e) => e.first);

	late Future<MangaData> mangaFuture;
	late Future<Statistics> statisticsFuture;

	final coverController = StreamController<File?>();
	final chapterController = StreamController<CollectionData<ChapterData>>();

	final isFollowed = ValueNotifier(false);
	final hasTrackers = ValueNotifier(false);
	final hasCustomLists = ValueNotifier(false);

	int chapterOffset = 0;
	bool areChaptersEntirelyFetched = false;

	/// Cache of all the chapters fetched in this view.
	/// This is useful since the [chapterController] used is a one-time stream that
	/// discards rendered data.
	CollectionData<ChapterData>? chapterCache;

	Future<MangaFilterSettingsStore> get mangaFilterSettingsFuture => Settings.instance.mangaFilter.get(widget.id);

	@override
	void initState() {
		super.initState();
		fetchMangaData();

		// TODO: Currently, if the user somehow gets into a title w/ higher ordinality than
		// the user-selected content ratings, the title will be displayed.
		// We should probably show a small warning.

		scrollController.addListener(onScroll);
		preferredCoverIdStream.listen((e) {
			// While this behavior is somewhat undefined, all we 
			// want from this is to temporarily set the preferred id
			// so that the internal events could be triggered with
			// the fresh value.
			mangaFuture.then((x) => x.manga.copyWith.preferredCoverId(e));
			fetchCover(e);
		});
	}

	@override
	void dispose() {
		chapterController.close();
		coverController.close();
		scrollController.dispose();
		super.dispose();
	}

	Future<void> fetchMangaData({bool reload = false}) async {
		mangaFuture = MangaDex.instance.manga.get(widget.id, checkDB: !reload);
		statisticsFuture = MangaDex.instance.manga.getStatistics(widget.id, checkDB: !reload);

		await Future.wait([
			fetchCover(),
			fetchChapters(reload: reload),
		]);
	}

	Future<void> fetchCover([String? coverId]) async {
		try {
			final data = await mangaFuture;
			final cover = coverId == null
				? data.cover
				: (await MangaDex.instance.cover.get(coverId)).cover;

			if (cover == null) {
				coverController.add(null);
				return coverController.close();
			}

			final settings = Settings.instance.coverPersistence;
			final image = await MangaDex.instance.cover.getImage(
				widget.id,
				cover,
				size: settings.fullSize.value,
				cache: settings.enabled.value,
			);

			coverController.add(image);
		} catch (e) {
			coverController.addError(e);
		}
	}

	/// The initial fetch will first check if there are data available in the database, if it is,
	/// it will display everything available without prioritizing [offset] or [limit].
	///
	/// If there are no data available in the database, it will fetch everything from the API, 
	/// where it will [limit] accordingly.
	///
	/// In all cases, [areChaptersEntirelyFetched] will be set to true if the total number of
	/// chapters displayed is equal to the number of chapters available. This will not account
	/// for chapters that are out-of-sync from the server
	/// (e.g. deleted chapters, chapters published after the last sync.)
	/// 
	/// [chapterOffset] is only used for memo-ing the last offset. Instead, use [offset]
	/// to specify the offset to fetch from.
	/// 
	/// Issues:
	/// 1. When the whole list is not fetched from the get go, any session that
	/// did not load the data from the server will not be able to get chapters after the
	/// initial [offset] since the [areChaptersEntirelyFetched] is true in a database fetch.
	/// Reloading will fix this issue.
	Future<void> fetchChapters({bool reload = false, int offset = 0}) async {
		logger.info("Fetching chapters with offset $offset");
	
		try {
			final mangaSettings = await mangaFilterSettingsFuture;
			final contentSettings = Settings.instance.contentFilter;

			final data = await MangaDex.instance.chapter.getFeed(
				checkDB: !reload &&  offset == 0,
				overrides: MangaDexChapterGetFeedQueryFilter(
					mangaId: widget.id,
					offset: offset,
					excludedGroups: mangaSettings.excludedGroupIds,
					translatedLanguages: contentSettings.chapterLanguages.value,
				),
			);

			chapterOffset += data.data.length;
			areChaptersEntirelyFetched = data.total <= chapterOffset;
			chapterCache = chapterCache == null ? data : CollectionData(
				data: chapterCache!.data..addAll(data.data),
				total: data.total,
				limit: data.limit,
				offset: data.offset,
			);

			chapterController.add(chapterCache!);
		} catch (e) {
			chapterController.addError(e);
		}
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		final media = MediaQuery.of(context);
		final preferredDisplayLocales = Settings.instance.appearance.preferredDisplayLocales.value;

		return Scaffold(
			body: FutureBuilder(
				future: mangaFuture,
				builder: (context, mangaSnapshot) {
					if (mangaSnapshot.connectionState != ConnectionState.done) {
						return const Center(child: CircularProgressIndicator());
					}

					if (mangaSnapshot.hasError || !mangaSnapshot.hasData) {
						final error = handleError(mangaSnapshot.error ?? "Data was null without errors.");

						return Center(
							child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
								Text(error.title, style: theme.textTheme.titleLarge),
								Text(error.description, style: theme.textTheme.bodyMedium),
								const SizedBox(height: Edges.large),
								ElevatedButton(
									onPressed: () => setState(() => fetchMangaData(reload: true)),
									child: const Text("Retry"),
								),
							]),
						);
					}

					final mangaData = mangaSnapshot.requireData;

					return RefreshIndicator(
						onRefresh: refresh,
						child: CustomScrollView(controller: scrollController, slivers: [
							buildAppBar(text, colors, media, preferredDisplayLocales, mangaData),
							SliverToBoxAdapter(child: DescriptionSection(
								description: mangaData.manga.description,
								isExpanded: isDescriptionExpanded,
								preferredLocales: preferredDisplayLocales,
							)),
							SliverToBoxAdapter(child: buildReadButton()),
							ChapterList(
								mangaId: widget.id,
								chapterStream: chapterController.stream,
								onFilterApplied: onFiltersApplied
							),
						]),
					);
				},
			),
		);
	}

	Widget buildAppBar(
		TextTheme text,
		ColorScheme colors,
		MediaQueryData media,
		List<Locale> preferredDisplayLocales,
		MangaData mangaData,
	) {
		return SliverAppBar(
			pinned: true,
			expandedHeight: expandedAppBarHeight,
			title: ValueListenableBuilder(
				valueListenable: showAppBar,
				child: Text(
					mangaData.manga.titles.getPreferred(preferredDisplayLocales),
					style: text.titleMedium,
				),
				builder: (context, value, child) => AnimatedOpacity(
					opacity: value ? 1 : 0,
					duration: Durations.standard,
					child: child,
				),
			),
			flexibleSpace: FlexibleSpaceBar(
				collapseMode: CollapseMode.pin,
				titlePadding: Edges.allNone,
				background: DetailsHeader(
					height: expandedAppBarHeight + media.padding.top,
					isFollowed: isFollowed,
					hasTrackers: hasTrackers,
					hasCustomLists: hasCustomLists,
					preferredLocales: preferredDisplayLocales,
					mangaData: mangaData,
					coverStream: coverController.stream,
					statisticsFuture: statisticsFuture,
				),
			),
		);
	}

	Widget buildReadButton() {
		return Padding(
			padding: Edges.horizontalLarge.copyWithSelf(Edges.verticalMedium),
			child: FilledButton.tonal(
				onPressed: () {},
				child: const Text("Start Reading"),
			),
		);
	}

	void onScroll() {
		final height = expandedAppBarHeight - kToolbarHeight;

		if (showAppBar.value && scrollController.offset < height) {
			showAppBar.value = false;
		} else if (!showAppBar.value && scrollController.offset > height) {
			showAppBar.value = true;
		}

		if (scrollController.offset >= scrollController.position.maxScrollExtent) {
			onChapterListBottomReached();
		}
	}

	void onChapterListBottomReached() {
		if (!areChaptersEntirelyFetched) fetchChapters(offset: chapterOffset);
	}

	Future<void> onFiltersApplied() async {
		chapterOffset = 0;
		chapterCache = null;
		await fetchChapters(offset: 0, reload: !areChaptersEntirelyFetched);
	}

	Future<void> refresh() async {
		chapterOffset = 0;
		chapterCache = null;
		areChaptersEntirelyFetched = false;
		await fetchMangaData(reload: true);
	}
}

class DetailsHeader extends StatelessWidget {
  	const DetailsHeader({
		super.key,
		required this.height,
		required this.mangaData,
		required this.statisticsFuture,
		required this.coverStream,
		required this.preferredLocales,
		required this.isFollowed,
		required this.hasTrackers,
		required this.hasCustomLists,
	}) : assert(height > 100);
  
	final double height;
	final MangaData mangaData;
	final Future<Statistics> statisticsFuture;

	/// Stream of the cover image.
	/// 
	/// This stream should return null with an active connection if the image is loading.
	/// 
	/// To represent empty state, the stream should return null with a closed connection.
	final Stream<File?> coverStream;

	final List<Locale> preferredLocales;
	final ValueNotifier<bool> isFollowed;
	final ValueNotifier<bool> hasTrackers;
	final ValueNotifier<bool> hasCustomLists;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return Stack(
			children: [
				buildImage(text, colors),
				buildDetails(context, text, colors),
			],
		);
	}

	Widget buildImage(TextTheme text, ColorScheme colors) {
		return Container(
			width: double.infinity,
			height:  height,
			foregroundDecoration: BoxDecoration(
				gradient: LinearGradient(
					begin: Alignment.topCenter,
					end: Alignment.bottomCenter,
					stops: const [0, 0.5, 0.65, 1],
					colors: [
						colors.background.withOpacity(0),
						colors.background.withOpacity(0.85),
						colors.background.withOpacity(0.95),
						colors.background,
					],
				),
			),
			child: StreamBuilder<File?>(
				stream: coverStream,
				builder: (context, snapshot) {
					List<Widget>? children;

					if (snapshot.connectionState != ConnectionState.active) {
						children = [const CircularProgressIndicator()];
					}

					if (snapshot.hasError) {
						final error = handleError(snapshot.error!);
						children = [
							Text(error.title, style: text.titleMedium?.copyWith(color: colors.error)),
							Text(error.description)
						];
					}

					if (!snapshot.hasData &&
						!snapshot.hasError &&
						snapshot.connectionState == ConnectionState.done) {
						children = [
							Icon(Symbols.image_not_supported_rounded, size: 42, color: colors.primary),
							const SizedBox(height: Edges.small),
							Text("Covers are not available.", style: text.bodyMedium),
						];
					}

					if (children != null) {
						return Align(
							alignment: Alignment.topCenter,
							child: SizedBox(
								height: height - 100,
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									children: children,
								),
							),
						);
					}

					return Padding(
						padding: Edges.bottomSmall,
						child: Image.file(
							snapshot.data!,
							fit: BoxFit.cover,
							alignment: Alignment.topCenter,
						),
					);
				},
			),
		);
	}

	Widget buildDetails(BuildContext context, TextTheme text, ColorScheme colors) {
		final title = mangaData.manga.titles.getPreferred(preferredLocales);
		final authorList = (mangaData.authors + mangaData.artists.whereNotIn(mangaData.authors))
			.map((e) => e.name)
			.join(", ");


		return Container(
			height: height,
			width: double.infinity,
			padding: Edges.horizontalMedium.copyWith(bottom: Edges.large),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.end,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Expanded(child: InkWell(onTap: () => showCoverSheet(context))),
					Text(title, style: text.titleLarge),
					Text(authorList, style: text.labelMedium?.withColorOpacity(0.5)),
					const SizedBox(height: Edges.small),
					buildRatingsRow(text, colors),
					const SizedBox(height: Edges.small),
					Wrap(
						spacing: Edges.extraSmall,
						runSpacing: Edges.small,
						children: [
							ContentRatingChip(contentRating: mangaData.manga.contentRating),
							DemographicChip(demographic: mangaData.manga.publicationDemographic),
							for (final tag in mangaData.tags)
								TagChip(tag: tag, preferredLocales: preferredLocales),
						],
					),
					const SizedBox(height: Edges.large),
					SizedBox(
						height: 40,
						child: ListView(
							shrinkWrap: true,
							scrollDirection: Axis.horizontal,
							children: [
								buildFollowButton(),
								const SizedBox(width: Edges.small),
								// ValueListenableBuilder(
								// 	valueListenable: isFollowed,
								// 	builder: (context, value, _) => value 
								// 		? buildTrackerButton()
								// 		: const SizedBox.shrink(),
								// ),
								buildCustomListButton(),
							],
						),
					),
				],
			),
		);
	}

	Widget buildRatingsRow(TextTheme text, ColorScheme colors) {
		return SizedBox(
			height: 25,
			child: FutureBuilder<Statistics>(
				future: statisticsFuture,
				builder: (context, snapshot) {
					if (snapshot.hasError) {
						final error = handleError(snapshot.error!);
						final label = text.bodyMedium?.copyWith(color: colors.error);

						return InkWell(
							onLongPress: () {
								Clipboard.setData(ClipboardData(text: error.toString()));
								showLazyBar(context, "Error copied to clipboard.");
							},
							child: ListView(scrollDirection: Axis.horizontal, children: [
								Text(error.title, style: label),
								const SizedBox(width: Edges.small),
								Text(error.description, style: label?.withColorOpacity(0.75)),
							]),
						);
					}

					final rating = snapshot.data?.rating;
					final bayesian = rating?.bayesian ?? 0.0;
					final follows = snapshot.data?.follows ?? 0;
					final comments = snapshot.data?.comments?.total ?? 0;

					return Row(children: [
						TinyButton(
							enabled: rating != null,
							text: bayesian.toStringAsFixed(2),
							icon: Symbols.star_rate_rounded,
							onTap: () => rating == null
								? null
								: showRatingStatisticSheet(context, rating),
						),
						const SizedBox(width: Edges.small),
						TinyButton(
							enabled: snapshot.data?.follows != null,
							text: follows.toString(),
							icon: Symbols.bookmark_rounded,
						),
						const SizedBox(width: Edges.small),
						TinyButton(
							enabled: snapshot.data?.comments != null,
							text: comments.toString(),
							icon: Symbols.comment_rounded,
						),
					]);
				},
			),
		);
	}

	Widget buildFollowButton() {
		return ValueListenableBuilder(
			valueListenable: isFollowed,
			builder: (context, value, _) => FilledButton.icon(
				onPressed: handleFollowTap,
				icon: value ? const Icon(Symbols.check_rounded) : const Icon(Symbols.add_rounded),
				label: AnimatedSize(
					duration: Durations.standard,
					curve: Easing.standard,
					alignment: Alignment.centerLeft,
					child: value ?  const Text("Reading") : const Text("Add to Library"),
				),
			),
		);
	}

	Widget buildTrackerButton() {
		return ValueListenableBuilder(
			valueListenable: hasTrackers,
			builder: (context, value, _) => OutlinedButton.icon(
				onPressed: handleTrackerPress,
				icon: value ? const Icon(Symbols.sync_rounded) : const Icon(Symbols.add_rounded),
				label: AnimatedSize(
					duration: Durations.standard,
					curve: Easing.standard,
					alignment: Alignment.centerLeft,
					child: value ?  const Text("Tracking") : const Text("Track"),
				),
			),
		);
	}

	Widget buildCustomListButton() {
		return OutlinedButton(onPressed: () => {}, child: const Text("Custom Lists"));
	}

	Future<void> showCoverSheet(BuildContext context) {
		final media = MediaQuery.of(context);

		return showModalBottomSheet(
			context: context,
			shape: Shapes.none,
			isScrollControlled: true,
			builder: (context) => CoverSheet(
				mangaData: mangaData,
				padding: EdgeInsets.only(top: media.padding.top, bottom: media.padding.bottom),
			),
		);
	}

	Future<void> showRatingStatisticSheet(BuildContext context, RatingStatistics rating) {
		final media = MediaQuery.of(context);

		return showModalBottomSheet(
			context: context,
			builder: (context) => RatingDetailsSheet(
				rating: rating,
				padding: EdgeInsets.only(bottom: media.padding.bottom),
			),
		);
  }

	void handleTrackerPress() {
		hasTrackers.value = !hasTrackers.value;
	}

	void handleFollowTap() {
		isFollowed.value = !isFollowed.value;
	}
}

class DescriptionSection extends StatelessWidget {
	const DescriptionSection({
		super.key,
		required this.isExpanded,
		required this.description,
		required this.preferredLocales,	
	});

	final ValueNotifier<bool> isExpanded;
	final Localizations description;
	final List<Locale> preferredLocales;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		final media = MediaQuery.of(context);
		final textScaleFactor = media.textScaleFactor;

		final span = TextSpan(
			text: description.getPreferred(preferredLocales),
			style: text.bodyMedium,
		);

		final content = Text.rich(span);

		return Padding(
			padding: Edges.horizontalMedium,
			child: LayoutBuilder(builder: (context, constraints) {
				final minTp = TextPainter(
					text: span,
					maxLines: 4,
					textDirection: TextDirection.ltr,
					textScaleFactor: textScaleFactor,
					strutStyle: StrutStyle.fromTextStyle(span.style!))
				..layout(maxWidth: constraints.maxWidth, minWidth: constraints.minWidth);

				final maxTp = TextPainter(
					text: span,
					textDirection: TextDirection.ltr,
					strutStyle: StrutStyle.fromTextStyle(span.style!),
					textScaleFactor: textScaleFactor,
				)..layout(maxWidth: constraints.maxWidth, minWidth: constraints.minWidth);

				if (!minTp.didExceedMaxLines) {
					return content;
				}

				return ValueListenableBuilder(
					valueListenable: isExpanded,
					builder: (context, value, _) => Stack(children: [
						buildWallOfText(text, colors, minTp, maxTp, content, value),
						buildExpansionButton(colors, value),
					]),
				);
			}),
		);
	}

	Widget buildWallOfText(
		TextTheme text,
		ColorScheme colors,
		TextPainter minTp,
		TextPainter maxTp,
		Text content,
		bool expanded,
	) {
		return AnimatedContainer(
			height: expanded ? maxTp.height + Edges.extraLarge : minTp.height,
			curve: Easing.emphasized,
			duration: Durations.emphasized,
			clipBehavior: Clip.hardEdge,
			decoration: const BoxDecoration(),
			foregroundDecoration: BoxDecoration(
				gradient: expanded
					? null
					: LinearGradient(
						begin: Alignment.topCenter,
						end: Alignment.bottomCenter,
						stops: const [0, 0.5, 0.75, 1],
						colors: [
							colors.background.withOpacity(0),
							colors.background.withOpacity(0.75),
							colors.background.withOpacity(0.95),
							colors.background,
						],
					),
			),
			child: content,
		);
	}

	Widget buildExpansionButton(ColorScheme colors, bool expanded) {
		return Positioned(
			bottom: 0,
			right: 0,
			child: IconButton(
				isSelected: expanded,
				icon: AnimatedRotation(
					duration: Durations.emphasized,
					turns: expanded ? 0.5 : 0,
					curve: Curves.easeInOutCubic,
					child: const Icon(Symbols.expand_more_rounded),
				),
				visualDensity: VisualDensity.compact,
				tooltip: expanded ? "Collapse" : "Expand",
				onPressed: () => isExpanded.value = !expanded,
				style: IconButton.styleFrom(
					backgroundColor: expanded ? colors.primaryContainer : null,
					foregroundColor: expanded ? colors.onPrimaryContainer : null),
			),
		);
	}
	
}
