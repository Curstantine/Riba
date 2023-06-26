import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/widgets/material/chip.dart";

class ContentRatingChip extends StatelessWidget {
	const ContentRatingChip({super.key, required this.contentRating});

	final ContentRating contentRating;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final background = getBackgroundColor(colors);

		return TinyChip(
			elevation: 1,
			surfaceTintColor: background,
			labelColor: background,
			label: contentRating.asHumanReadable(),
			onPressed: () => {},
		);
	}

	Color getBackgroundColor(ColorScheme colors) {
		switch (contentRating) {
			case ContentRating.safe:
				return colors.primary;
			case ContentRating.suggestive:
				return Colors.orange.harmonizeWith(colors.primary);
			case ContentRating.erotica:
			case ContentRating.pornographic:
				return Colors.purple.harmonizeWith(colors.primary);
		}
	}
}

class DemographicChip extends StatelessWidget {
	const DemographicChip({super.key, required this.demographic});

	final MangaPublicationDemographic demographic;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final background = getBackgroundColor(colors);

		return TinyChip(
			elevation: 1,
			surfaceTintColor: background,
			labelColor: background,
			label: demographic.asHumanReadable(),
			onPressed: () => {},
		);
	}

	Color getBackgroundColor(ColorScheme colors) {
		switch (demographic) {
			case MangaPublicationDemographic.shounen:
			case MangaPublicationDemographic.seinen:
				return Colors.lightBlue.harmonizeWith(colors.primary);
			case MangaPublicationDemographic.shoujo:
			case MangaPublicationDemographic.josei:
				return Colors.pink.harmonizeWith(colors.primary);
			case MangaPublicationDemographic.unknown:
				return colors.error;
		}
	}
}

class TagChip extends StatelessWidget {
	const TagChip({super.key, required this.tag, required this.preferredLocales});
	
	final Tag tag;
	final List<Locale> preferredLocales;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return TinyChip(
			elevation: 0,
			outlineColor: theme.colorScheme.outline,
			labelColor: theme.colorScheme.onSurfaceVariant,
			label: tag.name.getPreferred(preferredLocales),
			onPressed: () => {},
		);
	}
}
