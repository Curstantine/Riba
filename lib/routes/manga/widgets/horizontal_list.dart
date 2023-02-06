import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";
import "package:riba/routes/manga/widgets/card.dart";

class MangaHorizontalList extends StatelessWidget {
  const MangaHorizontalList({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: Edges.leftMedium, child: Text(title, style: theme.textTheme.titleMedium)),
        SizedBox(
          height: 275,
          child: ListView.separated(
              itemCount: 10,
              shrinkWrap: true,
              padding: Edges.horizontalMedium,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: Edges.small),
              itemBuilder: (_, __) => const MangaCard()),
        )
      ],
    );
  }
}
