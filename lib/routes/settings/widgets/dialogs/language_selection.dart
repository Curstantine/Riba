import "package:flutter/material.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/utils/constants.dart";

class LanguageSelectionSheet extends StatefulWidget {
	const LanguageSelectionSheet({
		super.key,
		required this.title,
		required this.description,
		required this.currentValue,
		required this.onConfirm,
	});

	final String title;
	final String description;
	final List<Language> currentValue;
	final ValueChanged<List<Language>> onConfirm;

  @override
  State<LanguageSelectionSheet> createState() => _LanguageSelectionSheetState();
}

class _LanguageSelectionSheetState extends State<LanguageSelectionSheet> {
	late final Map<Language, ValueNotifier<bool>> selectionMap = { 
		for (final e in Language.values) e : ValueNotifier(widget.currentValue.contains(e))
	};

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return Scaffold(
			body: CustomScrollView(slivers: [
				SliverAppBar.medium(
					title: Text(widget.title, overflow: TextOverflow.visible),
					automaticallyImplyLeading: false,
					leading: IconButton(
						icon: const Icon(Icons.close_rounded),
						onPressed: () => Navigator.pop(context),
					),
					actions: [
						IconButton(onPressed: () => {}, icon: const Icon(Icons.restore_rounded)),
						IconButton(onPressed: handleConfirm, icon: const Icon(Icons.check_rounded)),
					],
				),
				SliverToBoxAdapter(child: Padding(
					padding: Edges.horizontalLarge.copyWith(bottom: Edges.medium),
					child: Text(widget.description, style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
				)),
			    buildList(),
			]),
		);
	}

	Widget buildList() {
		return SliverList(delegate: SliverChildBuilderDelegate(
			childCount: selectionMap.length,
			(context, i) {
				final lang = selectionMap.keys.elementAt(i);
				final isSelected = selectionMap[lang]!;
				
				return ValueListenableBuilder(
					valueListenable: isSelected,
					builder: (context, value, child) => CheckboxListTile(
						title: child,
						value: isSelected.value,
						onChanged: (value) {
							if (value == null) return;
							selectionMap[lang]!.value = value;
						},
					),
					child: Text(lang.human)
				);
		}));
	}

	void handleConfirm() {
		final selected = selectionMap.entries.where((e) => e.value.value).map((e) => e.key).toList();
		widget.onConfirm(selected);
		Navigator.pop(context);
	}
}