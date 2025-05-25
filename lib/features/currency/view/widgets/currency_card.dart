import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/widgets/custom_icon.dart';
import 'package:advance_currency_convertor/core/widgets/dropdown_layout.dart';
import 'package:advance_currency_convertor/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/currency_selection_modal.dart';

class CurrencyCard extends StatelessWidget {
  final String? selectedValue;
  final List<String> currencyOptions;
  final ValueChanged<String> onCurrencySelected;
  final VoidCallback onRemove;
  final List<String>? selectedCurrencies;
  final TextEditingController textController;
  final String? baseCurrency;
  final FocusNode focusNode;

  const CurrencyCard({
    super.key,
    required this.selectedValue,
    required this.currencyOptions,
    required this.onCurrencySelected,
    required this.onRemove,
    required this.textController,
    this.selectedCurrencies,
    this.baseCurrency,
    required this.focusNode,
  });

  void showCurrencySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CurrencySelectionModal(
          currencyOptions: currencyOptions,
          selectedCurrencies: selectedCurrencies,
          allowDuplicates: false,
          baseCurrency: baseCurrency,
          onCurrencySelected: (value) {
            onCurrencySelected(value);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomTextfield(
                  controller: textController,
                  hintText: TextConstants.enterAmountTextField,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  textInputAction: TextInputAction.done,
                  focusNode: focusNode,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => showCurrencySelectionDialog(context),
                  child: DropdownLayout(
                    selectedCurrency: selectedValue,
                    defaultText: TextConstants.selectText,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onRemove,
                child: const CustomIcon(
                  icon: Icons.delete,
                  color: Pallete.errorColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
