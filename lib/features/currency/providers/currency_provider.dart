import 'package:advance_currency_convertor/features/currency/repositories/icurrency_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencyRateRepositoryProvider = Provider<ICurrencyRateRepository>((ref) {
  return sl<ICurrencyRateRepository>();
});
