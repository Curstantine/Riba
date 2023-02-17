import "dart:io";
import "dart:math";

import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

import "lazy.dart";

Future<void> launchLink(
  BuildContext context,
  String? href, {
  LaunchMode mode = LaunchMode.platformDefault,
  WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
  String? webOnlyWindowName,
}) async {
  try {
    if (href == null) return showLazyBar(context, "Link's href is null");

    final url = Uri.parse(href);
    if (await canLaunchUrl(url)) {
      launchUrl(
        url,
        mode: mode,
        webViewConfiguration: webViewConfiguration,
        webOnlyWindowName: webOnlyWindowName,
      );
    }
  } catch (e) {
    showLazyBar(context, "Failed to launch link: $e");
  }
}

/// Formats the given bytes into a human readable string.
///
/// Credits: https://gist.github.com/zzpmaster/ec51afdbbfa5b2bf6ced13374ff891d9
String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0B";
  const suffixes = ["B", "KB", "MB", "GB"];
  final i = (log(bytes) / log(1000)).floor();
  return "${(bytes / pow(1000, i)).toStringAsFixed(decimals)}${suffixes[i]}";
}

class DirectoryInfo {
  final int size;
  final List<FileSystemEntity> files;

  const DirectoryInfo(this.size, this.files);

  String get humanSize => formatBytes(size, 2);
}

Future<DirectoryInfo> getDirectoryInfo(Directory directory) async {
  if (!await directory.exists()) return const DirectoryInfo(0, []);

  final files = await directory.list().toList();
  final size = await Future.wait(files.map((file) => file.stat())).then((stats) {
    return stats.fold<int>(0, (prev, e) => prev + e.size);
  });

  return DirectoryInfo(size, files);
}
