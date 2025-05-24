import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/prefs/app_preferences.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:advance_currency_convertor/core/widgets/loader.dart';
import 'package:advance_currency_convertor/features/currency_list/viewmodel/currency_listing_viewmodel.dart';
import 'package:advance_currency_convertor/features/feature_setting/view/widget/base_currency_card.dart';
import 'package:advance_currency_convertor/features/feature_setting/view/widget/header_text.dart';
import 'package:advance_currency_convertor/features/feature_setting/view/widget/select_currency_modal.dart';
import 'package:advance_currency_convertor/core/widgets/currency_selection_modal.dart';
import 'package:advance_currency_convertor/features/currency/providers/currency_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySettings extends ConsumerStatefulWidget {
  const CurrencySettings({super.key});

  @override
  ConsumerState<CurrencySettings> createState() => _CurrencySettingsState();
}

class _CurrencySettingsState extends ConsumerState<CurrencySettings> {
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    loadBaseCurrency();
  }

  Future<void> loadBaseCurrency() async {
    final savedCurrency = await AppPreferences.getString(
      TextConstants.baseCurrency,
    );
    setState(() {
      selectedCurrency = savedCurrency;
    });
  }

  Future<void> saveBaseCurrency(String value) async {
    await AppPreferences.setString(TextConstants.baseCurrency, value);
    ref.read(baseCurrencyProvider.notifier).state = value;
    resetAllCards(ref);
  }

  void resetAllCards(WidgetRef ref) {
    final textControllers = ref.read(textControllersProvider);
    for (final controller in textControllers.values) {
      controller.dispose();
    }
    ref.read(cardKeysProvider.notifier).state = [];
    ref.read(selectedValuesProvider.notifier).state = {};
    ref.read(textControllersProvider.notifier).state = {};
    ref.read(calculatedAmountProvider.notifier).state = "0.00";
  }

  void showCurrencySelectionDialog(
    BuildContext context,
    List<String> currencyOptions,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return CurrencySelectionModal(
          currencyOptions: currencyOptions,
          allowDuplicates: true,
          baseCurrency: selectedCurrency,
          onCurrencySelected: (value) {
            setState(() {
              selectedCurrency = value;
            });
            saveBaseCurrency(value);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyListingViewmodelProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currencyState.when(
          loading: () => Loader(),
          error:
              (error, _) => Center(child: CustomText(text: error.toString())),
          data: (data) {
            final symbolMap = data.symbols;
            final currencyOptions =
                symbolMap.entries
                    .map((e) => '${e.value} - (${e.key})')
                    .toList();

            if (currencyOptions.isEmpty) {
              return const Center(
                child: CustomText(text: TextConstants.noDataFound),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(),
                const SizedBox(height: 16),
                Expanded(
                  flex: 0,
                  child: SelectCurrencyModal(
                    selectedCurrency: selectedCurrency,
                    onTap:
                        () => showCurrencySelectionDialog(
                          context,
                          currencyOptions,
                        ),
                  ),
                ),
                if (selectedCurrency != null)
                  BaseCurrencyCard(currencyText: selectedCurrency!),
              ],
            );
          },
        ),
      ),
    );
  }
}
