import 'package:flutter/material.dart';
import 'package:riba/utils/theme.dart';
import 'package:riba/utils/constants.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150, maxHeight: 220),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(
          clipBehavior: Clip.hardEdge,
          margin: Edges.verticalExtraSmall,
          child: InkWell(
              splashColor: theme.colorScheme.secondary.withOpacity(0.2),
              hoverColor: theme.colorScheme.secondary.withOpacity(0.3),
              focusColor: theme.colorScheme.secondary.withOpacity(0.3),
              onTap: () => {},
              child: const SizedBox(height: 200, width: 150)),
        ),
        Text(
            "In another world where I got isekaid with a cute elf boy who crossdresses to my liking",
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.withColorAlpha(0.85)),
      ]),
    );
  }
}
