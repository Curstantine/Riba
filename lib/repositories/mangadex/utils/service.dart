// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:io";

import "package:copy_with_extension/copy_with_extension.dart";
import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";

part "service.g.dart";

abstract class MangaDexService<
	DexType, LocalType, RuntimeDataType, InternalDataType,
	DefaultFilterType extends MangaDexQueryFilter,
	GetManyFilterType extends MangaDexQueryFilter,
	WithFiltersFilterType extends MangaDexQueryFilter
> {
	final Client client;
	final RateLimiter rateLimiter;
	final IsarCollection<LocalType> database;
	final URL rootUrl;

	abstract final URL baseUrl;
	abstract final Logger logger;
	abstract final Map<String, Rate> rates;
	abstract final DefaultFilterType defaultFilters;

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
		required GetManyFilterType overrides,
		bool checkDB = true,
	});

	/// Returns a [CollectionData] of [RuntimeDataType] objects.
	///
	/// This method will always fetch the data from the API.
	Future<CollectionData<RuntimeDataType>> withFilters({
		required WithFiltersFilterType overrides,
	});

	@visibleForOverriding
	Future<void> insertMeta(InternalDataType data);
	@visibleForOverriding
	Future<RuntimeDataType> collectMeta(LocalType single);
}

abstract interface class MangaDexQueryFilter {
	const MangaDexQueryFilter();

	/// Adds filters to a given [URL].
	/// 
	/// NOTE:
	/// This mutates the given [URL] without further cloning.
	URL addFiltersToUrl(URL sourceUrl);
}

@CopyWith()
class MangaDexGenericQueryFilter implements MangaDexQueryFilter {
	final List<EntityType>? includes;
	final int? limit;
	final int? offset;

	const MangaDexGenericQueryFilter({this.includes, this.limit, this.offset});

	@override
	URL addFiltersToUrl(URL sourceUrl) {
		if (includes != null) sourceUrl.setParameter("includes[]", includes);
		if (limit != null) sourceUrl.setParameter("limit", limit);
		if (offset != null) sourceUrl.setParameter("offset", offset);

		return sourceUrl;
	}

	@override
	String toString() => "MangaDexGenericQueryFilter(includes: $includes, limit: $limit, offset: $offset)";
}

extension ImplTo on URL {
	URL addFilters(MangaDexQueryFilter filter) => filter.addFiltersToUrl(this);
}
