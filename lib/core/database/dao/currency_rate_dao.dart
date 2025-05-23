import 'package:advance_currency_convertor/core/database/entities/currency_rate_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class CurrencyRateDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRates(List<CurrencyRateEntity> rates);

  @Query('SELECT * FROM currency_rates WHERE base = :base')
  Future<List<CurrencyRateEntity>> getRatesByBase(String base);

  @Query('DELETE FROM currency_rates WHERE base = :base')
  Future<void> deleteRatesByBase(String base);
}
