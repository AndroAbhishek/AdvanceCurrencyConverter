import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/database/app_database.dart';
import 'package:advance_currency_convertor/core/prefs/app_preferences.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/utils.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:advance_currency_convertor/core/widgets/loader.dart';
import 'package:advance_currency_convertor/features/currency_list/viewmodel/currency_listing_viewmodel.dart';
import 'package:advance_currency_convertor/features/home/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/features/home/view/widgets/build_add_currency_button.dart';
import 'package:advance_currency_convertor/features/home/view/widgets/calculate_button_and_label.dart';
import 'package:advance_currency_convertor/features/home/view/widgets/currency_card.dart';
import 'package:advance_currency_convertor/features/home/viewmodel/currency_exchange_rate_viewmodel.dart';
import 'package:advance_currency_convertor/features/home/providers/home_state_provider.dart';
import 'package:advance_currency_convertor/service_locator_dependecies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  String? baseCurrency;

  @override
  void initState() {
    super.initState();
    loadBaseCurrency(); // Load base currency on init
  }

  Future<void> loadBaseCurrency() async {
    final savedCurrency = await AppPreferences.getString(
      TextConstants.baseCurrency,
    );
    // Update using Riverpod provider
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
        return "Please enter a valid positive amount.";
      }
    }
    return null;
  }

  void addCurrencyCard() {
    final cardKeys = ref.read(cardKeysProvider);
    final textControllers = ref.read(textControllersProvider);

    final validationError = validateAllCards();

    if (validationError != null) {
      showSnackBar(
        context,
        validationError,
        duration: const Duration(seconds: 4),
        color: Pallete.errorColor,
      );
      return;
    }
    final nextKey = (cardKeys.isNotEmpty ? cardKeys.last + 1 : 1);
    ref.read(cardKeysProvider.notifier).state = [...cardKeys, nextKey];
    ref.read(textControllersProvider.notifier).state = {
      ...textControllers,
      nextKey: TextEditingController(),
    };
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
      ref.read(calculatedAmountProvider.notifier).state = "0.00";
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

  Future<void> onCalculateExchangeRate() async {
    final cardKeys = ref.read(cardKeysProvider);
    final selectedValues = ref.read(selectedValuesProvider);
    final textControllers = ref.read(textControllersProvider);
    final loadingNotifier = ref.read(isLoadingProvider.notifier);

    // Check if any currency card added
    if (cardKeys.isEmpty) {
      showSnackBar(
        context,
        "Please add at least one currency to convert.",
        color: Pallete.errorColor,
      );
      return;
    }

    // Use the reusable validation method
    final validationError = validateAllCards();

    if (validationError != null) {
      showSnackBar(
        context,
        validationError,
        duration: const Duration(seconds: 4),
        color: Pallete.errorColor,
      );
      return;
    }

    // Get base currency from provider (use cached value or fetch again)
    String? savedCurrency = ref.read(baseCurrencyProvider);
    if (savedCurrency == null) {
      savedCurrency = await AppPreferences.getString(
        TextConstants.baseCurrency,
      );
      // Update the provider
      ref.read(baseCurrencyProvider.notifier).state = savedCurrency;
    }

    final base = extractCurrencyCode(savedCurrency);

    if (base == null || base.isEmpty) {
      if (mounted) {
        showSnackBar(
          context,
          "Base currency not found. Please set your base currency in settings.",
          color: Pallete.errorColor,
        );
      }
      return;
    }

    // Extract unique target currencies (excluding base currency)
    final targetCurrencies =
        selectedValues.values
            .where((value) => value.isNotEmpty)
            .map((value) => extractCurrencyCode(value))
            .where((code) => code != null && code != base)
            .cast<String>()
            .toSet()
            .toList();

    debugPrint("Base: $base, Targets: $targetCurrencies");

    if (targetCurrencies.isEmpty) {
      if (mounted) {
        showSnackBar(
          context,
          "Please select at least one target currency different from your base currency ($base).",
          color: Pallete.errorColor,
        );
      }
      return;
    }

    // Only set loading to true after all validation checks pass
    loadingNotifier.state = true;

    try {
      final dao = sl<AppDatabase>().currencyRateDao;

      // 1. Check if we have rates for this base currency in DB
      final storedRates = await dao.getRatesByBase(base);

      // 2. Check if all target currencies are available in stored rates
      final storedTargets = storedRates.map((e) => e.target).toSet();
      final allTargetsAvailable = targetCurrencies.every(
        (target) => storedTargets.contains(target),
      );

      CurrencyRateModel result;

      if (allTargetsAvailable && storedRates.isNotEmpty) {
        // 3. If all targets available, use DB rates
        debugPrint("Using rates from local database");

        // Convert stored entities to the same format as API response
        final ratesMap = {for (var e in storedRates) e.target: e.rate};
        result = CurrencyRateModel(
          base: base,
          rates: ratesMap,
          date: storedRates.first.date, // assuming all have same date
          success: true,
          timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        );
      } else {
        // 4. If any target missing or no data, fetch from API
        debugPrint("Fetching rates from API");

        result = await ref.read(
          currencyExchangeRateViewModelProvider(
            base: base,
            symbols: targetCurrencies,
          ).future,
        );
      }

      if (!mounted) return;

      if (!result.success) {
        showSnackBar(
          context,
          "Failed to fetch exchange rates. Please try again.",
          color: Pallete.errorColor,
        );
        return;
      }

      // Calculate total amount in base currency
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

      ref.read(calculatedAmountProvider.notifier).state =
          "${base.toUpperCase()} ${totalBaseAmount.toStringAsFixed(2)}";
    } catch (e) {
      debugPrint("Error in onCalculateExchangeRate: $e");
      if (mounted) {
        showSnackBar(
          context,
          "An error occurred while calculating exchange rates: ${e.toString()}",
          color: Pallete.errorColor,
        );
      }
    } finally {
      loadingNotifier.state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyListingViewmodelProvider);
    final cardKeys = ref.watch(cardKeysProvider);
    final selectedValues = ref.watch(selectedValuesProvider);
    final textControllers = ref.watch(textControllersProvider);
    final calculatedAmount = ref.watch(calculatedAmountProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final baseCurrency = ref.watch(baseCurrencyProvider);

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.unfocus();
              }
            },
            behavior: HitTestBehavior.translucent,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: currencyState.when(
                  loading: () => const Loader(),
                  error:
                      (err, _) =>
                          Center(child: CustomText(text: err.toString())),
                  data: (currencyList) {
                    final currencyOptions =
                        currencyList.symbols.entries
                            .map((entry) => '${entry.value} - (${entry.key})')
                            .toList();

                    return Column(
                      children: [
                        BuildAddCurrencyButton(onTap: addCurrencyCard),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Column(
                                children:
                                    cardKeys.map((key) {
                                      return CurrencyCard(
                                        key: ValueKey(key),
                                        selectedValue: selectedValues[key],
                                        currencyOptions: currencyOptions,
                                        selectedCurrencies:
                                            getSelectedCurrencies(),
                                        baseCurrency: baseCurrency,
                                        textController: textControllers[key]!,
                                        onCurrencySelected:
                                            (value) =>
                                                updateSelectedValue(key, value),
                                        onRemove: () => removeCurrencyCard(key),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                        CalculateButtonAndLabel(
                          onCalculate: onCalculateExchangeRate,
                          calculatedAmountText: calculatedAmount,
                          baseCurrency: baseCurrency ?? '',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Overlay loader when loading
          if (isLoading)
            const Opacity(
              opacity: 0.6,
              child: ModalBarrier(dismissible: false, color: Colors.black54),
            ),
          if (isLoading) const Center(child: Loader()),
        ],
      ),
    );
  }
}
