import "package:flutter/foundation.dart";
import "package:logging/logging.dart";
import "package:riba/routes/home/views/explore/model.dart";
import "package:riba/routes/home/views/view.dart";

class HomeViewModel {
	HomeViewModel._internal();

	static HomeViewModel? _instance;
	static HomeViewModel get instance => _instance ??= HomeViewModel._internal();

	final ExploreContentViewModel exploreViewModel = ExploreContentViewModel();

	final logger = Logger("Home");
	final ValueNotifier<HomeViewPage> currentPage = ValueNotifier(HomeViewPage.home);
}