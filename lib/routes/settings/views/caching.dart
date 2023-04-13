import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/settings/cache.dart";
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
  Future<DirectoryInfo> coverDir = Future.delayed(
    const Duration(milliseconds: 500),
    () => getDirectoryInfo(MangaDex.instance.cover.cacheDir),
  );

  final coverCacheSettingsStream = CoverCacheSettings.ref
      .where()
      .keyEqualTo(CoverCacheSettings.isarKey)
      .watch()
      .asBroadcastStream()
      .asyncMap((event) => event.first);

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
          trailing: StreamBuilder(
            stream: coverCacheSettingsStream,
            builder: (context, snapshot) {
              final settings = snapshot.requireData;
              return Switch(
                value: settings.enabled,
                onChanged: (value) => CoverCacheSettings.ref.put(settings.copyWith(enabled: value)),
              );
            },
          ),
        ),
        StreamBuilder(
          stream: coverCacheSettingsStream,
          builder: (context, snapshot) {
            final settings = snapshot.requireData;

            return ListTile(
              title: const Text("Preview Cover Size"),
              subtitle: const Text("Cover size to display in previews."),
              trailing: Text(settings.previewSize.asHumanReadable()),
              onTap: () => showCoverSizeDialog(
                isPreview: true,
                current: settings.previewSize,
                onChanged: (value) =>
                    CoverCacheSettings.ref.put(settings.copyWith(previewSize: value)),
              ),
            );
          },
        ),
        StreamBuilder(
          stream: coverCacheSettingsStream,
          builder: (context, snapshot) {
            final settings = snapshot.requireData;

            return ListTile(
              title: const Text("Full Cover Size"),
              subtitle: const Text("Cover size to display on big surfaces."),
              trailing: Text(settings.fullSize.asHumanReadable()),
              onTap: () => showCoverSizeDialog(
                isPreview: false,
                current: settings.fullSize,
                onChanged: (value) =>
                    CoverCacheSettings.ref.put(settings.copyWith(fullSize: value)),
              ),
            );
          },
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

  void showCoverSizeDialog({
    required bool isPreview,
    required CoverSize current,
    required ValueChanged<CoverSize> onChanged,
  }) =>
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return CoverSizeSheet(
            title: isPreview ? "Preview Cover Size" : "Full Cover Size",
            currentValue: current,
            onChanged: onChanged,
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
      coverDir = getDirectoryInfo(MangaDex.instance.cover.cacheDir);
      setState(() {});
    }
  }
}

class CoverSizeSheet extends StatelessWidget {
  const CoverSizeSheet({
    super.key,
    required this.title,
    required this.currentValue,
    required this.onChanged,
  });

  final String title;
  final CoverSize currentValue;
  final ValueChanged<CoverSize> onChanged;

  @override
  Widget build(BuildContext context) {
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
              child: Text(title, style: textTheme.titleMedium),
            ),
            for (final size in CoverSize.values)
              RadioListTile<CoverSize>(
                value: size,
                key: ValueKey(size.name),
                groupValue: currentValue,
                title: Text(size.asHumanReadable()),
                secondary:
                    size.size == null ? null : Text("${size.size}x", style: textTheme.labelSmall),
                onChanged: (value) {
                  Navigator.pop(context, value);
                  if (value != null) onChanged.call(value);
                },
              ),
          ],
        ),
      ),
    );
  }
}
