import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/database/app_database.dart';
import 'package:advance_currency_convertor/features/currency_list/db/entities/currency_entity.dart';
import 'package:advance_currency_convertor/features/currency_list/model/currency_list_model.dart';
import 'package:advance_currency_convertor/features/currency_list/repositories/currency_listing_remote_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'currency_listing_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class CurrencyListingViewmodel extends _$CurrencyListingViewmodel {
  @override
  Future<CurrencyListModel> build() async {
    final dao = sl<AppDatabase>().currencyDao;
    final cached = await dao.getAllCurrencies();

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult.first != ConnectivityResult.none;

    // If there are cached currencies, return them
    // This avoids unnecessary network calls if the data is already available
    // and ensures the app can function offline
    if (cached.isNotEmpty) {
      return CurrencyListModel(
        success: true,
        symbols: {for (var e in cached) e.code: e.name},
      );
    }

    if (!hasInternet) {
      throw Exception(TextConstants.noInternentConnection);
    }

    // If no cached data is available and there is internet, fetch from remote repository
    // This is where the app fetches the latest currency data from the API
    final res =
        await sl<CurrencyListingRemoteRepository>().getCurrencyListing();

    return await res.fold((failure) async => throw failure.message, (
      currencyList,
    ) async {
      final entityList =
          currencyList.symbols.entries
              .map((e) => CurrencyEntity(code: e.key, name: e.value))
              .toList();

      await dao.insertCurrencies(entityList);
      return currencyList;
    });
  }
}
