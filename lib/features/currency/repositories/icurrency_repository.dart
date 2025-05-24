import 'package:advance_currency_convertor/core/failure/app_failure.dart';
import 'package:advance_currency_convertor/features/currency/model/currency_rate_model.dart';
import 'package:dartz/dartz.dart';

abstract class ICurrencyRateRepository {
  Future<Either<AppFailure, CurrencyRateModel>> getExchangeRates({
    required String base,
    required List<String> symbols,
  });
}
