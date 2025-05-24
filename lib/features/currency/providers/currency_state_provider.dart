import 'package:advance_currency_convertor/core/database/app_database.dart';
import 'package:advance_currency_convertor/features/currency/db/dao/currency_rate_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardKeysProvider = StateProvider<List<int>>((ref) => []);

final selectedValuesProvider = StateProvider<Map<int, String>>((ref) => {});

final textControllersProvider = StateProvider<Map<int, TextEditingController>>(
  (ref) => {},
);

final focusNodesProvider = StateProvider<Map<int, FocusNode>>((ref) => {});

final calculatedAmountProvider = StateProvider<String>((ref) => "0.00");

final isLoadingProvider = StateProvider<bool>((ref) => false);

final baseCurrencyProvider = StateProvider<String?>((ref) => null);

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  // Normally you'd initialize it with a real DB here
  throw UnimplementedError();
});
final currencyRateDaoProvider = Provider<CurrencyRateDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.currencyRateDao;
});
