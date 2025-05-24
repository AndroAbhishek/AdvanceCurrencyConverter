// test/mocks.dart

import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/features/currency/db/dao/currency_rate_dao.dart';
import 'package:advance_currency_convertor/features/currency/db/entities/currency_rate_entity.dart';
import 'package:advance_currency_convertor/features/currency/providers/currency_provider.dart';
import 'package:advance_currency_convertor/features/currency/providers/currency_state_provider.dart';
import 'package:advance_currency_convertor/features/currency/repositories/currency_repository.dart';
import 'package:advance_currency_convertor/features/currency/viewmodel/currency_viewmodel.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:advance_currency_convertor/core/database/app_database.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'currency_test.mocks.dart';

@GenerateMocks([AppDatabase, CurrencyRateDao, CurrencyRateRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late MockCurrencyRateRepository mockRepository;
  late MockAppDatabase mockDatabase;
  late MockCurrencyRateDao mockCurrencyRateDao;

  setUp(() {
    mockRepository = MockCurrencyRateRepository();
    mockDatabase = MockAppDatabase();
    mockCurrencyRateDao = MockCurrencyRateDao();

    when(mockDatabase.currencyRateDao).thenReturn(mockCurrencyRateDao);

    container = ProviderContainer(
      overrides: [
        currencyRateRepositoryProvider.overrideWithValue(mockRepository),
        currencyRateDaoProvider.overrideWithValue(mockCurrencyRateDao),
        baseCurrencyProvider.overrideWith((ref) => "USD (US Dollar)"),
        cardKeysProvider.overrideWith((ref) => [1]),
        textControllersProvider.overrideWith(
          (ref) => {1: TextEditingController(text: "100")},
        ),
        selectedValuesProvider.overrideWith((ref) => {1: "INR (Indian Rupee)"}),
        isLoadingProvider.overrideWith((ref) => false),
      ],
    );

    if (!sl.isRegistered<AppDatabase>()) {
      sl.registerSingleton<AppDatabase>(mockDatabase);
    }
  });

  tearDown(() {
    container.dispose();
  });

  group('CurrencyViewModel Tests', () {
    test('validateAllCards returns null for valid data', () {
      final viewModel = container.read(currencyViewModelProvider.notifier);
      final result = viewModel.validateAllCards();
      expect(result, null);
    });

    test('validateAllCards returns error for empty amount', () {
      container = ProviderContainer(
        overrides: [
          cardKeysProvider.overrideWith((ref) => [1]),
          textControllersProvider.overrideWith(
            (ref) => {1: TextEditingController(text: "")},
          ),
          selectedValuesProvider.overrideWith(
            (ref) => {1: "INR (Indian Rupee)"},
          ),
        ],
      );

      final viewModel = container.read(currencyViewModelProvider.notifier);
      final result = viewModel.validateAllCards();
      expect(result, TextConstants.amountValidation);
    });

    test(
      'calculateExchangeRate should update calculatedAmountProvider',
      () async {
        // Set up AppPreferences with base currency
        SharedPreferences.setMockInitialValues({
          TextConstants.baseCurrency: "USD (US Dollar)",
        });

        final prefs = await SharedPreferences.getInstance();

        if (sl.isRegistered<SharedPreferences>()) {
          sl.unregister<SharedPreferences>();
        }
        sl.registerSingleton<SharedPreferences>(prefs);

        container = ProviderContainer(
          overrides: [
            currencyRateRepositoryProvider.overrideWithValue(mockRepository),
            currencyRateDaoProvider.overrideWithValue(mockCurrencyRateDao),
            // Don't override baseCurrencyProvider, let it read from AppPreferences
            //baseCurrencyProvider.overrideWith((ref) => "USD (US Dollar)"),
            cardKeysProvider.overrideWith((ref) => [1]),
            selectedValuesProvider.overrideWith(
              (ref) => {1: "INR (Indian Rupee)"},
            ),
            textControllersProvider.overrideWith(
              (ref) => {1: TextEditingController(text: "100")},
            ),
            isLoadingProvider.overrideWith((ref) => false),
            calculatedAmountProvider.overrideWith((ref) => "0.00"),
          ],
        );

        final mockRates = [
          CurrencyRateEntity(
            base: "USD",
            target: "INR",
            rate: 80.0,
            date: "2024-01-01",
          ),
        ];

        when(
          mockCurrencyRateDao.getRatesByBase("USD"),
        ).thenAnswer((_) async => mockRates);

        final viewModel = container.read(currencyViewModelProvider.notifier);
        await viewModel.calculateExchangeRate();

        final calculated = container.read(calculatedAmountProvider);
        expect(calculated, "USD 1.25"); // 100 / 80 = 1.25

        container.dispose();
      },
    );

    test('throws ValidationException when no currency card is added', () async {
      SharedPreferences.setMockInitialValues({
        TextConstants.baseCurrency: "USD (US Dollar)",
      });

      container = ProviderContainer(
        overrides: [
          currencyRateRepositoryProvider.overrideWithValue(mockRepository),
          currencyRateDaoProvider.overrideWithValue(mockCurrencyRateDao),
          cardKeysProvider.overrideWith((ref) => []),
          selectedValuesProvider.overrideWith((ref) => {}),
          textControllersProvider.overrideWith((ref) => {}),
          isLoadingProvider.overrideWith((ref) => false),
        ],
      );

      final viewModel = container.read(currencyViewModelProvider.notifier);

      expect(
        () async => await viewModel.calculateExchangeRate(),
        throwsA(isA<ValidationException>()),
      );
      container.dispose();
    });

    test('removeCurrencyCard should update providers and clear controller', () {
      final viewModel = container.read(currencyViewModelProvider.notifier);
      viewModel.removeCurrencyCard(1);

      final updatedKeys = container.read(cardKeysProvider);
      expect(updatedKeys, isEmpty);

      final amount = container.read(calculatedAmountProvider);
      expect(amount, "0.00");
    });
  });
}
