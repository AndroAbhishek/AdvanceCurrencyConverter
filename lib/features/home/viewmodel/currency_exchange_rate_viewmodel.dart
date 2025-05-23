import 'package:advance_currency_convertor/features/home/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/features/home/repositories/currency_rate_remote_repository.dart';
import 'package:advance_currency_convertor/service_locator_dependecies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'currency_exchange_rate_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class CurrencyExchangeRateViewmodel extends _$CurrencyExchangeRateViewmodel {
  @override
  FutureOr<CurrencyRateModel> build({
    required String base,
    required List<String> symbols,
  }) async {
    final res = await sl<CurrencyRateRemoteRepository>().getExchangeRates(
      base: base,
      symbols: symbols,
    );

    return res.fold((failure) => throw failure.message, (data) => data);
  }

  Future<void> refresh(String base, List<String> symbols) async {
    state = const AsyncValue.loading();

    final res = await sl<CurrencyRateRemoteRepository>().getExchangeRates(
      base: base,
      symbols: symbols,
    );

    res.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (data) {
        state = AsyncValue.data(data);
      },
    );
  }
}
