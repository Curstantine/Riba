import "dart:io";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:meta/meta.dart";
import 'package:riba/repositories/utils/rate_limiter.dart';

abstract class MangaDexQueryFilters {}

abstract class MangaDexService<DexType, LocalType, InternalDataType,
    QueryFilterType extends MangaDexQueryFilters> {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final Directory? cache;

  abstract final Map<String, Rate> rates;

  MangaDexService(this.client, this.rateLimiter, this.database, this.cache) {
    rateLimiter.rates.addAll(rates);
  }

  Future<LocalType> get(String id, {bool checkDB = true});
  Future<Map<String, LocalType>> getMany(
    List<String> ids, {
    bool checkDB = true,
    QueryFilterType? filters,
  });

  @visibleForOverriding
  Future<void> insertMeta(InternalDataType data);
  @visibleForOverriding
  Future<InternalDataType> collectMeta(LocalType id);
}
