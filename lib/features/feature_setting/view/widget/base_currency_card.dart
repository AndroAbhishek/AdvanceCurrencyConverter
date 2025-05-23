import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BaseCurrencyCard extends StatelessWidget {
  final String currencyText;

  const BaseCurrencyCard({super.key, required this.currencyText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Pallete.greenColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(
                text: TextConstants.baseCurrencyText,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Pallete.whiteColor,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: currencyText,
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Pallete.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
