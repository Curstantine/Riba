import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/widgets/material/chip.dart";

class PublicationStatusChip extends StatelessWidget {
	const PublicationStatusChip({
		super.key,
		required this.status,
		this.surfaceColor,
		this.elevation = 1,
	});

	final double elevation;
	final MangaPublicationStatus status;
	final Color? surfaceColor;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final background = getBackgroundColor(theme.brightness);

		return TinyChip(
			elevation: elevation,
			labelColor: background,
			surfaceColor: surfaceColor,
			surfaceTintColor: background,
			label: status.asHumanReadable(),
			onPressed: () => {},
		);
	}

	Color getBackgroundColor(Brightness brightness) {
		switch (status) {
			case MangaPublicationStatus.ongoing:
				return brightness == Brightness.light ? Colors.green.shade900 : Colors.green.shade300;
			case MangaPublicationStatus.completed:
				return brightness == Brightness.light ? Colors.blue.shade900 : Colors.blue.shade300;
			case MangaPublicationStatus.hiatus:
				return brightness == Brightness.light ? Colors.orange.shade900 : Colors.orange.shade300;
			case MangaPublicationStatus.cancelled:
				return brightness == Brightness.light ? Colors.red.shade900 : Colors.red.shade300;
		}
	}
}

class ContentRatingChip extends StatelessWidget {
	const ContentRatingChip({
		super.key,
		required this.contentRating,
		this.surfaceColor,
		this.elevation = 1,
	});

	final double elevation;
	final ContentRating contentRating;
	final Color? surfaceColor;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final background = getBackgroundColor(theme.brightness, colors);

		return TinyChip(
			elevation: elevation,
			labelColor: background,
			surfaceColor: surfaceColor,
			surfaceTintColor: background,
			label: contentRating.asHumanReadable(),
			onPressed: () => {},
		);
	}

	Color getBackgroundColor(Brightness brightness, ColorScheme colors) {
		switch (contentRating) {
			case ContentRating.safe:
				return colors.primary;
			case ContentRating.suggestive:
				return brightness == Brightness.light ? Colors.orange.shade900 : Colors.orange.shade300;
			case ContentRating.erotica:
			case ContentRating.pornographic:
				return brightness == Brightness.light ? Colors.purple.shade700 : Colors.purple.shade300;
		}
	}
}

class DemographicChip extends StatelessWidget {
	const DemographicChip({
		super.key,
		required this.demographic,
		this.surfaceColor,
		this.elevation = 1,
	});

	final double elevation;
	final MangaPublicationDemographic demographic;
	final Color? surfaceColor;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		final background = getBackgroundColor(theme.brightness, colors);

		return TinyChip(
			elevation: elevation,
			labelColor: background,
			surfaceColor: surfaceColor,
			surfaceTintColor: background,
			label: demographic.asHumanReadable(),
			onPressed: () => {},
		);
	}

	Color getBackgroundColor(Brightness brightness, ColorScheme colors) {
		switch (demographic) {
			case MangaPublicationDemographic.shounen:
			case MangaPublicationDemographic.seinen:
				return brightness == Brightness.light ? Colors.blue.shade900 : Colors.blue.shade300;
			case MangaPublicationDemographic.shoujo:
			case MangaPublicationDemographic.josei:
				return brightness == Brightness.light ? Colors.pink.shade900 : Colors.pink.shade300;
			case MangaPublicationDemographic.unknown:
				return colors.error;
		}
	}
}

class TagChip extends StatelessWidget {
	const TagChip({
		super.key,
		required this.tag,
		required this.preferredLocales,
		this.surfaceColor,
	});
	
	final Tag tag;
	final List<Locale> preferredLocales;
	final Color? surfaceColor;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return TinyChip(
			elevation: 0,
			outlineColor: theme.colorScheme.outline,
			labelColor: theme.colorScheme.onSurfaceVariant,
			surfaceColor: surfaceColor,
			label: tag.name.getPreferred(preferredLocales) ?? "N/A",
			onPressed: () => {},
		);
	}
}
