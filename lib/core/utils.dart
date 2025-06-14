import 'dart:io';

import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

final List<String> titles = [
  TextConstants.currencyList,
  TextConstants.currencyConverter,
  TextConstants.settings,
];

void showSnackBar(
  BuildContext context,
  String content, {
  Duration duration = const Duration(seconds: 2),
  Color? color,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: CustomText(text: content, color: Pallete.whiteColor),
        duration: duration,
        backgroundColor: color,
      ),
    );
}

String? extractCurrencyCode(String? value) {
  if (value == null) return null;

  final start = value.lastIndexOf('(');
  final end = value.lastIndexOf(')');

  if (start != -1 && end != -1 && end > start) {
    final code = value.substring(start + 1, end);
    if (code.length == 3) return code;
  }

  return null;
}

Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text(TextConstants.error),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(TextConstants.ok),
            ),
          ],
        ),
  );
}

Future<bool> hasActiveInternetConnection() async {
  try {
    final result = await InternetAddress.lookup(TextConstants.google);
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
