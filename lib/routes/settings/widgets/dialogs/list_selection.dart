import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/utils/serde_ext.dart";

import "general.dart";

class ListSelectionDialog<T extends SerializableDataExt> extends StatefulWidget {
	const ListSelectionDialog({
		super.key,
		required this.title,
		required this.description,
		required this.values,
		required this.currentValue,
		this.itemBuilder,
		this.onReset,
	});

	final String title;
	final String description;
	final List<T> values;
	final List<T> currentValue;
	final ListItemData Function(T)? itemBuilder;
	final void Function()? onReset;

	@override
	State<ListSelectionDialog> createState() => _ListSelectionDialogState<T>();
}

class _ListSelectionDialogState<T extends SerializableDataExt> extends State<ListSelectionDialog<T>> {
	late final Map<T, ValueNotifier<bool>> selectionMap = { 
		for (final e in widget.values) e : ValueNotifier(widget.currentValue.contains(e))
	};

	@override
	Widget build(BuildContext context) {
		return FullScreenDialog(
			title: widget.title,
			description: widget.description,
			onReset: widget.onReset,
			onConfirm: handleConfirm,
			sliver: buildList(),
		);
	}

	Widget buildList() {
		return SliverList(delegate: SliverChildBuilderDelegate(
			childCount: selectionMap.length,
			(context, i) {
				final item = selectionMap.keys.elementAt(i);
				final isSelected = selectionMap[item]!;
				final itemData = widget.itemBuilder?.call(item) ?? ListItemData(item.asHumanReadable());
				
				return ValueListenableBuilder(
					valueListenable: isSelected,
					builder: (context, value, child) => CheckboxListTile(
						title: child,
						value: isSelected.value,
						subtitle: itemData.subtitle == null
							? null
							: Text(itemData.subtitle!),
						onChanged: (value) {
							if (value == null) return;
							selectionMap[item]!.value = value;
						},
					),
					child: Text(itemData.title),
				);
		}));
	}

	void handleConfirm() {
		final selected = selectionMap.entries.where((e) => e.value.value).map((e) => e.key).toList();
		Navigator.pop(context, selected);
	}
}