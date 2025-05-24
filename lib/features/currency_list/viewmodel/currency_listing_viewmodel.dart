import 'package:advance_currency_convertor/core/database/app_database.dart';
import 'package:advance_currency_convertor/features/currency_list/db/entities/currency_entity.dart';
import 'package:advance_currency_convertor/features/currency_list/model/currency_list_model.dart';
import 'package:advance_currency_convertor/features/currency_list/repositories/currency_listing_remote_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'currency_listing_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class CurrencyListingViewmodel extends _$CurrencyListingViewmodel {
  @override
  Future<CurrencyListModel> build() async {
    final dao = sl<AppDatabase>().currencyDao;
    final cached = await dao.getAllCurrencies();

    if (cached.isNotEmpty) {
      return CurrencyListModel(
        success: true,
        symbols: {for (var e in cached) e.code: e.name},
      );
    }

    final res =
        await sl<CurrencyListingRemoteRepository>().getCurrencyListing();

    return await res.fold((failure) async => throw failure.message, (
      currencyList,
    ) async {
      // Save fetched data to DB for caching
      final entityList =
          currencyList.symbols.entries
              .map((e) => CurrencyEntity(code: e.key, name: e.value))
              .toList();

      await dao.insertCurrencies(entityList);

      // Return the fresh data
      return currencyList;
    });
  }
}






// Future<void> refresh() async {
  //   state = const AsyncValue.loading();

  //   final dao = sl<AppDatabase>().currencyDao;
  //   final res =
  //       await sl<CurrencyListingRemoteRepository>().getCurrencyListing();

  //   res.fold(
  //     (failure) {
  //       state = AsyncValue.error(failure.message, StackTrace.current);
  //     },
  //     (currencyList) async {
  //       // Update local cache in DB
  //       final entityList =
  //           currencyList.symbols.entries
  //               .map((e) => CurrencyEntity(code: e.key, name: e.value))
  //               .toList();

  //       await dao.clearCurrencies(); // Clear old data before inserting new
  //       await dao.insertCurrencies(entityList);

  //       state = AsyncValue.data(currencyList);
  //     },
  //   );
  // }
