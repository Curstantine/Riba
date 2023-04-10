import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:riba/repositories/local/cover_art.dart";
import "package:riba/repositories/mangadex.dart";
import "package:riba/settings/cache.dart";
import "package:riba/settings/settings.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/external.dart";
import "package:riba/utils/lazy.dart";
import "package:riba/utils/theme.dart";

class SettingsCachingView extends StatefulWidget {
  const SettingsCachingView({super.key});

  @override
  State<SettingsCachingView> createState() => _SettingsCachingViewState();
}

class _SettingsCachingViewState extends State<SettingsCachingView> {
  final settings = Settings.instance.caching;
  Future<DirectoryInfo> coverDir = Future.delayed(
      const Duration(milliseconds: 500), () => getDirectoryInfo(MangaDex.instance.cover.cache!));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Caching")),
      body: ListView(
        children: [
          buildCoversSegment(textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget buildCoversSegment(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(textTheme, colorScheme, "Covers"),
        ListTile(
          isThreeLine: true,
          title: const Text("Cache Covers"),
          subtitle: const Text("Locally persist all manga covers downloaded while browsing."),
          trailing: ValueListenableBuilder(
            valueListenable: settings.box.listenable(),
            builder: (context, _, __) => Switch(
                value: settings.cacheCovers,
                onChanged: (value) => settings.box.put(CacheSettingKeys.cacheCovers, value)),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: settings.box.listenable(keys: [CacheSettingKeys.previewSize]),
          builder: (context, _, __) => ListTile(
            title: const Text("Preview Cover Size"),
            subtitle: const Text("Cover size to display in previews."),
            trailing: Text(settings.previewSize.human),
            onTap: () => showCoverSizeDialog(true, (value) {
              if (value == null) return;
              settings.box.put(CacheSettingKeys.previewSize, value);
            }),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: settings.box.listenable(keys: [CacheSettingKeys.fullSize]),
          builder: (context, _, __) => ListTile(
            title: const Text("Full Cover Size"),
            subtitle: const Text("Cover size to display on big surfaces."),
            trailing: Text(settings.fullSize.human),
            onTap: () => showCoverSizeDialog(false, (value) {
              if (value == null) return;
              settings.box.put(CacheSettingKeys.fullSize, value);
            }),
          ),
        ),
        ListTile(
          title: const Text("Clear Cover Cache"),
          subtitle: const Text("Delete all locally cached manga covers."),
          onTap: () => deleteCoversCache(context),
        ),
        FutureBuilder<DirectoryInfo>(
          future: coverDir,
          builder: (context, AsyncSnapshot<DirectoryInfo> snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return const LinearProgressIndicator();
            }

            final info = snapshot.data!;
            return Padding(
              padding: Edges.leftMedium,
              child: Text(
                "${info.files.length} covers, totaling ${info.humanSize}.",
                style: textTheme.bodySmall?.withColorOpacity(0.5),
              ),
            );
          },
        ),
      ],
    );
  }

  Padding buildTitle(TextTheme textTheme, ColorScheme colorScheme, String title) {
    return Padding(
      padding: Edges.leftLarge,
      child: Text(
        title,
        style: textTheme.titleSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void showCoverSizeDialog(
    bool isPreview,
    ValueChanged<CoverSize?> onChanged,
  ) =>
      showModalBottomSheet(
        context: context,
        builder: (context) {
          final textTheme = Theme.of(context).textTheme;

          return SizedBox(
            child: Padding(
              padding: Edges.verticalMedium,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: Edges.horizontalExtraLarge.copyWithSelf(Edges.verticalLarge),
                    child: Text(isPreview ? "Preview Cover Size" : "Full Cover Size",
                        style: textTheme.titleMedium),
                  ),
                  for (final size in CoverSize.values)
                    RadioListTile<CoverSize>(
                      value: size,
                      groupValue: isPreview ? settings.previewSize : settings.fullSize,
                      title: Text(size.human),
                      secondary: size.size == null
                          ? null
                          : Text("${size.size}x", style: textTheme.labelSmall),
                      onChanged: (value) {
                        Navigator.pop(context, value);
                        onChanged(value);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      );

  Future<void> deleteCoversCache(BuildContext context) async {
    final bool? prompt = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Covers Cache"),
        content: const Text("Are you sure you want to delete all locally cached manga covers?"),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.pop(context, false)),
          TextButton(child: const Text("Clear"), onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );

    if (prompt != true) return;
    await MangaDex.instance.cover.deleteAllPersistent();
    if (mounted) {
      showLazyBar(context, "Cover cache cleared successfully.");
      coverDir = getDirectoryInfo(MangaDex.instance.cover.cache!);
      setState(() {});
    }
  }
}
