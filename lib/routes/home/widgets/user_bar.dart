import "package:flutter/material.dart" hide Router;
import "package:riba/material_symbols.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/router.dart";

class HomeUserBar extends StatelessWidget {
  const HomeUserBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 64,
      padding: Edges.horizontalSmall,
      child: Row(children: [
        IconButton(onPressed: () => {}, icon: const Icon(Icons.person)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Curstantine",
                style: theme.textTheme.titleMedium?.withColorAlpha(0.75).copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.Rubik,
                    height: 0)),
            Text("User",
                style: theme.textTheme.bodySmall
                    ?.withColorAlpha(0.5)
                    .copyWith(letterSpacing: 0, fontFamily: FontFamily.Rubik, height: 0))
          ],
        ),
        const Spacer(),
        PopupMenuButton(
          icon: const Icon(MaterialSymbols.more_vert),
          onSelected: (value) => Router.push(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: Router.settings, child: Text("Settings")),
          ],
        ),
      ]),
    );
  }
}
