import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/widgets/dropdown_layout.dart';
import 'package:flutter/material.dart';

// A modal widget that allows the user to select a currency from a dropdown list.
class SelectCurrencyModal extends StatelessWidget {
  final String? selectedCurrency;
  final VoidCallback onTap;

  const SelectCurrencyModal({
    super.key,
    required this.selectedCurrency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DropdownLayout(
        selectedCurrency: selectedCurrency,
        defaultText: TextConstants.select,
      ),
    );
  }
}
