import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/utils.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:advance_currency_convertor/core/widgets/loader.dart';
import 'package:advance_currency_convertor/features/currency_list/model/currency_list_model.dart';
import 'package:advance_currency_convertor/features/currency_list/viewmodel/currency_listing_viewmodel.dart';
import 'package:advance_currency_convertor/features/currency/view/widgets/build_add_currency_button.dart';
import 'package:advance_currency_convertor/features/currency/view/widgets/calculate_button_and_label.dart';
import 'package:advance_currency_convertor/features/currency/view/widgets/currency_card.dart';
import 'package:advance_currency_convertor/features/currency/providers/currency_state_provider.dart';
import 'package:advance_currency_convertor/features/currency/viewmodel/currency_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyPage extends ConsumerStatefulWidget {
  const CurrencyPage({super.key});

  @override
  ConsumerState<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends ConsumerState<CurrencyPage>
    with TickerProviderStateMixin {
  String? baseCurrency;

  @override
  void initState() {
    super.initState();
    ref.read(currencyViewModelProvider);
  }

  Future<void> handleAddCurrencyCard() async {
    try {
      await ref.read(currencyViewModelProvider.notifier).addCurrencyCard();
    } on ValidationException catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.message,
          duration: const Duration(seconds: 2),
          color: Pallete.errorColor,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.toString(),
          duration: const Duration(seconds: 2),
          color: Pallete.errorColor,
        );
      }
    }
  }

  void handleRemoveCurrencyCard(int key) async {
    ref.read(currencyViewModelProvider.notifier).removeCurrencyCard(key);
    await Future.delayed(Duration(milliseconds: 10));

    final remaining = ref.read(cardKeysProvider);
    if (remaining.isNotEmpty) {
      await ref
          .read(currencyViewModelProvider.notifier)
          .calculateExchangeRate();
    }
  }

  void handleCurrencySelection(int key, String value) {
    ref
        .read(currencyViewModelProvider.notifier)
        .updateSelectedValue(key, value);
  }

  List<String> getSelectedCurrencies() {
    return ref.read(currencyViewModelProvider.notifier).getSelectedCurrencies();
  }

  Future<void> handleCalculateExchangeRate() async {
    try {
      await ref
          .read(currencyViewModelProvider.notifier)
          .calculateExchangeRate();
    } on ValidationException catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.message,
          duration: const Duration(seconds: 2),
          color: Pallete.errorColor,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          "An error occurred while calculating exchange rates: ${e.toString()}",
          duration: const Duration(seconds: 2),
          color: Pallete.errorColor,
        );
      }
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
    final focusNodes = ref.watch(focusNodesProvider);

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _dismissKeyboard,
            behavior: HitTestBehavior.translucent,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: currencyState.when(
                  loading: () => const Loader(),
                  error:
                      (err, _) =>
                          Center(child: CustomText(text: err.toString())),
                  data:
                      (currencyList) => buildMainContent(
                        currencyList: currencyList,
                        cardKeys: cardKeys,
                        selectedValues: selectedValues,
                        textControllers: textControllers,
                        calculatedAmount: calculatedAmount,
                        baseCurrency: baseCurrency,
                        focusNodes: focusNodes,
                      ),
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

  Widget buildMainContent({
    required CurrencyListModel currencyList,
    required List<int> cardKeys,
    required Map<int, String> selectedValues,
    required Map<int, TextEditingController> textControllers,
    required String calculatedAmount,
    required String? baseCurrency,
    required Map<int, FocusNode> focusNodes,
  }) {
    final currencyOptions =
        currencyList.symbols.entries
            .map((entry) => '${entry.value} - (${entry.key})')
            .toList();

    return Column(
      children: [
        BuildAddCurrencyButton(onTap: handleAddCurrencyCard),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                        selectedCurrencies: getSelectedCurrencies(),
                        baseCurrency: baseCurrency,
                        textController: textControllers[key]!,
                        onCurrencySelected:
                            (value) => handleCurrencySelection(key, value),
                        onRemove: () => handleRemoveCurrencyCard(key),
                        focusNode: focusNodes[key]!,
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
        CalculateButtonAndLabel(
          onCalculate: handleCalculateExchangeRate,
          calculatedAmountText: calculatedAmount,
          baseCurrency: baseCurrency ?? '',
        ),
      ],
    );
  }

  void _dismissKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.unfocus();
    }
  }
}
