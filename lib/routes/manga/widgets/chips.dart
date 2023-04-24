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

		return TinyChip(
			elevation: 1,
			surfaceTintColor: getBackgroundColor(theme),
			labelColor: getBackgroundColor(theme),
			label: contentRating.asHumanReadable(),
			onPressed: () => {},
		);
	}

	Color getBackgroundColor(ThemeData theme) {
		switch (contentRating) {
			case ContentRating.safe:
				return theme.colorScheme.primary;
			case ContentRating.suggestive:
				return Colors.orange;
			case ContentRating.erotica:
			case ContentRating.pornographic:
				return Colors.red;
		}
	}
}

class DemographicChip extends StatelessWidget {
	const DemographicChip({super.key, required this.demographic});

	final MangaPublicationDemographic demographic;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return TinyChip(
			elevation: 1,
			surfaceTintColor: getBackgroundColor(theme),
			labelColor: getBackgroundColor(theme),
			label: demographic.asHumanReadable(),
			onPressed: () => {},
		);
	}

	Color getBackgroundColor(ThemeData theme) {
		switch (demographic) {
			case MangaPublicationDemographic.shounen:
			case MangaPublicationDemographic.seinen:
				return Colors.lightBlue;
			case MangaPublicationDemographic.shoujo:
			case MangaPublicationDemographic.josei:
				return Colors.pink;
			case MangaPublicationDemographic.unknown:
				return theme.colorScheme.error;
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
