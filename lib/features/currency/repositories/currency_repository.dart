import 'package:advance_currency_convertor/core/failure/app_failure.dart';
import 'package:advance_currency_convertor/features/currency/db/currency_db_service.dart';
import 'package:advance_currency_convertor/features/currency/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/features/currency/repositories/currency_api_service.dart';
import 'package:advance_currency_convertor/features/currency/repositories/icurrency_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:dartz/dartz.dart';

class CurrencyRateRepository implements ICurrencyRateRepository {
  @override
  Future<Either<AppFailure, CurrencyRateModel>> getExchangeRates({
    required String base,
    required List<String> symbols,
  }) async {
    final res = await sl<CurrencyApiService>().getExchangeRates(
      base: base,
      symbols: symbols,
    );

    return await res.fold((failure) => Left(failure), (data) async {
      // Cache to DB using the service
      await sl<CurrencyDBService>().cacheCurrencyRates(data);
      return Right(data);
    });
  }
}
