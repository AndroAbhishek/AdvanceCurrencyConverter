import 'package:advance_currency_convertor/features/home/repositories/currency_rate_remote_repository.dart';
import 'package:advance_currency_convertor/features/home/repositories/currency_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependecies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencyRateRemoteRepositoryProvider = Provider((ref) {
  return CurrencyRateRemoteRepository();
});

final currencyRateRepositoryProvider = Provider<CurrencyRateRepository>((ref) {
  return sl<CurrencyRateRepository>();
});
