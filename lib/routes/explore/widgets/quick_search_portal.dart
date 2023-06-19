
import "package:flutter/material.dart" hide SearchBar;
import "package:material_symbols_icons/symbols.dart";
import "package:riba/routes/explore/model.dart";
import "package:riba/routes/explore/views/quick_search_model.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/material/search.dart";
import "package:riba/widgets/root_action_popup_button.dart";

import "../views/quick_search.dart";


class QuickSearchPortal extends StatelessWidget {
	const QuickSearchPortal({super.key});

	ExploreViewModel get rootViewModel => ExploreViewModel.instance;
	QuickSearchViewModel get viewModel => QuickSearchViewModel.instance;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: Edges.horizontalMedium,
			child: SearchAnchor(
				searchController: rootViewModel.searchController,
				suggestionsBuilder: (_, __) => [],
				viewBuilder: (_) => const QuickSearchView(),
				viewTrailing: [
					IconButton(
						icon: const Icon(Symbols.filter_list_rounded),
						onPressed: () => viewModel.showFilterSheet(context),
					),
					IconButton(
						icon: const Icon(Symbols.close_rounded),
						onPressed: () => rootViewModel.searchController.value = TextEditingValue.empty,
					)
				],
				viewLeading: IconButton(
					icon: const Icon(Symbols.arrow_back_rounded),
					onPressed: () => rootViewModel.searchController.closeView(null)
				),
				builder: (context, controller) => SearchBar(
					controller: controller,
					trailing: const [
						RootActionPopupButton()
					],
				),
			),
		);
	}
}

