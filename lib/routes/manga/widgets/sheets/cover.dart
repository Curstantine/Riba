import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/manga.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/repositories/mangadex/services/cover_art.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/runtime/manga.dart";
import "package:riba/settings/persistence.dart";
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

	final coverCacheSettings = CoverPersistenceSettings.ref.getByKey(CoverPersistenceSettings.isarKey);
	late final selectedCoverId = ValueNotifier<String?>(
		manga.preferredCoverId ?? manga.defaultCoverId,
	);

	final bigPictureController = StreamController<File?>();
	final coverDataController = StreamController<Map<String, CoverArtData>>();
	final coverPreviewsController = StreamController<Map<String, Future<File>>>();

  	@override
  	void initState() {
    	super.initState();
    	initialize();
  	}

	void initialize() async {
		await fetchData(init: true);

		final probableCoverId = manga.preferredCoverId ?? manga.defaultCoverId;
		// if (probableCoverId != null) onCoverSelected(probableCoverId);

		// When there aren't any covers, we need to sink a null to the stream and close
		// its connection, so [_BigPicture] could comprehend the state.
		if (probableCoverId == null && (await coverDataController.stream.single).isEmpty) {
			bigPictureController.add(null);
			bigPictureController.close();			
		}
	}

	Future<void> fetchData({bool init = false, bool checkDB = true}) async {
		final settings = await coverCacheSettings;
		List<CoverArtData>? coverData;

		try {
			if (init) {
				coverData = await MangaDex.instance.cover.getManyByMangaId(
					checkDB: true,
					overrides: MangaDexCoverQueryFilter(mangaId: manga.id),
				);
		
				if (coverData.length <= 1) return fetchData(checkDB: false);
			} else {
				coverData = await MangaDex.instance.cover.getManyByMangaId(
					checkDB: checkDB,
					overrides: MangaDexCoverQueryFilter(mangaId: manga.id)
				);
			}
		} catch (e) {
			coverDataController.addError(e);
		}

		if (coverData == null) return;

		coverDataController.add({ for (final cover in coverData) cover.cover.id: cover });
		coverPreviewsController.add({
			for (final cover in coverData)
				cover.cover.id: MangaDex.instance.cover.getImage(
					manga.id, cover.cover,
					size: settings!.previewSize,
					cache: settings.enabled,
				)
		});

		final probableCoverId = manga.preferredCoverId ?? manga.defaultCoverId;
		if (probableCoverId != null) {
			final data = coverData.firstWhere((e) => e.cover.id == probableCoverId);
			onCoverSelected(data.cover, force: true);
		}
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
								onPressed: selectedId != (manga.preferredCoverId ?? manga.defaultCoverId) 
									? setUsedCover
									: null,
							),
						),
					],
				),
				body: StreamBuilder<Map<String, CoverArtData>>(
					stream: coverDataController.stream,
					builder: (context, snapshot) {
						Widget? child;

						if (snapshot.connectionState != ConnectionState.active) {
							child = const Center(child: CircularProgressIndicator());
						}

						if ((snapshot.hasError || !snapshot.hasData) &&
							snapshot.connectionState == ConnectionState.active) {
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
				_BigPicture(
					covers: covers,
					selectedCoverId: selectedCoverId,
					imageStream: bigPictureController.stream,
				),
				const SizedBox(height: Edges.medium),
				Text("Select a cover", style: text.titleMedium),
				const SizedBox(height: Edges.medium),
				_CoverPreviewList(
					manga: manga,
					covers: covers,
					imageMapStream: coverPreviewsController.stream,
					selectedCoverId: selectedCoverId,
					onCoverSelected: onCoverSelected),
				Padding(
					padding: Edges.bottomMedium,
					child: Row(children: [
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
				),
			],
		);
	}

	void onCoverSelected(CoverArt data, {bool force = false}) async {
		if (data.id == selectedCoverId.value && !force) return;

		selectedCoverId.value = data.id;
		bigPictureController.add(null);
		
		final settings = await coverCacheSettings;
		final image = await MangaDex.instance.cover.getImage(
			widget.mangaData.manga.id,
			data,
			size: settings!.fullSize,
			cache: settings.enabled,
		);

		bigPictureController.add(image);
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
		required this.covers,
		required this.selectedCoverId,
		required this.imageStream,
	});

	final Map<String, CoverArtData> covers;
	final ValueNotifier<String?> selectedCoverId;

	/// Stream of the big picture.
	/// 
	/// This stream should return null with an active connection if the image is loading.
	/// 
	/// To represent empty state, the stream should return null with a closed connection.
	final Stream<File?> imageStream;
  
	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;
		
		return OutlinedCard(
			child: AnimatedSize(
				duration: Durations.normal,
				curve: Curves.easeInOut,
				child: Stack(alignment: Alignment.bottomRight, children: [
					buildImage(text, colors),
					buildInfoTags(text, colors),
				]),
			),
	    );
	}

	Widget buildImage(TextTheme text, ColorScheme colors) {
		return StreamBuilder<File?>(
			stream: imageStream,
			builder: (context, snapshot) {
				List<Widget>? children;

				if (snapshot.connectionState != ConnectionState.active ||
					!snapshot.hasData && !snapshot.hasError &&
					snapshot.connectionState == ConnectionState.active) {
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

	Widget buildInfoTags(TextTheme text, ColorScheme colors) {
		return ValueListenableBuilder(
			valueListenable: selectedCoverId,
			builder: (context, value, _) {
				final cover = covers[value]?.cover;

				return Padding(
					padding: Edges.horizontalSmall.copyWithSelf(Edges.verticalMedium),
					child: Wrap(
						spacing: Edges.extraSmall,
						children: [
							if (cover?.volume != null)
								TinyChip(label: "Vol ${cover!.volume}", onPressed: () => {}),
							if (cover?.locale != null)
								TinyChip(label: cover!.locale!.language.human, onPressed: () => {}),
						],
					),
				);
			}
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
								onPressed: () => saveCoverImage(context),
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
	void saveCoverImage(BuildContext context) {
		showLazyBar(context, "Not implemented yet.");
	}
}

class _CoverPreview extends StatelessWidget {
	const _CoverPreview({
		required this.preferred,
		required this.cover,
		required this.selectedCoverId,
		required this.imageFuture,
		required this.onTap,
	});

	final bool preferred;
	final CoverArt cover;
	final ValueNotifier<String?> selectedCoverId;
	final Future<File> imageFuture;
	final Function(CoverArt cover) onTap;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return SizedBox(
			width: 125,
			height: 250,
			child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
				buildImage(text, colors),
				if (cover.volume != null) ...[
					const SizedBox(height: Edges.small),
					Text("Vol ${cover.volume}", style: text.labelMedium),
				]
			]),
		);
	}

	Widget buildImage(TextTheme text, ColorScheme colors) {
		return AnimatedSize(
			duration: Durations.slow,
			curve: Curves.easeInOutCirc,
			alignment: Alignment.bottomCenter,
			child: FutureBuilder(future: imageFuture, builder: (context, snapshot) {
				late Widget child;

				if (snapshot.connectionState != ConnectionState.done) {
					child = const CircularProgressIndicator();
				}

				if (snapshot.hasError) {
					final error = handleError(snapshot.error!);
					child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
						Icon(Icons.image_not_supported_rounded, size: 32, color: colors.error),
						const SizedBox(height: Edges.small),
						Text(error.title, style: text.bodySmall, textAlign: TextAlign.center)
					]);
				}

				if (snapshot.hasData) {
					child = InkWell(
						onTap: () => onTap.call(cover),
						child: Image.file(
							snapshot.requireData,
							fit: BoxFit.fitWidth,
							width: double.infinity,
							filterQuality: FilterQuality.high,
						),
					);
				} else {
					child = Center(child: child);
				}

				return ConstrainedBox(
					constraints: const BoxConstraints(
						maxHeight: 200,
						maxWidth: 150,
						minHeight: 50,
						minWidth: 50,
					),
					child: ValueListenableBuilder(
						valueListenable: selectedCoverId,
						builder: (context, value, _) {
							BorderSide border = BorderSide.none;

							if (value == cover.id) {
								border = BorderSide(width: 2, color: colors.primary);
							} else if (preferred) {
								border = BorderSide(width: 2, color: colors.onSurface.withOpacity(0.5));
							}

							return Card(
								margin: Edges.allNone,
								clipBehavior: Clip.antiAlias,
								shape: RoundedRectangleBorder(
									borderRadius: Corners.allMedium,
									side: border,
								),
								child: child,
							);
						},
					),
				);
			}),
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
	final Stream<Map<String, Future<File>>>? imageMapStream;
	final ValueNotifier<String?> selectedCoverId;
	final Function(CoverArt data) onCoverSelected;

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
			height: 250,
			child: StreamBuilder<Map<String, Future<File>>>(
				stream: imageMapStream,
				builder: (context, snapshot) {
					Widget? child;

					if (snapshot.connectionState != ConnectionState.active) {
						child = const CircularProgressIndicator();
					}

					if (snapshot.hasError) {
						final error = handleError(snapshot.error!);

						child = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
							Icon(Icons.image_not_supported_rounded, size: 32, color: colors.error),
							const SizedBox(height: Edges.small),
							Text(error.title, style: text.bodySmall, textAlign: TextAlign.center)
						]);
					}

					if (child != null) {
						return SizedBox(height: 250, child: Center(child: child));
					}

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
			preferred: manga.preferredCoverId == cover.id,
			cover: cover,
			selectedCoverId: selectedCoverId,
			imageFuture: coverImageFuture,
			onTap: onCoverSelected,
		);
  	}
}
