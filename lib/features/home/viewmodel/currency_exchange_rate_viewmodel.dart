import 'package:advance_currency_convertor/core/database/app_database.dart';
import 'package:advance_currency_convertor/core/database/entities/currency_rate_entity.dart';
import 'package:advance_currency_convertor/features/home/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/features/home/repositories/currency_rate_remote_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependecies.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'currency_exchange_rate_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class CurrencyExchangeRateViewmodel extends _$CurrencyExchangeRateViewmodel {
  @override
  FutureOr<CurrencyRateModel> build({
    required String base,
    required List<String> symbols,
  }) async {
    final res = await sl<CurrencyRateRemoteRepository>().getExchangeRates(
      base: base,
      symbols: symbols,
    );

    return await res.fold((failure) => throw failure.message, (data) async {
      // Save to local DB
      final dao = sl<AppDatabase>().currencyRateDao;

      // First delete previous data for the same base
      await dao.deleteRatesByBase(data.base);

      // Map and insert new data
      final rateEntities =
          data.rates.entries.map((e) {
            return CurrencyRateEntity(
              base: data.base,
              target: e.key,
              rate: e.value,
              date: data.date,
            );
          }).toList();

      await dao.insertRates(rateEntities);

      // ✅ Debug print
      final storedRates = await dao.getRatesByBase(data.base);
      for (var rate in storedRates) {
        debugPrint(
          'Stored Rate -> Base: ${rate.base}, Target: ${rate.target}, Rate: ${rate.rate}, Date: ${rate.date}',
        );
      }

      return data;
    });
  }

  // Future<void> refresh(String base, List<String> symbols) async {
  //   state = const AsyncValue.loading();

  //   final res = await sl<CurrencyRateRemoteRepository>().getExchangeRates(
  //     base: base,
  //     symbols: symbols,
  //   );

  //   res.fold(
  //     (failure) =>
  //         state = AsyncValue.error(failure.message, StackTrace.current),
  //     (data) {
  //       state = AsyncValue.data(data);
  //     },
  //   );
  // }
}
