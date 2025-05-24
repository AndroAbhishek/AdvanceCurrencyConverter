import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardKeysProvider = StateProvider<List<int>>((ref) => []);

final selectedValuesProvider = StateProvider<Map<int, String>>((ref) => {});

final textControllersProvider = StateProvider<Map<int, TextEditingController>>(
  (ref) => {},
);

final calculatedAmountProvider = StateProvider<String>((ref) => "0.00");

final isLoadingProvider = StateProvider<bool>((ref) => false);

final baseCurrencyProvider = StateProvider<String?>((ref) => null);
