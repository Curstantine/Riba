import "package:dash_flags/dash_flags.dart" show LanguageFlag;
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:material_symbols_icons/symbols.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/routes/manga/widgets/sheets/filter.dart";
import "package:riba/settings/manga_filter/store.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/theme.dart";

class ChapterList extends StatelessWidget {
	const ChapterList({
		super.key,
		required this.mangaId,
		required this.chapterStream,
		required this.onFilterApplied,
	});

	final String mangaId;
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

				return buildList(text, colors, snapshot.data);
			},
		);
	}

	SliverList buildList(TextTheme text, ColorScheme colors, CollectionData<ChapterData>? chapters) {
		final listLength = (chapters?.data.length ?? 0) + 1 + (
			chapters?.data.isEmpty == true ? 1 : 0
		);
		
		return SliverList(delegate: SliverChildBuilderDelegate(
			childCount: listLength,
			(context, i) {
				final actualIndex = i - 1;
				if (actualIndex >= (listLength - 1)) return null;

				if (actualIndex == -1) {
					return ChapterInfoBar(
						mangaId: mangaId,
						chapters: chapters,
						onFilterApplied: onFilterApplied,
					);
				}

				if (chapters == null) return null;

				if (chapters.data.isEmpty) {
					return Container(
						height: 150,
						padding: Edges.horizontalSmall,
						child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
							Text("No chapters found", style: text.titleMedium),
							Text(
								"Try changing content filters to see more chapters",
								style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
						]),
					);
				}

				final data = chapters.data[actualIndex];

				late String title;
				final groups = data.groups.isEmpty 
					? "No group"
					: data.groups.map((e) => e.name).join(", ");

				if (data.chapter.chapter != null && data.chapter.volume != null) {
					title = "Vol. ${data.chapter.volume} Ch. ${data.chapter.chapter}";
				} else if (data.chapter.chapter != null) {
					title = "Chapter ${data.chapter.chapter}";
				} else {
					title = "Oneshot";
				}

				if (data.chapter.title != null) {
					title += " - ${data.chapter.title!}";
				}

				return ListTile(
					key: ValueKey(data.chapter.id),
					onTap: () {},
					isThreeLine: false,
					title: Text(
						title,
						style: text.bodyMedium,
						maxLines: 1,
						overflow: TextOverflow.ellipsis,
					),
					leading: SizedBox(
						width: 40,
						height: 88,
						child: Center(
							child: LanguageFlag(
								height: 18,
								language: data.chapter.translatedLanguage.getFlag(),
							),
						),
					),
					trailing: SizedBox(
						width: 40,
						height: 88,
						child: Center(
							child: IconButton(
								onPressed: () {},
								isSelected: actualIndex % 2 == 0,
								color: colors.primary,
								icon: const Icon(Symbols.download_rounded),
								selectedIcon: const Icon(Symbols.download_done_rounded),
							),
						),
					),
					subtitle: Text.rich(TextSpan(
						style: text.bodySmall?.withColorOpacity(0.75),
						children: [
							TextSpan(text: DateFormat.yMMMd().format(data.chapter.createdAt)),
							const TextSpan(text: " • "),
							TextSpan(text: groups),
						],
					)),
				);
			},
		));
	}
}

class ChapterInfoBar extends StatelessWidget {
	const ChapterInfoBar({
		super.key,
		required this.mangaId,
		required this.chapters,
		required this.onFilterApplied,
	});

	final String mangaId;
	final CollectionData<ChapterData>? chapters;
	final VoidCallback onFilterApplied;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		final foreground = text.titleMedium?.withColorOpacity(chapters != null ? 1 : 0.5);

		return Container(
			height: 40,
			padding: Edges.horizontalMedium,
			child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
				Text("${chapters?.data.length ?? 0} Chapters", style: foreground),
				buildFilterButton(context, text, colors, chapters?.data),
			]),
		);
	}

	Widget buildFilterButton(
		BuildContext context,
		TextTheme text,
		ColorScheme colors,
		List<ChapterData>? chapters,
	) {
		return StreamBuilder(
			stream: Settings.instance.mangaFilter.watch(mangaId, fireImmediately: true),
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.active || chapters == null) {
					return const SizedBox.square(
						dimension: 24,
						child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
					);
				}

				final filterData = snapshot.requireData;
				return IconButton(
					isSelected: !filterData.isDefault,
					icon: const Icon(Symbols.filter_list_rounded),
					selectedIcon: Icon(Symbols.filter_list_rounded, color: colors.primary),
					visualDensity: VisualDensity.comfortable,
					onPressed: () => showFilterSheet(context, chapters, filterData),
				);
			},
		);
	}

	void showFilterSheet(
		BuildContext context,
		List<ChapterData> chapters,
		MangaFilterSettingsStore filterSettings,
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
					await Settings.instance.mangaFilter.update(newFilter);
					
					if (context.mounted) {
						Navigator.pop(context);
						onFilterApplied.call();
					}
				},
			),
		);
	}
}
