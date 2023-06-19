import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:material_symbols_icons/symbols.dart";

class StreamingListTile<T> extends StatelessWidget {
	const StreamingListTile({
		super.key,
		required this.title,
		required this.stream,
		this.isThreeLine = false,
		this.enabled = true,
		this.subtitle,
		this.contextualSubtitle,
		this.onTap,
		this.builder,
	}) : assert(subtitle == null || contextualSubtitle == null);

	final bool enabled;
	final String title;
	final Stream<T> stream;
	final bool isThreeLine;
	final String? subtitle;
	final Function(BuildContext, T)? contextualSubtitle;
	final FutureOr<void> Function(BuildContext, T)? onTap;
	final Function(BuildContext, T)? builder;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final colors = theme.colorScheme;
		
		return StreamBuilder(stream: stream, builder: (context, snapshot) {
			Widget? trailing;
			FutureOr<void> Function()? onTapL;
			Widget? sub =  subtitle != null ? Text(subtitle!) : null;

			if (snapshot.connectionState != ConnectionState.active && !snapshot.hasData) {
				trailing = const CircularProgressIndicator();
			}

			if (snapshot.hasError) {
				trailing = Icon(Symbols.error_outline, color: colors.error);
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

class ValueListenableListTile<T> extends StatelessWidget {
	const ValueListenableListTile({
		super.key,
		required this.title,
		required this.valueListenable,
		this.isThreeLine = false,
		this.enabled = true,
		this.subtitle,
		this.contextualSubtitle,
		this.onTap,
		this.builder,
	}) : assert(subtitle == null || contextualSubtitle == null);

	final bool enabled;
	final String title;
	final ValueListenable<T> valueListenable;
	final bool isThreeLine;
	final String? subtitle;
	final Function(BuildContext, T)? contextualSubtitle;
	final FutureOr<void> Function(BuildContext, T)? onTap;
	final Function(BuildContext, T)? builder;

	@override
	Widget build(BuildContext context) {		
		return ValueListenableBuilder(
			valueListenable: valueListenable,
			builder: (context, snapshot, child) => ListTile(
				enabled: enabled,
				title: Text(title),
				isThreeLine: isThreeLine,
				subtitle: subtitle != null 
					? Text(subtitle!)
					: contextualSubtitle!.call(context, snapshot),
				onTap: () => onTap?.call(context, snapshot),
				trailing: builder?.call(context, snapshot),
			),
		);
	}
}