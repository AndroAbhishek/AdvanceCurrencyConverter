import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String code;
  final String name;

  const CurrencyCard({super.key, required this.code, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Pallete.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Pallete.greenColor,
          child: CustomText(
            text: code,
            fontWeight: FontWeight.bold,
            color: Pallete.whiteColor,
            fontSize: 12,
          ),
        ),
        title: CustomText(
          text: name,
          fontSize: 20,
          color: Pallete.whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
