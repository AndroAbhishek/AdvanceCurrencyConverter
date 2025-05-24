import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/widgets/custom_icon.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class BuildAddCurrencyButton extends StatelessWidget {
  final VoidCallback onTap;
  const BuildAddCurrencyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Pallete.greenColor,
            ),
            child: const CustomIcon(icon: Icons.add, color: Pallete.whiteColor),
          ),
          const SizedBox(width: 10),
          const CustomText(
            text: TextConstants.addCurrencyText,
            fontSize: 20,
            color: Pallete.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
