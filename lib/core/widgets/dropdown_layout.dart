import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/utils.dart';
import 'package:advance_currency_convertor/core/widgets/custom_icon.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class DropdownLayout extends StatelessWidget {
  final String? selectedCurrency;
  final String defaultText;
  const DropdownLayout({
    super.key,
    required this.selectedCurrency,
    required this.defaultText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Pallete.greyColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: extractCurrencyCode(selectedCurrency) ?? defaultText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Pallete.whiteColor,
          ),
          const CustomIcon(icon: Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
