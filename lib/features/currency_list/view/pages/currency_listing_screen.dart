import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/utils.dart';
import 'package:advance_currency_convertor/core/widgets/custom_text.dart';
import 'package:advance_currency_convertor/core/widgets/loader.dart';
import 'package:advance_currency_convertor/core/widgets/searchable_list_view.dart';
import 'package:advance_currency_convertor/features/currency_list/view/widgets/currency_card.dart';
import 'package:advance_currency_convertor/features/currency_list/viewmodel/currency_listing_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrenciesListScreen extends ConsumerWidget {
  const CurrenciesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyState = ref.watch(currencyListingViewmodelProvider);

    ref.listen(currencyListingViewmodelProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => showSnackBar(context, error.toString()),
      );
    });

    return Scaffold(
      body: currencyState.when(
        loading: () => const Loader(),
        error: (err, _) => Center(child: CustomText(text: err.toString())),
        data: (currencyList) {
          final symbols = currencyList.symbols;

          if (symbols.isEmpty) {
            return const Center(
              child: CustomText(text: TextConstants.noDataFound),
            );
          }

          return SearchableListView<MapEntry<String, String>>(
            items: symbols.entries.toList(),
            itemLabel: (entry) => '${entry.key} ${entry.value}',
            itemBuilder: (context, entry) {
              return CurrencyCard(code: entry.key, name: entry.value);
            },
            hintText: TextConstants.searchCurrency,
          );
        },
      ),
    );
  }
}
