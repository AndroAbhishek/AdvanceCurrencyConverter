import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const CustomText(
        text: TextConstants.selectBaseCurrency,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Pallete.whiteColor,
      ),
    );
  }
}
