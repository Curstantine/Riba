import "package:flutter/material.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/constants.dart";

class UserBar extends StatelessWidget {
  const UserBar({super.key});

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
        IconButton(onPressed: () => {}, icon: const Icon(Icons.more_vert))
      ]),
    );
  }
}
