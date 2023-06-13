
import "package:flutter/material.dart" hide SearchBar;
import "package:riba/routes/explore/model.dart";
import "package:riba/utils/constants.dart";
import "package:riba/widgets/material/search.dart";
import "package:riba/widgets/root_action_popup_button.dart";

import "../views/quick_search.dart";


class QuickSearchPortal extends StatelessWidget {
	const QuickSearchPortal({super.key});

	ExploreViewModel get viewModel => ExploreViewModel.instance;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: Edges.horizontalMedium,
			child: SearchAnchor(
				searchController: viewModel.quickSearchController,
				suggestionsBuilder: (_, __) => [],
				viewBuilder: (_) => const QuickSearchView(),
				viewTrailing: [
					IconButton(
						icon: const Icon(Icons.filter_list_rounded),
						onPressed: () => viewModel.showQuickSearchFilterSheet(context),
					),
					IconButton(
						icon: const Icon(Icons.close_rounded),
						onPressed: () => viewModel.quickSearchController.value = TextEditingValue.empty,
					)
				],
				viewLeading: IconButton(
					icon: const Icon(Icons.arrow_back_rounded),
					onPressed: () => viewModel.quickSearchController.closeView(null)
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

