// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:io";

import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/cover_art.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/cache.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/errors.dart";
import "package:riba/utils/lazy.dart";
import "package:riba/widgets/material/card.dart";
import "package:riba/widgets/material/chip.dart";

class CoverSheet extends StatefulWidget {
	const CoverSheet({super.key, required this.mangaData, this.padding = Edges.allNone});

	final MangaData mangaData;
	final EdgeInsets padding;

	@override
	State<CoverSheet> createState() => _CoverSheetState();
}

class _CoverSheetState extends State<CoverSheet> {
	final logger = Logger("MangaCoverSheet");
	Manga get manga => widget.mangaData.manga;

	final coverCacheSettingsStream = CoverCacheSettings.ref
		.where()
		.keyEqualTo(CoverCacheSettings.isarKey)
		.watch()
		.asBroadcastStream().asyncMap((e) => e.first);

	late final selectedCoverId = ValueNotifier<String?>(
		manga.preferredCoverId ?? manga.defaultCoverId,
	);

	late Stream<File?> bigPictureStream;
	late Future<Map<String, CoverArtData>> coverDataFuture;
	late Stream<Map<String, Future<File>>> coverPreviewStream;

  	@override
  	void initState() {
    	super.initState();
    	initialize();
  	}

	void initialize() async {
		await fetchData(init: true);
	}

	Future<void> fetchData({bool init = false, bool checkDB = true}) async {
		if (init) {
			try {
	      		final data = await MangaDex.instance.cover.getManyByMangaId(
	      			checkDB: true,
	      			overrides: MangaDexCoverQueryFilter(mangaId: manga.id),
	      		);
	
	      		if (data.length <= 1) return fetchData(checkDB: false);
	      		if (mounted) {
	      			coverDataFuture = Future.value(
						{ for (final cover in data) cover.cover.id: cover }
					);
	      		}
	    	} catch (e) {
	      		if (mounted) coverDataFuture = Future.error(e);
	  		}
		} else {
			coverDataFuture = MangaDex.instance.cover
				.getManyByMangaId(
					checkDB: checkDB,
					overrides: MangaDexCoverQueryFilter(mangaId: manga.id))
				.then((data) => { for (final cover in data) cover.cover.id: cover });
		}

		coverPreviewStream = coverCacheSettingsStream.asyncMap((settings) async {
			final data = await coverDataFuture;

			return data.map((key, value) =>
				MapEntry(key, MangaDex.instance.cover.getImage(
					manga.id, value.cover,
					size: settings.previewSize,
					cache: settings.enabled,
				))
			);
		});

		setState(() => {});
	}

	void onCoverSelected(String id) {
		selectedCoverId.value = id;

		bigPictureStream = coverCacheSettingsStream.asyncMap((settings) async {
			final data = await coverDataFuture;

			return MangaDex.instance.cover.getImage(
				manga.id, data[id]!.cover,
				size: settings.fullSize,
				cache: settings.enabled,
			);
		});
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return MediaQuery(
			data: MediaQuery.of(context).copyWith(padding: widget.padding),
			child: Scaffold(
				appBar: AppBar(
					title: const Text("Covers"),
					actions: [
						IconButton(
							icon: const Icon(Icons.refresh),
							onPressed: () => fetchData(checkDB: false)),
						ValueListenableBuilder<String?>(
							valueListenable: selectedCoverId,
							builder: (context, selectedId, child) => IconButton(
								icon: const Icon(Icons.check_rounded),
								onPressed: selectedId != manga.defaultCoverId ? setUsedCover : null,
							),
						),
					],
				),
				body: FutureBuilder<Map<String, CoverArtData>>(
					future: coverDataFuture,
					builder: (context, snapshot) {
						Widget? child;

						if (snapshot.connectionState != ConnectionState.done) {
							child = const Center(child: CircularProgressIndicator());
						}

						if ((snapshot.hasError || !snapshot.hasData) &&
							snapshot.connectionState == ConnectionState.done) {
							final error = handleError(snapshot.error ?? "Data was null without errors.");

							child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
								Text(error.title, style: theme.textTheme.titleLarge),
								Text(error.description, style: theme.textTheme.bodyMedium),
								const SizedBox(height: Edges.small),
								OutlinedButton(
									child: const Text("Retry"),
									onPressed: () => setState(() => initialize()),
								),
							]);
						}

						if (snapshot.hasData && snapshot.data!.isEmpty) {
							child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
								const Icon(Icons.image_search_rounded, size: 36),
								const SizedBox(height: Edges.small),
								Text("Couldn't find any covers for this title!",
									style: theme.textTheme.titleMedium),
							]);
						}

						if (child != null) {
							return Center(child: child);
						}

						final covers = snapshot.requireData;
						return buildContent(text, colors, covers);
					},
				),
			),
		);
	}
	
	Widget buildContent(TextTheme text, ColorScheme colors, Map<String, CoverArtData> covers) {
		return ListView(
			padding: Edges.allLarge.add(EdgeInsets.only(bottom: widget.padding.bottom)),
			children: [
				OutlinedCard(
					child: AnimatedSize(
						duration: Durations.normal,
						curve: Curves.easeInOut,
						child: _BigPicture(
							cover: covers[selectedCoverId.value]!.cover,
							imageStream: bigPictureStream,
						),
					),
				),
				const SizedBox(height: Edges.medium),
				Text("Select a cover", style: text.titleMedium),
				const SizedBox(height: Edges.small),
				_CoverPreviewList(
					manga: manga,
					covers: covers,
					imageMapStream: coverPreviewStream,
					selectedCoverId: selectedCoverId,
					onCoverSelected: onCoverSelected),
				Row(children: [
					Icon(Icons.info_outline_rounded, size: 24, color: colors.primary),
					const SizedBox(width: Edges.large),
					Expanded(
						child: Text(
							"Selecting a cover and applying it will update the cover used for this title throughout the app.\n"
							"This update will be only be reflected after either the app or the title is reloaded.",
							softWrap: true,
							style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
						),
					),
				]),
			],
		);
	}

  	void setUsedCover() async {
		final id = selectedCoverId.value;

    	try {
			await MangaDex.instance.database.writeTxn(
				() => MangaDex.instance.database.manga.put(manga..preferredCoverId = id),
			);

			if (mounted) Navigator.pop(context);
    	} catch (e) {
			final message = "Failed to set cover for manga ${manga.id}";
    	  	logger.severe(message, e);
    	  	if (mounted) showLazyBar(context, message);
    	}
	}
}

class _BigPicture extends StatelessWidget {
	const _BigPicture({
		required this.cover,
		required this.imageStream,
	});

	final CoverArt cover;
	final Stream<File?> imageStream;
  
	@override
	Widget build(BuildContext context) {
		return Stack(
			alignment: Alignment.bottomRight,
			children: [
				Padding(
					padding: Edges.horizontalSmall.copyWithSelf(Edges.verticalMedium),
					child: Wrap(
						spacing: Edges.extraSmall,
						children: [
							if (cover.volume != null)
								TinyChip(label: "Vol ${cover.volume}", onPressed: () => {}),
							if (cover.locale != null)
								TinyChip(label: cover.locale!.language.human, onPressed: () => {}),
						],
					),
				),
			],
	    );
	}

	Widget buildImage(TextTheme text, ColorScheme colors) {
		return StreamBuilder<File?>(
			stream: imageStream,
			builder: (context, snapshot) {
				List<Widget>? children;

				if (snapshot.connectionState != ConnectionState.done) {
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
						Icon(Icons.image_not_supported_rounded, size: 48, color: colors.onSurfaceVariant),
						const SizedBox(height: Edges.small),
						Text("No cover available!", style: text.bodyMedium),
					];
				}

				if (children != null) {
					return SizedBox(
						height: 300,
						width: double.infinity,
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: children),
					);
				}

				return InkWell(
					onTap: () => showDialog(
						context: context,
						useSafeArea: false,
						builder: (context) => buildZoomablePreview(context, snapshot.data!),
					),
					child: Image.file(
						snapshot.data!,
						fit: BoxFit.fitWidth,
						width: double.infinity,
					),
				);
			},
        );
	}

	Widget buildZoomablePreview(BuildContext context, File image) {
		return Stack(
			children: [
				InteractiveViewer(
					maxScale: 2,
					child: GestureDetector(
						behavior: HitTestBehavior.translucent,
						onTap: () => Navigator.pop(context),
						child: Container(
							alignment: Alignment.center,
							margin: Edges.horizontalMedium,
							child: Image.file(
								image,
								fit: BoxFit.fitWidth,
								filterQuality: FilterQuality.high,
							),
						),
					),
				),
				Positioned(
					bottom: 0,
					right: 0,
					child: Container(
						height: 64,
						padding: Edges.bottomExtraLarge.copyWith(right: Edges.medium),
						child: Row(children: [
							ElevatedButton.icon(
								onPressed: saveCoverImage,
								icon: const Icon(Icons.save),
								label: const Text("Save"))
						]),
					),
				)
			],
		);
	}

	/// TODO: implement a platform agnostic way to save the image
	/// to a shared path outside of the app.
	void saveCoverImage() {}
}

class _CoverPreview extends StatelessWidget {
	const _CoverPreview({
		required this.selected,
		required this.preferred,
		required this.cover,
		required this.imageFuture,
		required this.onTap,
	});

	final bool selected;
	final bool preferred;
	final CoverArt cover;
	final Future<File> imageFuture;
	final Function(String coverId) onTap;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return SizedBox(
			width: 100,
			height: 200,
			child: FutureBuilder<File?>(
				future: imageFuture,
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) {
						return const Center(child: CircularProgressIndicator());
					}
			
					if (snapshot.hasError) {
						final error = handleError(snapshot.error!);
						return Center(
							child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
								Icon(Icons.image_not_supported_rounded, size: 32, color: colors.error),
								const SizedBox(height: Edges.small),
								Text(error.title, style: text.bodySmall, textAlign: TextAlign.center)
							]),
						);
					}
			
					return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
						buildImage(text, colors),
						if (cover.volume != null) ...[
							const SizedBox(height: Edges.extraSmall),
							Text("Vol ${cover.volume}", style: text.labelSmall),
						]
					]);
				},
			),
		);
	}

	Widget buildImage(TextTheme text, ColorScheme colors) {
		return FutureBuilder(
			future: imageFuture,
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.done) {
					return const Center(child: CircularProgressIndicator());
				}

				if (snapshot.hasError) {
					final error = handleError(snapshot.error!);
					return Center(
						child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
							Icon(Icons.image_not_supported_rounded, size: 32, color: colors.error),
							const SizedBox(height: Edges.small),
							Text(error.title, style: text.bodySmall, textAlign: TextAlign.center)
						]),
					);
				}
			
				return Card(
					margin: Edges.allNone,
					clipBehavior: Clip.antiAlias,
					elevation: selected ? 4 : 0,
					shape: RoundedRectangleBorder(
						borderRadius: Corners.allMedium,
						side: !preferred
							? BorderSide.none
							: BorderSide(width: 2, color: colors.primary),
					),
					child: InkWell(
						onTap: () => onTap.call(cover.id),
						child: Image.file(
							snapshot.data!,
							fit: BoxFit.fitWidth,
							width: double.infinity,
							filterQuality: FilterQuality.high,
						),
					),
				);
			},
		);
	}
}

class _CoverPreviewList extends StatelessWidget {
	const _CoverPreviewList({
		required this.manga,
		required this.covers,
		required this.imageMapStream,
		required this.selectedCoverId,
		required this.onCoverSelected,
	});

	final Manga manga;
	final Map<String, CoverArtData> covers;
	final Stream<Map<String, Future<File>>> imageMapStream;
	final ValueNotifier<String?> selectedCoverId;
	final Function(String coverId) onCoverSelected;

  	@override
  	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		if (covers.length <= 1) {
			return SizedBox(
				height: 200,
				child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
					Icon(Icons.image_search_rounded, size: 32, color: colors.onSurfaceVariant),
					const SizedBox(height: Edges.small),
					Text("No other covers found!",
						style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
				]),
            );
		}

		return SizedBox(
			height: 200,
			child: StreamBuilder<Map<String, Future<File>>>(
				stream: imageMapStream,
				builder: (context, snapshot) {
					final files = snapshot.requireData;

					return ListView.separated(
						scrollDirection: Axis.horizontal,
						itemCount: covers.length,
						separatorBuilder: (context, _) => const SizedBox(width: Edges.medium),
						itemBuilder: (context, i) {
						  final coverData = covers.values.elementAt(i);

							return buildList(
								coverData.cover,
								files[coverData.cover.id]!,
							);
						},
					);
				}
			),
		);
	}

  	Widget buildList(CoverArt cover, Future<File> coverImageFuture) {
		return _CoverPreview(
			selected: selectedCoverId.value == cover.id,
			preferred: manga.preferredCoverId == cover.id,
			cover: cover,
			imageFuture: coverImageFuture,
			onTap: onCoverSelected,
		);
  	}
}
