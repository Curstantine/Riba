import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/manga.dart";
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
      label: contentRating.humanReadable,
      labelColor: getBackgroundColor(theme),
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
