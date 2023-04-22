import "dart:async";

import "package:flutter/material.dart";

class StreamingListTile<T> extends StatelessWidget {
	const StreamingListTile({
		super.key,
		required this.enabled,
		required this.title,
		required this.stream,
		this.subtitle,
		this.contextualSubtitle,
		this.onTap,
		this.builder,
	}) : assert(subtitle == null || contextualSubtitle == null);
	
	final bool enabled;
	final String title;
	final Stream<T> stream;
	final bool isThreeLine = false;
	final String? subtitle;
	final Function(BuildContext, T)? contextualSubtitle;
	final FutureOr<void> Function(BuildContext, T)? onTap;
	final Function(BuildContext, T)? builder;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;

		Widget? sub = subtitle != null ? Text(subtitle!) : null;
		
		return StreamBuilder(stream: stream, builder: (context, snapshot) {
			Widget? trailing;
			FutureOr<void> Function()? onTapL;

			if (snapshot.connectionState != ConnectionState.active && !snapshot.hasData) {
				trailing = const CircularProgressIndicator();
			}

			if (snapshot.hasError) {
				trailing = Icon(Icons.error_outline, color: colors.error);
			}

			if (snapshot.hasData) {
				sub ??= contextualSubtitle!.call(context, snapshot.requireData);
				onTapL = () => onTap?.call(context, snapshot.requireData);
				trailing = builder?.call(context, snapshot.requireData);
			} 
			

			return ListTile(
				enabled: snapshot.hasData && enabled,
				title: Text(title),
				isThreeLine: isThreeLine,
				subtitle: sub,
				onTap: onTapL,
				trailing: trailing,
			);
		});
	}
}