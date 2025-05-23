import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Holds card keys
final cardKeysProvider = StateProvider<List<int>>((ref) => []);

// Maps keys to currency selection
final selectedValuesProvider = StateProvider<Map<int, String>>((ref) => {});

// Maps keys to TextEditingControllers
final textControllersProvider = StateProvider<Map<int, TextEditingController>>(
  (ref) => {},
);

// Holds the calculated amount text
final calculatedAmountProvider = StateProvider<String>((ref) => "0.00");

final isLoadingProvider = StateProvider<bool>((ref) => false);

final baseCurrencyProvider = StateProvider<String?>((ref) => null);
