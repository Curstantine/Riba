import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/mangadex.dart";
import "package:riba/settings/theme.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/external.dart";
import "package:riba/utils/lazy.dart";

class SettingsCachingView extends StatefulWidget {
  const SettingsCachingView({super.key});

  @override
  State<SettingsCachingView> createState() => _SettingsCachingViewState();
}

class _SettingsCachingViewState extends State<SettingsCachingView> {
  bool cacheCovers = false;
  Future<DirectoryInfo> coverDir = getDirectoryInfo(MangaDex.instance.covers.directory);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Caching")),
      body: ListView(
        children: [
          buildTitle(textTheme, colorScheme, "Covers"),
          ListTile(
            isThreeLine: true,
            title: const Text("Cache Covers"),
            subtitle: const Text("Locally persist all manga covers downloaded while browsing."),
            trailing: Switch(
              value: cacheCovers,
              onChanged: (value) => setState(() => cacheCovers = value),
            ),
          ),
          ListTile(
            title: const Text("Clear Covers Cache"),
            subtitle: const Text("Delete all locally cached manga covers."),
            onTap: () => deleteCoversCache(context),
          ),
          FutureBuilder(
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
      ),
    );
  }

  Padding buildTitle(TextTheme textTheme, ColorScheme colorScheme, String title) {
    return Padding(
      padding: Edges.leftLarge,
      child: Text(
        title,
        style: textTheme.titleSmall?.copyWith(color: colorScheme.primary),
      ),
    );
  }

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
    await MangaDex.instance.covers.deleteAll();
    if (mounted) {
      showLazyBar(context, "Cover cache cleared successfully.");
      coverDir = getDirectoryInfo(MangaDex.instance.covers.directory);
      setState(() {});
    }
  }
}
