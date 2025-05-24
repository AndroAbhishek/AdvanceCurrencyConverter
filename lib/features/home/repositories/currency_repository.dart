import 'package:advance_currency_convertor/core/failure/app_failure.dart';
import 'package:advance_currency_convertor/features/home/db/dao/currency_rate_dao.dart';
import 'package:advance_currency_convertor/features/home/db/entities/currency_rate_entity.dart';
import 'package:advance_currency_convertor/features/home/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/features/home/repositories/currency_rate_remote_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependecies.dart';
import 'package:dartz/dartz.dart';

class CurrencyRateRepository {
  Future<Either<AppFailure, CurrencyRateModel>> getExchangeRates({
    required String base,
    required List<String> symbols,
  }) async {
    final res = await sl<CurrencyRateRemoteRepository>().getExchangeRates(
      base: base,
      symbols: symbols,
    );

    return await res.fold((failure) => Left(failure), (data) async {
      // Cache to DB
      await sl<CurrencyRateDao>().deleteRatesByBase(data.base);

      final rateEntities =
          data.rates.entries.map((e) {
            return CurrencyRateEntity(
              base: data.base,
              target: e.key,
              rate: e.value,
              date: data.date,
            );
          }).toList();

      await sl<CurrencyRateDao>().insertRates(rateEntities);

      return Right(data);
    });
  }
}
