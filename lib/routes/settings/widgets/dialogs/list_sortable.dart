import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/utils/serde_ext.dart";
import "package:riba/utils/theme.dart";

import "general.dart";

class ListSortableDialog<T extends SerializableDataExt> extends StatefulWidget {
	const ListSortableDialog({
		super.key,
		required this.title,
		required this.description,
		required this.values,
		required this.currentValue,
		required this.itemBuilder,
		this.onReset,
	});

	final String title;
	final String description;
	final List<T> values;
	final List<T> currentValue;
	final ListItemData Function(T) itemBuilder;
	final void Function()? onReset;

	@override
	State<ListSortableDialog<T>> createState() => _ListSortableDialogState<T>();
}

class _ListSortableDialogState<T extends SerializableDataExt> extends State<ListSortableDialog<T>> {
	late final List<T> selectionMap = List.from(widget.currentValue);
	late final List<T> idleMap = List.from(
		widget.values.where((e) => !widget.currentValue.contains(e)),
	);

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return FullScreenDialog(
			title: widget.title,
			description: widget.description,
			onReset: widget.onReset,
			onConfirm: () => Navigator.pop(context, selectionMap),
			sliver: buildSelectedList(text, colors),
		);
	}

	Widget buildSelectedList(TextTheme text, ColorScheme colors) {
		return SliverReorderableList(
			// index starts with 0, so we don't need to account for the divider.
			itemCount: selectionMap.length + idleMap.length,
			onReorder: handleReorder,
			itemBuilder: (context, i) {
				if (i == selectionMap.length) {
					return const Divider(key: ValueKey("divider"));
				}

				int actualIndex = i > selectionMap.length ? i - 1 : i;
				T item;

				if (i > selectionMap.length) {
					item = idleMap.elementAt(actualIndex - selectionMap.length);
				} else {
					item = selectionMap.elementAt(i);
				}

				final itemData = widget.itemBuilder(item);
				
				return Material(
					key: ValueKey(item),
					child: ListTile(
						isThreeLine: itemData.isThreeLine,
						title: Text("$i.${itemData.title}"),
						subtitle: itemData.subtitle == null 
							? null
							: Text(itemData.subtitle!, style: text.bodySmall?.withColorOpacity(0.75)),
						trailing: ReorderableDragStartListener(
							index: i,
							child: const Icon(Icons.drag_handle_rounded),
						),
					),
				);
			},
		);
	}

	void handleReorder(int oldIndex, int newIndex) {
		// Accounts for the divider, so anything larger than selectionMap.length
		// is in the idleMap. Subtract by selectionMap.length to get the index relative to
		// the idleMap.
		final oldActualIndex = oldIndex > selectionMap.length ? oldIndex - 1 : oldIndex;
		final newActualIndex = newIndex > selectionMap.length ? newIndex - 1 : newIndex;

		final wasInSelection = oldIndex < selectionMap.length;
		final wasInIdle = oldIndex >= selectionMap.length;
		// Since these two depend on a list that could be grown by +1, 
		// we will be using length instead of max index.
		final isInSelection = newIndex <= selectionMap.length;
		final isInIdle = newIndex > selectionMap.length;

		setState(() {
			switch ((wasInSelection, wasInIdle, isInSelection, isInIdle)) {
				case (true, false, true, false):
					selectionMap.insert(newActualIndex, selectionMap.removeAt(oldIndex));
					break;
				case (true, false, false, true):
					idleMap.insert(newActualIndex - selectionMap.length, selectionMap.removeAt(oldIndex));
					break;
				case (false, true, true, false):
					selectionMap.insert(newActualIndex, idleMap.removeAt(oldActualIndex - selectionMap.length));
					break;
				case (false, true, false, true):
					idleMap.insert(newActualIndex - selectionMap.length, idleMap.removeAt(oldActualIndex - selectionMap.length));
					break;
				default:
					throw Exception("Invalid reorder combination");
			}
		});
	}
}

