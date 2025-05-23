import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/utils.dart';
import 'package:advance_currency_convertor/core/widgets/custom_icon.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:advance_currency_convertor/core/widgets/searchable_list_view.dart';
import 'package:flutter/material.dart';

class CurrencySelectionModal extends StatelessWidget {
  final List<String> currencyOptions;
  final ValueChanged<String> onCurrencySelected;
  final List<String>? selectedCurrencies;
  final bool allowDuplicates;
  final String? baseCurrency;

  const CurrencySelectionModal({
    super.key,
    required this.currencyOptions,
    required this.onCurrencySelected,
    this.selectedCurrencies,
    this.allowDuplicates = true,
    this.baseCurrency,
  });

  void handleCurrencySelection(String item, BuildContext context) {
    // Check if this is the base currency - if so, don't allow selection
    if (baseCurrency != null) {
      String baseCurrencyCode = extractCurrencyCode(baseCurrency!) ?? '';
      String itemCode = extractCurrencyCode(item) ?? '';
      if (baseCurrencyCode == itemCode) {
        return; // Don't allow selection of base currency
      }
    }

    if (!allowDuplicates && selectedCurrencies != null) {
      bool isDuplicate = selectedCurrencies!.any((selected) {
        String selectedCode = extractCurrencyCode(selected) ?? '';
        String itemCode = extractCurrencyCode(item) ?? '';
        return selectedCode == itemCode;
      });

      if (isDuplicate) {
        showSnackBar(
          context,
          TextConstants.alreadySelected,
          duration: const Duration(seconds: 2),
          color: Pallete.errorColor,
        );
        return;
      }
    }
    onCurrencySelected(item);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: CustomText(
          text: TextConstants.selectCurrency,
          color: Pallete.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: SearchableListView<String>(
          items: currencyOptions,
          itemLabel: (item) => item,
          hintText: TextConstants.searchByCurrencyCode,
          itemBuilder: (context, item) {
            bool isAlreadySelected = false;
            bool isBaseCurrency = false;

            if (baseCurrency != null) {
              String baseCurrencyCode =
                  extractCurrencyCode(baseCurrency!) ?? '';
              String itemCode = extractCurrencyCode(item) ?? '';
              isBaseCurrency = baseCurrencyCode == itemCode;
            }
            if (!allowDuplicates && selectedCurrencies != null) {
              isAlreadySelected = selectedCurrencies!.any((selected) {
                String selectedCode = extractCurrencyCode(selected) ?? '';
                String itemCode = extractCurrencyCode(item) ?? '';
                return selectedCode == itemCode;
              });
            }
            return ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: item,
                      color:
                          (isAlreadySelected || isBaseCurrency)
                              ? Pallete.greyColor
                              : Pallete.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isBaseCurrency) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Pallete.gradient1,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Pallete.gradient3, width: 1),
                      ),
                      child: const CustomText(
                        text: "Base",
                        color: Pallete.whiteColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
              trailing:
                  isBaseCurrency
                      ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Pallete.gradient1,
                          border: Border.all(
                            color: Pallete.gradient3,
                            width: 2,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: CustomIcon(
                            icon: Icons.check,
                            color: Pallete.greenColor,
                            size: 16,
                          ),
                        ),
                      )
                      : isAlreadySelected
                      ? const CustomIcon(
                        icon: Icons.check_circle,
                        color: Pallete.greenColor,
                      )
                      : null,
              onTap: () => handleCurrencySelection(item, context),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: const CustomText(
            text: TextConstants.close,
            color: Pallete.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
