import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:riba/routes/manga/views/view.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/material/card.dart";

class MangaCard extends StatelessWidget {
  const MangaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OpenContainer(
      tappable: true,
      transitionDuration: Durations.normal,
      closedColor: Colors.transparent,
      openBuilder: (context, action) => const MangaView(),
      closedBuilder: (context, action) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150, maxHeight: 220),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            OutlinedCard(
                clipBehavior: Clip.hardEdge,
                margin: Edges.verticalExtraSmall,
                child: InkWell(
                    onTap: action,
                    splashColor: theme.colorScheme.secondary.withOpacity(0.2),
                    hoverColor: theme.colorScheme.secondary.withOpacity(0.3),
                    focusColor: theme.colorScheme.secondary.withOpacity(0.3),
                    child: const SizedBox(height: 200, width: 150))),
            Text("A Title That's Long Enough to Make Kizuna Happy",
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.withColorAlpha(0.85)),
          ]),
        );
      },
    );
  }
}
