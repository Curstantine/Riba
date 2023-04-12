import "package:flutter/material.dart" hide Locale;
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/tag.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/widgets/material/chip.dart";

class ContentRatingChip extends StatelessWidget {
  final MangaContentRating contentRating;

  const ContentRatingChip({super.key, required this.contentRating});

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
      case MangaContentRating.safe:
        return theme.colorScheme.primary;
      case MangaContentRating.suggestive:
        return Colors.orange;
      case MangaContentRating.erotica:
      case MangaContentRating.pornographic:
        return Colors.red;
    }
  }
}

class DemographicChip extends StatelessWidget {
  final MangaPublicationDemographic demographic;

  const DemographicChip({super.key, required this.demographic});

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
  final Tag tag;
  final List<Locale> preferredLocales;

  const TagChip({super.key, required this.tag, required this.preferredLocales});

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
