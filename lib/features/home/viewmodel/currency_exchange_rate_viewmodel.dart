import 'package:advance_currency_convertor/features/home/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/features/home/providers/currency_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'currency_exchange_rate_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class CurrencyExchangeRateViewModel extends _$CurrencyExchangeRateViewModel {
  @override
  FutureOr<CurrencyRateModel> build({
    required String base,
    required List<String> symbols,
  }) async {
    final repository = ref.read(currencyRateRepositoryProvider);

    final result = await repository.getExchangeRates(
      base: base,
      symbols: symbols,
    );

    return result.fold((failure) => throw failure.message, (data) => data);
  }
}
