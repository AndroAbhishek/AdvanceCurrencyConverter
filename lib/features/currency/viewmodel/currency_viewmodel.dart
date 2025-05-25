import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/database/app_database.dart';
import 'package:advance_currency_convertor/core/prefs/app_preferences.dart';
import 'package:advance_currency_convertor/core/utils.dart';
import 'package:advance_currency_convertor/features/currency/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/features/currency/providers/currency_provider.dart';
import 'package:advance_currency_convertor/features/currency/providers/currency_state_provider.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'currency_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class CurrencyViewModel extends _$CurrencyViewModel {
  @override
  FutureOr<void> build() async {
    await loadBaseCurrency();
  }

  Future<void> loadBaseCurrency() async {
    final savedCurrency = await AppPreferences.getString(
      TextConstants.baseCurrency,
    );

    ref.read(baseCurrencyProvider.notifier).state = savedCurrency;
  }

  String? validateAllCards() {
    final cardKeys = ref.read(cardKeysProvider);
    final selectedValues = ref.read(selectedValuesProvider);
    final textControllers = ref.read(textControllersProvider);

    for (int key in cardKeys) {
      final amount = textControllers[key]?.text.trim() ?? '';
      final currency = selectedValues[key] ?? '';

      if (amount.isEmpty && currency.isEmpty) {
        return TextConstants.amountCurrencyValidation;
      } else if (amount.isEmpty) {
        return TextConstants.amountValidation;
      } else if (currency.isEmpty) {
        return TextConstants.currencyValidation;
      }

      final parsedAmount = double.tryParse(amount);
      if (parsedAmount == null || parsedAmount <= 0) {
        return TextConstants.positiveAmountValidation;
      }
    }
    return null;
  }

  Future<void> addCurrencyCard() async {
    await checkIfBaseCurrencyExists();

    final cardKeys = ref.read(cardKeysProvider);
    final textControllers = ref.read(textControllersProvider);
    final focusNodes = ref.read(focusNodesProvider);

    final validationError = validateAllCards();
    if (validationError != null) {
      throw ValidationException(validationError);
    }

    final nextKey = (cardKeys.isNotEmpty ? cardKeys.last + 1 : 1);
    ref.read(cardKeysProvider.notifier).state = [...cardKeys, nextKey];
    ref.read(textControllersProvider.notifier).state = {
      ...textControllers,
      nextKey: TextEditingController(),
    };
    final newFocusNode = FocusNode();
    ref.read(focusNodesProvider.notifier).state = {
      ...focusNodes,
      nextKey: newFocusNode,
    };

    // Delay to allow UI to rebuild, then request focus
    Future.delayed(Duration(milliseconds: 100), () {
      newFocusNode.requestFocus();
    });
  }

  Future<void> checkIfBaseCurrencyExists() async {
    String? savedCurrency = ref.read(baseCurrencyProvider);
    if (savedCurrency == null) {
      savedCurrency = await AppPreferences.getString(
        TextConstants.baseCurrency,
      );
      ref.read(baseCurrencyProvider.notifier).state = savedCurrency;
    }

    final base = extractCurrencyCode(savedCurrency);
    if (base == null || base.isEmpty) {
      throw ValidationException(TextConstants.baseCurrencyNotFound);
    }
  }

  void removeCurrencyCard(int key) {
    final cardKeys = ref.read(cardKeysProvider);
    final selectedValues = ref.read(selectedValuesProvider);
    final textControllers = ref.read(textControllersProvider);

    textControllers[key]?.dispose();

    ref.read(cardKeysProvider.notifier).state =
        cardKeys.where((k) => k != key).toList();
    ref.read(selectedValuesProvider.notifier).state = {
      for (var entry in selectedValues.entries)
        if (entry.key != key) entry.key: entry.value,
    };

    final updatedControllers = {...textControllers};
    updatedControllers.remove(key);
    ref.read(textControllersProvider.notifier).state = updatedControllers;

    if (ref.read(cardKeysProvider).isEmpty) {
      ref.read(calculatedAmountProvider.notifier).state =
          TextConstants.defaultCurrency;
    }
  }

  void updateSelectedValue(int key, String value) {
    final selectedValues = ref.read(selectedValuesProvider);
    ref.read(selectedValuesProvider.notifier).state = {
      ...selectedValues,
      key: value,
    };
  }

  List<String> getSelectedCurrencies() {
    final values = ref.read(selectedValuesProvider).values;
    return values.where((v) => v.isNotEmpty).toList();
  }

  Future<void> calculateExchangeRate() async {
    final cardKeys = ref.read(cardKeysProvider);
    final selectedValues = ref.read(selectedValuesProvider);
    final textControllers = ref.read(textControllersProvider);
    final loadingNotifier = ref.read(isLoadingProvider.notifier);

    try {
      // Check if any currency card added
      if (cardKeys.isEmpty) {
        throw ValidationException(TextConstants.addAtleaseOneCurrency);
      }

      // Validate all cards
      final validationError = validateAllCards();
      if (validationError != null) {
        throw ValidationException(validationError);
      }

      // Get base currency
      String? savedCurrency = ref.read(baseCurrencyProvider);
      if (savedCurrency == null) {
        savedCurrency = await AppPreferences.getString(
          TextConstants.baseCurrency,
        );
        ref.read(baseCurrencyProvider.notifier).state = savedCurrency;
      }

      final base = extractCurrencyCode(savedCurrency);
      if (base == null || base.isEmpty) {
        throw ValidationException(TextConstants.baseCurrencyNotFound);
      }

      // Extract unique target currencies
      final targetCurrencies =
          selectedValues.values
              .where((value) => value.isNotEmpty)
              .map((value) => extractCurrencyCode(value))
              .where((code) => code != null && code != base)
              .cast<String>()
              .toSet()
              .toList();

      if (targetCurrencies.isEmpty) {
        throw ValidationException("${TextConstants.targetCurrency} ($base).");
      }

      loadingNotifier.state = true;

      final result = await _getExchangeRates(base, targetCurrencies);

      if (!result.success) {
        throw Exception(TextConstants.failedToFetchExchangeRates);
      }

      // Calculate total amount in base currency
      final totalBaseAmount = _calculateTotalBaseAmount(
        cardKeys,
        selectedValues,
        textControllers,
        base,
        result,
      );

      ref.read(calculatedAmountProvider.notifier).state = totalBaseAmount
          .toStringAsFixed(2);
    } catch (e) {
      rethrow;
    } finally {
      loadingNotifier.state = false;
    }
  }

  Future<CurrencyRateModel> _getExchangeRates(
    String base,
    List<String> targetCurrencies,
  ) async {
    final dao = sl<AppDatabase>().currencyRateDao;

    // Check if we have rates for this base currency in DB
    final storedRates = await dao.getRatesByBase(base);

    // Check if all target currencies are available in stored rates
    final storedTargets = storedRates.map((e) => e.target).toSet();
    final allTargetsAvailable = targetCurrencies.every(
      (target) => storedTargets.contains(target),
    );

    if (allTargetsAvailable && storedRates.isNotEmpty) {
      // Use DB rates
      final ratesMap = {for (var e in storedRates) e.target: e.rate};
      return CurrencyRateModel(
        base: base,
        rates: ratesMap,
        date: storedRates.first.date,
        success: true,
        timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
    } else {
      return await fetchExchangeRatesFromAPI(base, targetCurrencies);
    }
  }

  double _calculateTotalBaseAmount(
    List<int> cardKeys,
    Map<int, String> selectedValues,
    Map<int, TextEditingController> textControllers,
    String base,
    CurrencyRateModel result,
  ) {
    double totalBaseAmount = 0.0;

    for (int key in cardKeys) {
      final selectedCurrency = selectedValues[key];
      final amountText = textControllers[key]?.text.trim() ?? '';
      final amount = double.tryParse(amountText);

      if (selectedCurrency != null && amount != null) {
        final currencyCode = extractCurrencyCode(selectedCurrency);

        if (currencyCode == base) {
          totalBaseAmount += amount;
        } else if (currencyCode != null &&
            result.rates.containsKey(currencyCode)) {
          // Convert from target currency to base currency
          final rate = result.rates[currencyCode]!;
          totalBaseAmount += amount / rate;
        }
      }
    }

    return totalBaseAmount;
  }

  Future<CurrencyRateModel> fetchExchangeRatesFromAPI(
    String base,
    List<String> symbols,
  ) async {
    final repository = ref.read(currencyRateRepositoryProvider);

    final result = await repository.getExchangeRates(
      base: base,
      symbols: symbols,
    );

    return result.fold((failure) => throw failure.message, (data) => data);
  }
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => message;
}
