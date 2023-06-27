import "package:flutter/material.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/error_card.dart";

import "filter_model.dart";

class ChapterFilterSheet extends StatefulWidget {
	const ChapterFilterSheet({
		super.key,
		required this.padding,
		required this.viewModel,
	});

	final EdgeInsets padding;
	final ChapterFilterSheetViewModel viewModel;

	@override
	State<ChapterFilterSheet> createState() => _ChapterFilterSheetState();
}

class _ChapterFilterSheetState extends State<ChapterFilterSheet> {
	ChapterFilterSheetViewModel get viewModel => widget.viewModel;

	@override
	Widget build(context) {
		final theme = Theme.of(context);
		final text = theme.textTheme;
		final colors = theme.colorScheme;

		return CustomScrollView(
			shrinkWrap: true,
			slivers: [
				SliverList.list(children: [
					Padding(padding: Edges.leftMedium.copyWith(right: Edges.small), child: Row(children: [
						Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
							Text("Chapter Groups", style: text.titleMedium),
							Text("Select which groups to include in the chapter list",
								style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
						]),
						const Spacer(),
						TextButton(onPressed: viewModel.resetChapterGroups, child: const Text("Reset"))
					])),
					const SizedBox(height: Edges.small),
				]),
				buildChapterGroupList(text, colors),
				const SliverToBoxAdapter(child: SizedBox(height: Edges.large)),
				SliverPadding(padding: Edges.horizontalMedium.copyWith(bottom: Edges.medium), sliver: SliverToBoxAdapter(
					child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
						TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
						const SizedBox(width: Edges.small),
						FilledButton(onPressed: () => viewModel.apply(context), child: const Text("Apply")),
					]),
				)),
			],
		);
	}

	Widget buildChapterGroupList(TextTheme text, ColorScheme colors) {
		return FutureBuilder(
			future: viewModel.groupData,
			builder: (context, snapshot) {
				if (snapshot.connectionState != ConnectionState.done) {
					return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
				}

				if (snapshot.hasError) {
					return SliverToBoxAdapter(child: ErrorCard(error: snapshot.error, margin: Edges.horizontalSmall));
				}

				final groups = snapshot.requireData;

				return SliverList.builder(
					itemCount: groups.length,
					itemBuilder: (context, i) {
						final group = groups.values.elementAt(i);
						final listenable = viewModel.groupSelection[group.id]!;

						return ValueListenableBuilder(
							valueListenable: listenable,
							builder: (context, value, _) => CheckboxListTile(
								dense: true,
								value: value,
								onChanged: (value) => listenable.value = value!,
								title: Text(group.name, style: text.bodyMedium),
							),
						);
					},
				);
		});
	}
}
