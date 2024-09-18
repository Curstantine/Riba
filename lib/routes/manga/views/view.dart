import "dart:async";
import "dart:io";

import "package:dash_flags/dash_flags.dart";
import "package:flutter/material.dart" hide Locale, Localizations;
import "package:flutter/services.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/statistics.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/routes/manga/views/model.dart";
import "package:riba/routes/manga/widgets/buttons.dart";
import "package:riba/routes/manga/widgets/chips.dart";
import "package:riba/routes/manga/widgets/lists/chapter.dart";
import "package:riba/routes/manga/widgets/sheets/cover.dart";
import "package:riba/routes/manga/widgets/sheets/rating.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/lazy.dart";
import "package:riba/utils/theme.dart";

class MangaView extends StatefulWidget {
	const MangaView({super.key, required this.viewModel, this.initialData});

	final MangaViewModel viewModel;
	final MangaData? initialData;

	@override
	State<MangaView> createState() => _MangaViewState();
}

class _MangaViewState extends State<MangaView> {
	MangaViewModel get viewModel => widget.viewModel;
	List<Locale> get preferredDisplayLocales => Settings.instance.appearance.preferredDisplayLocales.value;

	final isDescriptionExpanded = ValueNotifier(false);
	final areFiltersApplied = ValueNotifier(false);

	@override
	void initState() {
		viewModel.initialize();
		super.initState();
	}

	@override
	void dispose() {
		viewModel.dispose();
		isDescriptionExpanded.dispose();
		areFiltersApplied.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		final media = MediaQuery.of(context);

		return Scaffold(
			body: StreamBuilder<MangaData>(
				stream: viewModel.dataStream,
				initialData: widget.initialData,
				builder: (context, mangaSnapshot) {
					if (!mangaSnapshot.hasData && !mangaSnapshot.hasError) {
						return const Center(child: CircularProgressIndicator());
					}

					if (mangaSnapshot.hasError || !mangaSnapshot.hasData) {
						final error = ErrorState.fromSource(mangaSnapshot.error ?? "Data was null without errors.");

						return Center(
							child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
								Text(error.title, style: theme.textTheme.titleLarge),
								Text(error.description, style: theme.textTheme.bodyMedium),
								const SizedBox(height: Edges.large),
								ElevatedButton(
									onPressed: () => setState(() => viewModel.refresh()),
									child: const Text("Retry"),
								),
							]),
						);
					}

					final mangaData = mangaSnapshot.requireData;

					return RefreshIndicator(
						onRefresh: viewModel.refresh,
						child: CustomScrollView(controller: viewModel.scrollController, slivers: [
							buildAppBar(text, colors, media, preferredDisplayLocales, mangaData),
							SliverToBoxAdapter(child: DescriptionSection(
								description: mangaData.manga.description,
								isExpanded: isDescriptionExpanded,
								preferredLocales: preferredDisplayLocales,
							)),
							SliverToBoxAdapter(child: buildReadButton()),
							ChapterList(
								mangaId: viewModel.mangaId,
								chapterStream: viewModel.chapterStream,
								onFilterApplied: viewModel.onFiltersApplied,
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
			expandedHeight: viewModel.expandedAppBarHeight,
			title: ValueListenableBuilder(
				valueListenable: viewModel.showAppBar,
				child: Text(
					mangaData.manga.titles.getPreferred(preferredDisplayLocales) ?? "N/A",
					style: text.titleMedium,
				),
				builder: (context, value, child) => AnimatedOpacity(
					opacity: value ? 1 : 0,
					duration: LocalDurations.standard,
					child: child,
				),
			),
			flexibleSpace: FlexibleSpaceBar(
				collapseMode: CollapseMode.pin,
				titlePadding: Edges.allNone,
				background: DetailsHeader(
					height: viewModel.expandedAppBarHeight + media.padding.top,
					isFollowed: viewModel.isFollowed,
					hasTrackers: viewModel.hasTrackers,
					hasCustomLists: viewModel.hasCustomLists,
					preferredLocales: preferredDisplayLocales,
					mangaData: mangaData,
					coverStream: viewModel.coverStream,
					statisticsStream: viewModel.statisticStream,
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
}

class DetailsHeader extends StatelessWidget {
  	const DetailsHeader({
		super.key,
		required this.height,
		required this.mangaData,
		required this.statisticsStream,
		required this.coverStream,
		required this.preferredLocales,
		required this.isFollowed,
		required this.hasTrackers,
		required this.hasCustomLists,
	}) : assert(height > 100);
  
	final double height;
	final MangaData mangaData;
	final Stream<Statistics> statisticsStream;

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
						colors.surface.withOpacity(0),
						colors.surface.withOpacity(0.85),
						colors.surface.withOpacity(0.95),
						colors.surface,
					],
				),
			),
			child: StreamBuilder<File?>(
				stream: coverStream,
				builder: (context, snapshot) {
					List<Widget>? children;

					if (!snapshot.hasData && !snapshot.hasError) {
						children = [const CircularProgressIndicator()];
					}

					if (snapshot.hasError) {
						final error = ErrorState.fromSource(snapshot.error!);
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
					LanguageFlag(
						language: mangaData.manga.originalLanguage.getFlag(),
						height: 20,
					),
					const SizedBox(height: Edges.small),
					GestureDetector(
						onLongPress: () => handleTitleLongPress(context, title),
						child: Text(title ?? "N/A", style: text.titleLarge),
					),
					Text(authorList, style: text.labelMedium?.copyWith(color: colors.onSurfaceVariant)),
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
			child: StreamBuilder<Statistics>(
				stream: statisticsStream,
				builder: (context, snapshot) {
					if (snapshot.hasError) {
						final error = ErrorState.fromSource(snapshot.error!);
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
							label: bayesian.toStringAsFixed(2),
							leadingIcon: Symbols.star_rate_rounded,
							onTap: () => rating == null
								? null
								: showRatingStatisticSheet(context, rating),
						),
						const SizedBox(width: Edges.small),
						TinyButton(
							enabled: snapshot.data?.follows != null,
							label: follows.toString(),
							leadingIcon: Symbols.bookmark_rounded,
						),
						const SizedBox(width: Edges.small),
						TinyButton(
							enabled: snapshot.data?.comments != null,
							label: comments.toString(),
							leadingIcon: Symbols.comment_rounded,
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
					duration: LocalDurations.standard,
					curve: LocalEasing.standard,
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
					duration: LocalDurations.standard,
					curve: LocalEasing.standard,
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

	void handleTitleLongPress(BuildContext context, String? title) {
		if (title == null) return;
		Clipboard.setData(ClipboardData(text: title));
		showLazyBar(context, "Title copied to clipboard.");
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

		if (span.text == null || span.text!.isEmpty) {
			return const SizedBox();
		}

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
			curve: LocalEasing.emphasized,
			duration: LocalDurations.emphasized,
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
							colors.surface.withOpacity(0),
							colors.surface.withOpacity(0.75),
							colors.surface.withOpacity(0.95),
							colors.surface,
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
					duration: LocalDurations.emphasized,
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
