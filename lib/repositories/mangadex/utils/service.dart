// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";

abstract class MangaDexService<DexType, LocalType, RuntimeDataType, InternalDataType, QueryFilterType extends MangaDexQueryFilter> {
	final Client client;
	final RateLimiter rateLimiter;
	final IsarCollection<LocalType> database;
	final URL rootUrl;

	abstract final URL baseUrl;
	abstract final Logger logger;
	abstract final Map<String, Rate> rates;
	abstract final QueryFilterType defaultFilters;

	abstract final Directory cacheDir;
	abstract final Directory dataDir;

	MangaDexService({
		required this.client,
		required this.rateLimiter,
		required this.database,
		required this.rootUrl,
	}) {
		rateLimiter.rates.addAll(rates);
	}

	/// Returns a [RuntimeDataType] object from the given [id].
	///
	/// If [checkDB] is true, the database will be checked for the data first.
	Future<RuntimeDataType> get(String id, {bool checkDB = true});

	/// Returns a Map of [RuntimeDataType] accompanied by their [id].
	///
	/// If [checkDB] is true, the database will be checked for the data first.
	Future<Map<String, RuntimeDataType>> getMany({
		required QueryFilterType overrides,
		bool checkDB = true,
	});

	/// Returns a [CollectionData] of [RuntimeDataType] objects.
	///
	/// This method will always fetch the data from the API.
	Future<CollectionData<RuntimeDataType>> withFilters({
		required QueryFilterType overrides,
	});

	@visibleForOverriding
	Future<void> insertMeta(InternalDataType data);
	@visibleForOverriding
	Future<RuntimeDataType> collectMeta(LocalType single);
}

abstract class MangaDexQueryFilter {
	const MangaDexQueryFilter();
	URL addFiltersToUrl(URL url);
}

class MangaDexGenericQueryFilter extends MangaDexQueryFilter {
	final List<String>? ids;
	final List<EntityType>? includes;
	final int? limit;
	final int? offset;

	const MangaDexGenericQueryFilter({this.ids, this.includes, this.limit, this.offset});

	@override
	URL addFiltersToUrl(URL url) {
		if (ids != null) url.setParameter("ids[]", ids);
		if (includes != null) url.setParameter("includes[]", includes);
		if (limit != null) url.setParameter("limit", limit);
		if (offset != null) url.setParameter("offset", offset);

		return url;
	}

	MangaDexGenericQueryFilter copyWith(MangaDexGenericQueryFilter other) {
		return MangaDexGenericQueryFilter(
			ids: other.ids ?? ids,
			includes: other.includes ?? includes,
			limit: other.limit ?? limit,
			offset: other.offset ?? offset,
		);
	}

	@override
	String toString() => "MangaDexGenericQueryFilter(includes: $includes, limit: $limit, offset: $offset)";
}
