import 'package:flutter/material.dart';
import 'package:riba/utils/theme.dart' show TextColor;
import 'package:riba/utils/constants.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [userBar(theme), seasonal(theme, media)],
        ),
      ),
    );
  }

  Widget userBar(ThemeData theme) {
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

  Widget seasonal(ThemeData theme, MediaQueryData media) {
    return Padding(
      padding: Edges.leftSmall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Edges.leftSmall,
            child: Text("Seasonal", style: theme.textTheme.titleMedium),
          ),
          LayoutBuilder(builder: (p0, p1) {
            return SizedBox(
              height: 250,
              child: ListView.separated(
                itemCount: 10,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: Edges.small),
                padding: Edges.horizontalSmall,
                itemBuilder: (context, index) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150, maxHeight: 220),
                    child: Column(children: [
                      Card(
                        clipBehavior: Clip.hardEdge,
                        margin: Edges.verticalExtraSmall,
                        child: InkWell(
                          splashColor: theme.colorScheme.secondary.withOpacity(0.2),
                          hoverColor: theme.colorScheme.secondary.withOpacity(0.3),
                          focusColor: theme.colorScheme.secondary.withOpacity(0.3),
                          onTap: () => {},
                          child: const SizedBox(height: 200, width: 150),
                        ),
                      ),
                      Text(
                          "In another world where I got isekaid with a cute elf boy who crossdresses to my liking $index",
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall
                              ?.withColorAlpha(0.85)
                              .copyWith(fontFamily: FontFamily.Rubik, fontWeight: FontWeight.w400)),
                    ]),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
