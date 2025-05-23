import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:advance_currency_convertor/core/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

class CalculateButtonAndLabel extends StatelessWidget {
  final VoidCallback onCalculate;
  final String calculatedAmountText;

  const CalculateButtonAndLabel({
    super.key,
    required this.onCalculate,
    required this.calculatedAmountText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Pallete.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GradientButton(
                buttonText: TextConstants.calculateExchangeRate,
                onTap: onCalculate,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    text: calculatedAmountText,
                    color: Pallete.backgroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
