import 'package:advance_currency_convertor/features/currency/db/dao/currency_rate_dao.dart';
import 'package:advance_currency_convertor/features/currency/db/entities/currency_rate_entity.dart';
import 'package:advance_currency_convertor/features/currency/model/currency_rate_model.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';

class CurrencyDBService {
  final CurrencyRateDao _dao = sl<CurrencyRateDao>();

  Future<void> cacheCurrencyRates(CurrencyRateModel data) async {
    await _dao.deleteRatesByBase(data.base);

    final rateEntities =
        data.rates.entries.map((e) {
          return CurrencyRateEntity(
            base: data.base,
            target: e.key,
            rate: e.value,
            date: data.date,
          );
        }).toList();

    await _dao.insertRates(rateEntities);
  }

  Future<List<CurrencyRateEntity>> getRatesByBase(String base) {
    return _dao.getRatesByBase(base);
  }
}
