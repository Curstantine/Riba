import "package:riba/routes/home/views/explore.dart";

class HomeViewModel {
	HomeViewModel._internal();

	static HomeViewModel? _instance;
	static HomeViewModel get instance => _instance ??= HomeViewModel._internal();

	final ExploreContentViewModel exploreViewModel = ExploreContentViewModel();
}