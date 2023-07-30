import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/utils/serde_ext.dart";
import "package:riba/widgets/material/chip.dart";

class GenericFilterListChip<T extends SerializableDataExt> extends StatelessWidget {
	final T status;
	final ValueNotifier<List<T>> notifier;

	const GenericFilterListChip({
		super.key, 
		required this.status,
		required this.notifier,
	});

	@override
	Widget build(BuildContext context) {
		return ValueListenableBuilder(
			valueListenable: notifier,
			builder: (context, selectedList, _) => FilterChipExt(
				showCheckmark: false,
				selected: selectedList.contains(status),
				label: Text(status.asHumanReadable()),
				onSelected: (select) {
					if (select) {
						notifier.value = [...selectedList, status];
					} else {
						notifier.value = selectedList.where((e) => e != status).toList();
					}
				},
			),
		);
	}
}