import 'package:advance_currency_convertor/core/failure/app_failure.dart';
import 'package:advance_currency_convertor/features/currency/db/currency_db_service.dart';
import 'package:advance_currency_convertor/features/currency/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/features/currency/repositories/currency_api_service.dart';
import 'package:advance_currency_convertor/features/currency/repositories/currency_repository.dart';
import 'package:advance_currency_convertor/features/currency/repositories/icurrency_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'currency_repo_test.mocks.dart';

@GenerateMocks([CurrencyApiService, CurrencyDBService])
void main() {
  late ICurrencyRateRepository repository;
  late MockCurrencyApiService mockApiService;
  late MockCurrencyDBService mockDBService;

  setUp(() {
    // Register mock only if not already registered
    mockApiService = MockCurrencyApiService();
    mockDBService = MockCurrencyDBService();

    // Unregister if already registered
    if (sl.isRegistered<CurrencyApiService>()) {
      sl.unregister<CurrencyApiService>();
    }
    if (sl.isRegistered<CurrencyDBService>()) {
      sl.unregister<CurrencyDBService>();
    }

    // Now register the mocks
    sl.registerFactory<CurrencyApiService>(() => mockApiService);
    sl.registerFactory<CurrencyDBService>(() => mockDBService);

    repository = CurrencyRateRepository();
  });

  group('getExchangeRates', () {
    const base = 'USD';
    const symbols = ['EUR', 'INR'];
    final model = CurrencyRateModel(
      base: "USD",
      rates: {"EUR": 0.85, "INR": 74.50},
      success: true,
      timestamp: 1704067200,
      date: "2024-01-01",
    );

    test('should return Right(model) and cache it when API succeeds', () async {
      when(
        mockApiService.getExchangeRates(base: base, symbols: symbols),
      ).thenAnswer((_) async => Right(model));

      when(
        mockDBService.cacheCurrencyRates(model),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.getExchangeRates(
        base: base,
        symbols: symbols,
      );

      expect(result, Right(model));
      verify(
        mockApiService.getExchangeRates(base: base, symbols: symbols),
      ).called(1);
      verify(mockDBService.cacheCurrencyRates(model)).called(1);
    });

    test('should return Left(AppFailure) when API fails', () async {
      final failure = AppFailure('API error');

      when(
        mockApiService.getExchangeRates(base: base, symbols: symbols),
      ).thenAnswer((_) async => Left(failure));

      final result = await repository.getExchangeRates(
        base: base,
        symbols: symbols,
      );

      expect(result, Left(failure));
      verify(
        mockApiService.getExchangeRates(base: base, symbols: symbols),
      ).called(1);
      verifyNever(mockDBService.cacheCurrencyRates(any));
    });
  });
}
