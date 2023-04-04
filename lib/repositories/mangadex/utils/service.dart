// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";

abstract class MangaDexService<DexType, LocalType, RuntimeDataType, InternalDataType,
    QueryFilterType extends MangaDexQueryFilter> {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final Directory? cache;
  final URL rootUrl;

  abstract final URL baseUrl;
  abstract final Logger logger;
  abstract final Map<String, Rate> rates;
  abstract final QueryFilterType defaultFilters;

  MangaDexService({
    required this.client,
    required this.rateLimiter,
    required this.database,
    required this.rootUrl,
    this.cache,
  }) {
    rateLimiter.rates.addAll(rates);
  }

  Future<RuntimeDataType> get(String id, {bool checkDB = true});
  Future<Map<String, RuntimeDataType>> getMany({
    required QueryFilterType overrides,
    bool checkDB = true,
  });

  @visibleForOverriding
  Future<void> insertMeta(InternalDataType data);
  @visibleForOverriding
  Future<InternalDataType> collectMeta(LocalType single);

  MangaDexService<DexType, LocalType, RuntimeDataType, InternalDataType, QueryFilterType>
      get instance;
}

abstract class MangaDexQueryFilter {
  URL addFiltersToUrl(URL url);
}

class MangaDexGenericQueryFilter extends MangaDexQueryFilter {
  final List<String>? ids;
  final List<EntityType>? includes;
  final int? limit;
  final int? offset;

  MangaDexGenericQueryFilter({this.includes, this.limit, this.offset, this.ids});

  @override
  URL addFiltersToUrl(URL url) {
    if (ids != null) {
      url.setParameter("ids[]", ids);
    }

    if (includes != null) {
      url.setParameter("includes[]", includes!.map((e) => e.toJsonValue()).toList());
    }

    if (limit != null) {
      url.setParameter("limit", limit);
    }

    if (offset != null) {
      url.setParameter("offset", offset);
    }

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
  String toString() => "MangaDexGenericQueryFilter(ids: $ids, includes: $includes,"
      " limit: $limit, offset: $offset)";
}
