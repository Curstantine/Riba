import "package:flutter/material.dart" hide Router;
import "package:riba/repositories/mangadex/models/user.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/router.dart";
import "package:riba/utils/theme.dart";

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
            Text("Guest", style: theme.textTheme.titleMedium?.copyWith(height: 0)),
            Text(UserRole.member.asHumanReadable(),
                style: theme.textTheme.bodySmall
                    ?.withColorOpacity(0.5)
                    .copyWith(letterSpacing: 0, height: 0))
          ],
        ),
        const Spacer(),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) => Router.push(context, value),
          offset: const Offset(-10, 56),
          itemBuilder: (context) => [
            const PopupMenuItem(value: Router.settings, child: Text("Settings")),
          ],
        ),
      ]),
    );
  }
}
