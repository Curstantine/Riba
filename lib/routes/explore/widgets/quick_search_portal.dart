
import "package:flutter/material.dart" hide SearchBar;
import "package:riba/routes/explore/model.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/debouncer.dart";
import "package:riba/widgets/material/search.dart";
import "package:riba/widgets/root_action_popup_button.dart";

import "../views/quick_search.dart";


class QuickSearchPortal extends StatefulWidget {
	const QuickSearchPortal({super.key});

	@override
	State<QuickSearchPortal> createState() => _QuickSearchPortalState();
}

class _QuickSearchPortalState extends State<QuickSearchPortal> {
	final debouncer = Debounce(duration: const Duration(milliseconds: 500));

	ExploreViewModel get viewModel => ExploreViewModel.instance;

	@override
	void initState() {
		super.initState();
		viewModel.quickSearchController.addListener(onInputChange);
		viewModel.initializeQuickSearch();
	}

	@override
	void dispose() {
		super.dispose();
		viewModel.quickSearchController.removeListener(onInputChange);
	}

	void onInputChange() => debouncer.run(() => viewModel.refreshQuickSearch());

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: Edges.horizontalMedium,
			child: SearchAnchor(
				searchController: viewModel.quickSearchController,
				suggestionsBuilder: (_, __) => [],
				viewBuilder: (_) => const QuickSearchView(),
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

	Color getSearchBarShadow(Set<MaterialState> states) {
		return Colors.transparent;
	}
}

