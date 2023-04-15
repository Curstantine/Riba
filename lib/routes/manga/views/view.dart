import "dart:async";
import "dart:io";

import "package:dash_flags/dash_flags.dart" as flags;
import "package:flutter/material.dart" hide Locale, Localizations;
import "package:flutter/services.dart";
import "package:intl/intl.dart" show DateFormat;
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/chapter.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/widgets/button.dart";
import "package:riba/routes/manga/widgets/chip.dart";
import "package:riba/routes/manga/widgets/sheet.dart";
import "package:riba/routes/manga/widgets/sheets/cover.dart";
import "package:riba/settings/cache.dart";
import "package:riba/settings/filter.dart";
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
	final preferredLanguages = [Language.english, Language.japanese];
	final preferredLocales = [Locale.en, Locale.jaRo, Locale.ja];

	final showAppBar = ValueNotifier(false);
	final isDescriptionExpanded = ValueNotifier(false);
	final areFiltersApplied = ValueNotifier(false);

	late final mangaFilterSettingsStream = MangaFilterSettings.ref
		.watchObject(fastHash(widget.id), fireImmediately: true)
		.asyncMap((e) => e ?? MangaFilterSettings(id: widget.id, excludedGroupIds: []));

	late final preferredCoverStream = MangaDex.instance.manga.database.where()
		.isarIdEqualTo(fastHash(widget.id))
		.preferredCoverIdProperty()
		.watch()
		.asyncMap((e) => e.first);

	late Future<MangaData> mangaFuture;
	late Future<Statistics> statisticsFuture;

	final coverController = StreamController<File?>();
	final chapterController = StreamController<CollectionData<ChapterData>>.broadcast();

	final isFollowed = ValueNotifier(false);
	final hasTrackers = ValueNotifier(false);
	final hasCustomLists = ValueNotifier(false);

	@override
	void initState() {
		super.initState();
		fetchMangaData();

		scrollController.addListener(onScroll);
		preferredCoverStream.listen(fetchCover);
	}

	@override
	void dispose() {
		chapterController.close();
		coverController.close();
		scrollController.dispose();
		super.dispose();
	}

	void fetchMangaData({bool reload = false}) {
		mangaFuture = MangaDex.instance.manga.get(widget.id, checkDB: !reload);
		statisticsFuture = MangaDex.instance.manga.getStatistics(widget.id, checkDB: !reload);

		fetchCover();
		fetchChapters(reload: reload).then(chapterController.add);
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

			final settings = await CoverCacheSettings.ref.getByKey(CoverCacheSettings.isarKey);
			final image = await MangaDex.instance.cover.getImage(
				widget.id,
				cover,
				size: settings!.fullSize,
				cache: settings.enabled,
			);

			coverController.add(image);
		} catch (e) {
			 coverController.addError(e);
		}
	}

	Future<CollectionData<ChapterData>> fetchChapters({bool reload = false, int offset = 0}) async {
		final filters = await MangaFilterSettings.ref.get(fastHash(widget.id)) ??
			MangaFilterSettings(id: widget.id, excludedGroupIds: []);

		final data = await MangaDex.instance.chapter.getFeed(
			checkDB: !reload,
			overrides: MangaDexChapterQueryFilter(
				mangaId: widget.id,
				translatedLanguages: preferredLanguages,
				excludedGroups: filters.excludedGroupIds,
			),
		);

		return data;
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		final media = MediaQuery.of(context);

		return Scaffold(
			backgroundColor: theme.colorScheme.background,
			body: FutureBuilder(
				// Lol. Don't setState for anything other than fetchMangaData.
				// Shit will break, badly.
				future: mangaFuture,
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) {
						return const Center(child: CircularProgressIndicator());
					}

					if (snapshot.hasError || !snapshot.hasData) {
						final error = handleError(snapshot.error ?? "Data was null without errors.");

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

					final mangaData = snapshot.requireData;

					return RefreshIndicator(
						onRefresh: () async {
							fetchMangaData(reload: true);
						},
						child: CustomScrollView(controller: scrollController, slivers: [
							buildAppBar(text, colors, media, mangaData),
							SliverToBoxAdapter(child: DescriptionSection(
								description: mangaData.manga.description,
								isExpanded: isDescriptionExpanded,
								preferredLocales: preferredLocales,
							)),
							SliverToBoxAdapter(child: buildReadButton()),
							SliverToBoxAdapter(child: ChapterInfoBar(
								mangaId: widget.id,
								chapterStream: chapterController.stream,
								filterStream: mangaFilterSettingsStream,
								onFilterApplied: onFiltersApplied,
							)),
							ChapterList(
								chapterStream: chapterController.stream,
								onBottomReached: onChapterListBottomReached,
							)
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
		MangaData mangaData,
	) {
		return SliverAppBar(
			pinned: true,
			expandedHeight: expandedAppBarHeight,
			title: ValueListenableBuilder(
				valueListenable: showAppBar,
				child: Text(
					mangaData.manga.titles.getPreferred(preferredLocales),
					style: text.titleMedium,
				),
				builder: (context, value, child) => AnimatedOpacity(
					opacity: value ? 1 : 0,
					duration: Durations.normal,
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
					preferredLocales: preferredLocales,
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
	}

	void onChapterListBottomReached() {}

	void onFiltersApplied() async {
		final chapters = await fetchChapters(reload: true);
		chapterController.add(chapters);
	}
}

class DetailsHeader extends StatelessWidget {
  	const DetailsHeader({
		super.key,
		required this.height,
		required this.mangaData,
		required this.coverStream,
		required this.statisticsFuture,
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
							Icon(Icons.image_not_supported_rounded, size: 42, color: colors.primary),
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
								const SizedBox(width: 8),
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
							icon: Icons.star_border_rounded,
							onTap: () => rating == null
								? null
								: showRatingStatisticSheet(context, rating),
						),
						const SizedBox(width: Edges.small),
						TinyButton(
							enabled: snapshot.data?.follows != null,
							text: follows.toString(),
							icon: Icons.bookmark_border_rounded,
						),
						const SizedBox(width: Edges.small),
						TinyButton(
							enabled: snapshot.data?.comments != null,
							text: comments.toString(),
							icon: Icons.comment_outlined,
						),
					]);
				},
			),
		);
	}

	Widget buildFollowButton() {
		return AnimatedSize(
			duration: Durations.slow,
			curve: Curves.easeInOut,
			alignment: Alignment.centerLeft,
			child: ValueListenableBuilder(
				valueListenable: isFollowed,
				builder: (context, value, _) {
					return FilledButton.icon(
						onPressed: handleFollowTap,
						icon: value ? const Icon(Icons.check_rounded) : const Icon(Icons.add_rounded),
						label: value ?  const Text("Reading") : const Text("Add to Library"),
					);
				},
			),
		);
	}

	Widget buildTrackerButton() {
		return AnimatedSize(
			duration: Durations.slow,
			curve: Curves.easeInOut,
			alignment: Alignment.centerLeft,
			child: ValueListenableBuilder(
				valueListenable: hasTrackers,
				builder: (context, value, _) {
					return OutlinedButton.icon(
						onPressed: handleTrackerPress,
						icon: value ? const Icon(Icons.sync_rounded) : const Icon(Icons.add_rounded),
						label: value ? const Text("Tracking") : const Text("Track"),
					);
				},
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

	void handleTrackerPress() {}

	void handleFollowTap() {}
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
			curve: Curves.easeInOutCubic,
			duration: Durations.slow,
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
					duration: Durations.slow,
					turns: expanded ? 0.5 : 0,
					curve: Curves.easeInOutCubic,
					child: const Icon(Icons.expand_more_rounded),
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

class ChapterInfoBar extends StatelessWidget {
	const ChapterInfoBar({
		super.key,
		required this.mangaId,
		required this.filterStream,
		required this.chapterStream,
		required this.onFilterApplied,
	});

	final String mangaId;
	final Stream<MangaFilterSettings> filterStream;
	final Stream<CollectionData<ChapterData>> chapterStream;
	final VoidCallback onFilterApplied;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return StreamBuilder<CollectionData<ChapterData>>(
			stream: chapterStream,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.none) {
					return const SizedBox.shrink();
				}

				final chapters = snapshot.data;
				final chapterCount = chapters?.data.length ?? 0;

				return Container(
					height: 40,
					padding: Edges.horizontalMedium,
					child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
						Text("$chapterCount Chapters",
							style: text.titleMedium?.withColorOpacity(chapters != null ? 1 : 0.5)),
						buildFilterButton(context, text, colors, chapters),
					]),
				);
			},
		);
	}

	Widget buildFilterButton(
		BuildContext context,
		TextTheme text,
		ColorScheme colors,
		CollectionData<ChapterData>? chapters,
	) {
		return 	StreamBuilder(
			stream: filterStream,
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.active) {
					return const SizedBox.square(
						dimension: 24,
						child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
					);
				}

				final filterData = snapshot.requireData;
				return IconButton(
					isSelected: !filterData.isDefault,
					icon: const Icon(Icons.filter_list_rounded),
					selectedIcon: Icon(Icons.filter_list_rounded, color: colors.primary),
					visualDensity: VisualDensity.comfortable,
					onPressed: () {
						if (chapters == null) return;
						showFilterSheet(context, chapters.data, filterData);
					},
				);
			},
		);
	}

	void showFilterSheet(
		BuildContext context,
		List<ChapterData> chapters,
		MangaFilterSettings filterSettings,
	) {
		final media = MediaQuery.of(context);
		final groupIds = chapters
			.map((e) => e.groups)
			.expand((e) => e)
			.map((e) => e.id)
			.toSet();
		
		groupIds.addAll(filterSettings.excludedGroupIds);

		showModalBottomSheet(
			context: context,
			isScrollControlled: true,
			builder: (context) => ChapterFilterSheet(
				padding: EdgeInsets.only(bottom: media.padding.bottom),
				data: ChapterFilterSheetData(
					mangaId: mangaId,
					groupIds: groupIds.toList(),
					filterSettings: filterSettings,
				),
				onApply: (newFilter) async {
					await MangaFilterSettings.ref.isar
						.writeTxn(() => MangaFilterSettings.ref.put(newFilter));
					onFilterApplied.call();
				},
			),
		);
	}
}

class ChapterList extends StatelessWidget {
	const ChapterList({
		super.key,
		required this.chapterStream,
		required this.onBottomReached,
	});

	final Stream<CollectionData<ChapterData>> chapterStream;
	final VoidCallback onBottomReached;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return StreamBuilder<CollectionData<ChapterData>>(
			stream: chapterStream,
			builder: (context, snapshot) {
				// Since the loading indicator is in the header, we don't need to handle other states here.
				if (snapshot.connectionState != ConnectionState.active && !snapshot.hasData) {
					return const SliverToBoxAdapter(child: SizedBox.shrink());
				}

				if (snapshot.hasError) {
					final error = handleError(snapshot.error!);

					return SliverToBoxAdapter(
						child: SizedBox(
							height: 150,
							child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
								Text(error.title, style: text.titleLarge?.copyWith(color: colors.error)),
								const SizedBox(height: 8),
								Text(error.description, style: text.bodySmall),
							]),
						),
					);
				}

				final chapters = snapshot.requireData;

				if (chapters.data.isEmpty) {
					return const SliverToBoxAdapter(
						child: SizedBox(
							height: 100,
							child: Center(child: Text("No chapters found")),
						),
					);
				}

				return buildList(text, colors, chapters);
			},
		);
	}

	SliverList buildList(TextTheme text, ColorScheme colors, CollectionData<ChapterData> chapters) {
		return SliverList(delegate: SliverChildBuilderDelegate(
			childCount: chapters.data.length,
			(context, i) {
				final data = chapters.data[i];

				late String title;
				final groups = data.groups.isEmpty 
					? "No group"
					: data.groups.map((e) => e.name).join(", ");

				if (data.chapter.chapter != null && data.chapter.volume != null) {
					title = "Vol. ${data.chapter.volume} Ch. ${data.chapter.chapter} ";
				} else if (data.chapter.chapter != null) {
					title = "Chapter ${data.chapter.chapter}";
				} else {
					title = "Oneshot";
				}

				if (data.chapter.title != null) {
					title += "- ${data.chapter.title!}";
				}

				return ListTile(
					onTap: () {},
					title: Text(title, style: text.bodyMedium),
					leading: SizedBox.square(
						dimension: 40,
						child: Center(
							child: flags.LanguageFlag(
								height: 18,
								language: data.chapter.translatedLanguage.flagLanguage,
							),
						),
					),
					subtitle: Text.rich(TextSpan(
						style: text.bodySmall?.withColorOpacity(0.75),
						children: [
							TextSpan(text: DateFormat.yMMMd().format(data.chapter.createdAt)),
							const TextSpan(text: "  -  "),
							TextSpan(text: data.uploader.username),
							const TextSpan(text: " • "),
							TextSpan(text: groups),
						],
					)),
				);
			},
		));
	}
}