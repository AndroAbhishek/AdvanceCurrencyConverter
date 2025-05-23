import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        text: title,
        color: Pallete.whiteColor,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Pallete.greenColor,
      centerTitle: true,
      elevation: 0,
    );
  }
}
