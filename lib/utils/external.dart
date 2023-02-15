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
